/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

protocol MECApplyVoucherDelegate: NSObjectProtocol {
    func didClickOnApplyVoucher(voucherCell: MECApplyVoucherCell, voucherId: String)
}

class MECApplyVoucherCell: UITableViewCell {

    @IBOutlet weak var voucherTextField: UIDTextField!
    @IBOutlet weak var addButton: UIDButton!
    weak var applyVoucherDelegate: MECApplyVoucherDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        voucherTextField.placeholder = MECLocalizedString("mec_enter_code")
        addButton.setTitle(MECLocalizedString("mec_apply"), for: .normal)
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        if let text = voucherTextField.text, text.count > 0 {
            voucherTextField.resignFirstResponder()
            applyVoucherDelegate?.didClickOnApplyVoucher(voucherCell: self, voucherId: text)
        }
    }

    func showVoucherError(errorMessage: String?) {
        guard let message = errorMessage else {
            voucherTextField.setValidationView(false)
            voucherTextField.validationMessage = ""
            return
        }
        voucherTextField.setValidationView(true)
        voucherTextField.validationMessage = message
    }
}
