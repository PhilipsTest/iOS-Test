/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import PhilipsUIKitDLS

class IAPAddressDecorator: NSObject, UITableViewDataSource, UITableViewDelegate, IAPUserSelectionProtocol {
    weak var delegate: IAPAddressDecoratorProtocol?
    var address = [IAPUserAddress]()
    fileprivate var addressTableView: UITableView!
    fileprivate var pastIndexSelected: Int = 0
    
    convenience init(withTableView: UITableView) {
        self.init()
        self.addressTableView = withTableView
        self.addressTableView.rowHeight = UITableView.automaticDimension
        self.addressTableView.estimatedRowHeight = IAPConstants.IAPAddressCellConstants.kRowHeightConstant
        self.addressTableView.register(UINib(nibName: IAPNibName.IAPAddressCell,
                                             bundle: IAPUtility.getBundle()),
                                       forCellReuseIdentifier: IAPCellIdentifier.AddressCell)
        addressTableView.register(UINib(nibName: IAPNibName.IAPSingleListItemCell, bundle: IAPUtility.getBundle()),
                                  forCellReuseIdentifier: IAPCellIdentifier.IAPSingleListItemCell)
        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self
    }
    
    func reloadDataForAddresses() {
        pastIndexSelected = 0 // Making first index as default selected for refresh loading
        self.addressTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row == address.count else {
            return UITableView.automaticDimension
        }
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.address.count + 1 //Extra one more row for "Add new address" cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row == address.count else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: IAPCellIdentifier.AddressCell, for: indexPath) as? IAPAddressCell else {
                return UITableViewCell(frame: .zero)
            }
            let addressObject = address[indexPath.row]
            if pastIndexSelected == indexPath.row {
                cell.radioButton.isSelected = true
            } else {
                cell.radioButton.isSelected = false
            }
            cell.addressInfoLabel.attributedText = addressObject.getDisplayTextForAddress(true)
            cell.delegate = self
            
            if pastIndexSelected != indexPath.row {
                cell.buttonViewBottomConstraint.constant = 16.0
                cell.buttonViewHeightConstraint.constant = 0.0
            } else {
                cell.buttonViewBottomConstraint.constant = 0.0//IAPConstants.IAPAddressCellConstants.kButtonViewBottomConstant
                cell.buttonViewHeightConstraint.constant = IAPConstants.IAPAddressCellConstants.kButtonViewHeightConstant
            }
            cell.deleteButton.isEnabled = self.address.count > 1 ? true:false
            cell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
            return cell
        }
        
        guard let lastCell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.IAPSingleListItemCell) as? IAPSingleListItemCell else {
            return UITableViewCell(frame: .zero)
        }
        lastCell.cellContextTitle.text = IAPLocalizedString("iap_add_new_address")!
        lastCell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        return lastCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == address.count else {
            return
        }
        let selectedAddress = address.count>0 ? address[0] : nil
        delegate?.didSelectAddAddress(selectedAddress)
    }
    
    // MARK:
    // MARK: User selection protocol methods
    // MARK:
    func userSelectedRadioButton(_ inSender: IAPAddressCell) {
        /*let arr = self.address.filter {
         $0.defaultAddress == true
         }
         if let objectToChange = arr.first {
         objectToChange.defaultAddress = !objectToChange.defaultAddress
         }*/
        
        
        let pastIndexPath = IndexPath(item: pastIndexSelected, section: 0)
        let pastAddressSelected = address[pastIndexPath.row]
        pastAddressSelected.defaultAddress = false
        
        
        if let indexPath = self.addressTableView.indexPath(for: inSender) {
            pastIndexSelected = indexPath.row
            let addressSelected = address[indexPath.row]
            addressSelected.defaultAddress = true
            addressTableView.reloadRows(at: [pastIndexPath, indexPath], with: UITableView.RowAnimation.fade)
        }        
    }
    
    func userSelectedEdit(_ inSender: IAPAddressCell) {
        if let indexPath = self.addressTableView.indexPath(for: inSender) {
            let addressSelected = address[indexPath.row]
            delegate?.didSelectEditAddress(addressSelected)
        }
    }
    
    func userSelectedDelete(_ inSender: IAPAddressCell) {
        if let indexPath = self.addressTableView.indexPath(for: inSender) {
            let addressSelected = address[indexPath.row]
            delegate?.didSelectDeleteAddress(addressSelected)
        }
    }
    
    func userSelectedUseThisOption(_ inSender: IAPAddressCell) {
        if let indexPath = self.addressTableView.indexPath(for: inSender) {
            let addressSelected = address[indexPath.row]
            delegate?.didSelectDeliverToAddress(addressSelected)
        }
    }
    
    func userSelectedAddNewOption(_ inSender: IAPAddressCell) {
        if let indexPath = self.addressTableView.indexPath(for: inSender) {
            let addressSelected = address[indexPath.row]
            self.delegate?.didSelectAddAddress(addressSelected)
        }
    }
}
