/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

protocol MECAppliedVoucherDelegate: NSObjectProtocol {
    func didClickOnDeleteVoucher(cell: MECAppliedVoucherCell)
}

class MECAppliedVoucherCell: UITableViewCell {

    @IBOutlet weak var giftCodeLabel: UIDLabel!
    @IBOutlet weak var deleteVoucherButton: UIDButton!
    @IBOutlet weak var percentageDiscountLabel: UIDLabel!
    @IBOutlet weak var discountValueLabel: UIDLabel!
    @IBOutlet weak var containerView: UIDView!
    weak var delegate: MECAppliedVoucherDelegate?

    func configureUI() {
        deleteVoucherButton.titleLabel?.font = UIFont.iconFont(size: 14)
        deleteVoucherButton.setTitle(PhilipsDLSIcon.unicode(iconType: .cross), for: .normal)
        deleteVoucherButton.setTitleColor(UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText, for: .normal)
    }

    @IBAction func deleteVoucherClicked(_ sender: Any) {
        delegate?.didClickOnDeleteVoucher(cell: self)
    }
}
