/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECAddAddressCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addAddressLabel: UIDLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeUI()
    }
}

extension MECAddAddressCollectionViewCell {

    func customizeUI() {
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.separatorContentBackground?.cgColor

        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
            let dropShadow = UIDDropShadow(level: .level3, theme: theme)
            apply(dropShadow: dropShadow)
            layer.masksToBounds = false
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        }

        addAddressLabel.text = "\u{FF0B}"
        addAddressLabel.font = UIFont(uidFont: .bold, size: UIDSize56)
    }
}
