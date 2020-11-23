/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

protocol MECAddressDisplayActionProtocol: NSObjectProtocol {
    func didClickEditShippingAddressButton()
}

class MECAddressDisplayCell: UITableViewCell {

    @IBOutlet weak var addressNameLabel: UIDLabel!
    @IBOutlet weak var fullAddressLabel: UIDLabel!
    @IBOutlet weak var editButton: UIDButton!
    weak var addressDisplayActionDelegate: MECAddressDisplayActionProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        addressDisplayActionDelegate = nil
    }

    @IBAction func editButtonClicked(_ sender: Any) {
        addressDisplayActionDelegate?.didClickEditShippingAddressButton()
    }
}

extension MECAddressDisplayCell {

    func customizeUI() {
        addressNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        fullAddressLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        editButton.titleLabel?.font = UIFont.iconFont(size: UIDSize16)
        editButton.setTitle(PhilipsDLSIcon.unicode(iconType: .edit), for: .normal)
        editButton.setTitleColor(UIDThemeManager.sharedInstance.defaultTheme?.buttonQuietEmphasisText, for: .normal)
        editButton.contentEdgeInsets = .zero
    }
}
