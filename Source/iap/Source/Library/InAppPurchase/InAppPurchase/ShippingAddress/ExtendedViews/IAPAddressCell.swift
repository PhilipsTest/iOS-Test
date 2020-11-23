/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

protocol IAPUserSelectionProtocol: class{
    func userSelectedRadioButton(_ inSender:IAPAddressCell);
    func userSelectedUseThisOption(_ inSender:IAPAddressCell);
    func userSelectedEdit(_ inSender:IAPAddressCell);
    func userSelectedDelete(_ inSender:IAPAddressCell);
}

extension IAPUserSelectionProtocol where Self : IAPPaymentDecorator {
    //This is the default Implementation for Payment decorator as it does not have editing.
    func userSelectedEdit(_ inSender:IAPAddressCell) {
        
    }
}

class IAPAddressCell: UITableViewCell, UIDRadioButtonDelegate {
    
    weak var delegate: IAPUserSelectionProtocol?
    
    @IBOutlet weak var addressInfoLabel: UIDLabel!
    @IBOutlet weak var radioButton: UIDRadioButton!
    @IBOutlet weak var topButton: UIDButton!
    @IBOutlet weak var editButton: UIDButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var separatorView: UIDSeparator!
    
    @IBOutlet weak var buttonViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewBottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        radioButton.delegate = self
        topButton.setTitle(IAPLocalizedString("iap_deliver_to_this_address"), for: .normal)
        editButton.setTitle(IAPLocalizedString("iap_edit"), for: .normal)
        deleteButton.setTitle(IAPLocalizedString("iap_delete"), for: .normal)
    }
    
    func radioButtonPressed(_ radioButton: UIDRadioButton) {
        if radioButton.isSelected {
            delegate?.userSelectedRadioButton(self)
        }
    }
    
    @IBAction func editButtonClicked(_ sender: AnyObject) {
        delegate?.userSelectedEdit(self)
    }
    
    @IBAction func deleteButtonClicked(_ sender: AnyObject) {
        delegate?.userSelectedDelete(self)
    }
    
    @IBAction func titleEditButtonTapped(_ sender: AnyObject) {
        self.delegate?.userSelectedEdit(self)
    }
    
    @IBAction func deliverToAddressClicked(_ sender: AnyObject) {
        self.delegate?.userSelectedUseThisOption(self)
    }
    
}
