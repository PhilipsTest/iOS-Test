/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECProductCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var ratingBar: UIDRatingBar!
    @IBOutlet weak var reviewCount: UIDLabel!
    @IBOutlet weak var productTitle: UIDLabel!
    @IBOutlet weak var productCTN: UIDLabel!
    @IBOutlet weak var productDeliveryTime: UIDLabel!
    @IBOutlet weak var productDiscountedPrice: UIDLabel!
    @IBOutlet weak var productActualPrice: UIDLabel!
    @IBOutlet weak var suggestedRetailPriceLabel: UIDLabel!

    func configureUI() {
        self.reviewCount.textColor = UIDThemeManager.sharedInstance.defaultTheme?.ratingBarDefaultOnText
        productCTN.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        productTitle.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        suggestedRetailPriceLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        resetView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }

    func resetView() {
        productImageView.image = nil
        reviewCount.text = ""
        productTitle.text = ""
        productCTN.text = ""
        productDiscountedPrice.text = ""
        productActualPrice.text = ""
    }
}
