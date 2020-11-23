/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

class MECOrderHistoryProductDetailView: UIView {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UIDLabel!
    @IBOutlet weak var productQuantityLabel: UIDLabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension MECOrderHistoryProductDetailView {

    func customizeUI() {
        backgroundColor = .clear
        productTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        productQuantityLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
    }
}
