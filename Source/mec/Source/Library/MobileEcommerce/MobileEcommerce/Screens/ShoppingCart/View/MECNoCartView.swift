/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

class MECNoCartView: UIView {
    @IBOutlet weak var topbarView: UIDView!
    @IBOutlet weak var topbarLabel: UIDLabel!
    @IBOutlet weak var infoLabel: UIDLabel!
    @IBOutlet weak var titleLabel: UIDLabel!
    @IBOutlet weak var descriptionLabel: UIDLabel!
    @IBOutlet weak var middleImageLabel: UIDLabel!

    func configureUI() {
        topbarView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
        topbarLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText

        titleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.notificationDefaultHeaderInfo
        titleLabel.text = MECLocalizedString("mec_nothing_in_cart")

        infoLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.notificationDefaultIconInfo
        infoLabel.font = UIFont.iconFont(size: UIDSize24)
        infoLabel.text = PhilipsDLSIcon.unicode(iconType: .infoCircle)

        descriptionLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.notificationDefaultText
        descriptionLabel.text = MECLocalizedString("mec_empty_cart")

        middleImageLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentTertiaryBackground
        middleImageLabel.font = UIFont.mecIconFont(size: 100)
        middleImageLabel.text = MECIconFont.unicode(iconType: .cart)
        self.isHidden = true
    }
}
