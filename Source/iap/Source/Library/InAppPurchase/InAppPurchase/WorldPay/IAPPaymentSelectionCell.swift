/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

protocol IAPPaymentSelectionProtocol: class {
    func radioButtonSelected(_ inSender:IAPPaymentSelectionCell);
    func useThisPaymentSelected(_ inSender:IAPPaymentSelectionCell);
}


class IAPPaymentSelectionCell: UITableViewCell, UIDRadioButtonDelegate {
    
    @IBOutlet weak var paymentInfoLabel: UIDLabel!
    @IBOutlet weak var radioButton: UIDRadioButton!
    @IBOutlet weak var useThisPaymentButton: UIDButton!
    
    @IBOutlet weak var useThisBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var useThisBtnBottomConstraint: NSLayoutConstraint!
    
    weak var paymentSelectionDelegate: IAPPaymentSelectionProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radioButton.delegate = self
    }
    
    func radioButtonPressed(_ radioButton: UIDRadioButton) {
        if radioButton.isSelected {
            paymentSelectionDelegate?.radioButtonSelected(self)
        }
    }
    
    @IBAction func useThisPaymentClicked(_ sender: AnyObject) {
        paymentSelectionDelegate?.useThisPaymentSelected(self)
    }
}
