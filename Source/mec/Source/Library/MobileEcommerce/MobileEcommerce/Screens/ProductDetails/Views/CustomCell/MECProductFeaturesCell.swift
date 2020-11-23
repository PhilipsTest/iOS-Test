/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECProductFeaturesCell: UITableViewCell {

    @IBOutlet weak var productFeaturesImageView: UIImageView!
    @IBOutlet weak var productFeaturesNameLabel: UIDLabel!
    @IBOutlet weak var productFeaturesDescriptionLabel: UIDLabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        productFeaturesImageView.image = nil
    }
}

extension MECProductFeaturesCell {

    func customizeCellAppearance() {
        backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimaryBackground
        productFeaturesNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        productFeaturesDescriptionLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
    }
}
