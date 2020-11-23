/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECAddressDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addressDetailMainView: UIDView!
    @IBOutlet weak var addressFullNameLabel: UIDLabel!
    @IBOutlet weak var addressDetailsLabel: UIDLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        unselectCell()
    }
}

extension MECAddressDetailsCollectionViewCell {

    func configureUI() {
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
    }

    func configureDropShadow() {
        if let theme = UIDThemeManager.sharedInstance.defaultTheme {
            let dropShadow = UIDDropShadow(level: .level3, theme: theme)
            apply(dropShadow: dropShadow)
            layer.masksToBounds = false
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        }
    }

    func selectCell() {
        addressDetailMainView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedBackground
        contentView.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedBorder?.cgColor
        addressFullNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedText
        addressDetailsLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.textBoxDefaultValidatedText
        configureDropShadow()
    }

    func unselectCell() {
        addressDetailMainView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimary
        contentView.layer.borderColor = UIDThemeManager.sharedInstance.defaultTheme?.separatorContentBackground?.cgColor
        addressFullNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        addressDetailsLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        configureDropShadow()
    }
}
