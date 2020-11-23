/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */
import Foundation
import PhilipsUIKitDLS

protocol IAPPaymentDecoratorProtocol: class {
    func didSelectAddNewPaymentMethod()
    func didSelectUseThisPaymentMethod(_ selectedPayment: IAPPaymentInfo)
}

class IAPPaymentDecorator: NSObject, UITableViewDataSource, UITableViewDelegate, IAPPaymentSelectionProtocol {
    weak var delegate: IAPPaymentDecoratorProtocol?
    fileprivate var paymentDetails: [IAPPaymentInfo]!
    fileprivate var paymentTableView: UITableView!
    fileprivate var pastIndexSelected: Int = 0
    
    convenience init(withTableView: UITableView, withPayments: [IAPPaymentInfo]) {
        self.init()
        paymentDetails = withPayments
        paymentTableView = withTableView
        paymentTableView.estimatedRowHeight = 150.0
        paymentTableView.rowHeight = UITableView.automaticDimension
        paymentTableView.register(UINib(nibName: IAPNibName.IAPPaymentSelectionCell,
                                        bundle: IAPUtility.getBundle()),
                                  forCellReuseIdentifier: IAPCellIdentifier.IAPPaymentSelectionCell)
        paymentTableView.register(UINib(nibName: IAPNibName.IAPSingleListItemCell,
                                        bundle: IAPUtility.getBundle()),
                                  forCellReuseIdentifier: IAPCellIdentifier.IAPSingleListItemCell)
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentDetails.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row == paymentDetails.count else {
            return UITableView.automaticDimension
        }
        return IAPConstants.IAPPaymentSelectionDecoratorConstants.kHeaderHeightConstant
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row == paymentDetails.count else {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: IAPCellIdentifier.IAPPaymentSelectionCell) as? IAPPaymentSelectionCell {
                let paymentObject = self.paymentDetails[indexPath.row]
                cell.radioButton.isSelected = paymentObject.getDefaultPayment()
                cell.paymentInfoLabel.attributedText = self.getDisplayTextWithPaymentInfo(paymentObject)
                cell.useThisPaymentButton.setTitle(IAPLocalizedString("iap_use_payment_method"), for: .normal)
                cell.paymentSelectionDelegate = self

                if paymentObject.getDefaultPayment() == false {
                    cell.useThisBtnBottomConstraint.constant = 0.0
                    cell.useThisBtnHeightConstraint.constant = 0.0
                } else {
                    cell.useThisBtnBottomConstraint.constant = 28.0
                    cell.useThisBtnHeightConstraint.constant = 40.0
                }
                cell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
                return cell
            } else {
                return UITableViewCell(frame: .zero)
            }
        }
        
        if let lastCell = tableView.dequeueReusableCell(withIdentifier: IAPCellIdentifier.IAPSingleListItemCell) as? IAPSingleListItemCell {
            lastCell.cellContextTitle.text = IAPLocalizedString("iap_add_new_payment_method")
            lastCell.contentView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
            return lastCell
        }else {
            return UITableViewCell(frame: .zero)
        }
    }

    func getDisplayTextWithPaymentInfo(_ inPayment: IAPPaymentInfo)-> NSMutableAttributedString {
        let cardTypeString = inPayment.getCardType() + " "
        let nameString      = cardTypeString + " " + inPayment.getCardnumber()+"\n"
        let accHolderName = inPayment.getAccountHolderName() + "\n" + IAPLocalizedString("iap_valid_until")!
        let paymentInfoString = accHolderName + " " + inPayment.getExpiryMonth() + "/" + inPayment.getExpiryYear()
        let style = NSMutableParagraphStyle()
        style.lineSpacing = IAPConstants.IAPPaymentSelectionDecoratorConstants.kLineSpacingCosntant
        let nameFont = UIFont(uidFont: .book, size: UIDFontSizeMedium)
        let nameColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        let nameAttribute : [NSAttributedString.Key:AnyObject] = [.paragraphStyle: style,
                                                                 .font: nameFont!,
                                                                 .foregroundColor: nameColor!]
        let stringToBeReturned = NSMutableAttributedString(string: nameString as String, attributes: nameAttribute)
        let paymentInfoFont = UIFont(uidFont: .book, size: UIDFontSizeSmall)
        let paymentInfoColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        let paymentInfoAttribute : [NSAttributedString.Key:AnyObject] = [.paragraphStyle: style,
                                                                        .font: paymentInfoFont!,
                                                                        .foregroundColor: paymentInfoColor!]
        let paymentInfoAttributedString = NSMutableAttributedString(string: paymentInfoString, attributes: paymentInfoAttribute)
        stringToBeReturned.append(paymentInfoAttributedString)
        return stringToBeReturned
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == paymentDetails.count else {
            return
        }
        //User should navigate to billing address screen
        self.delegate?.didSelectAddNewPaymentMethod()
    }
    
    // MARK: User selection protocol methods

    func radioButtonSelected(_ inSender: IAPPaymentSelectionCell) {
        let pastIndexPath = IndexPath(item: pastIndexSelected, section: 0)
        let pastPaymentSelected = paymentDetails[pastIndexPath.row]
        pastPaymentSelected.defaultPayment = false
        if let indexPath = paymentTableView.indexPath(for: inSender){
            pastIndexSelected = indexPath.row
            let paymentSelected = paymentDetails[indexPath.row]
            paymentSelected.defaultPayment = true
            //paymentTableView.reloadData()
            paymentTableView.reloadRows(at: [pastIndexPath, indexPath], with: UITableView.RowAnimation.fade)
        }
    }

    func useThisPaymentSelected(_ inSender:IAPPaymentSelectionCell) {
        if let indexPath = self.paymentTableView.indexPath(for: inSender) {
            let paymentSelected = paymentDetails[indexPath.row]
            self.delegate?.didSelectUseThisPaymentMethod(paymentSelected)
        }
    }
}
