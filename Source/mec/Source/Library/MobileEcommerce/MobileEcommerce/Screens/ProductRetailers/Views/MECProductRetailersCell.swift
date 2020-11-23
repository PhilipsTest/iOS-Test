/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

class MECProductRetailersCell: UITableViewCell {

    @IBOutlet weak var retailerLogoImageView: UIImageView!
    @IBOutlet weak var retailerTitleLabel: UIDLabel!
    @IBOutlet weak var retailerStockLabel: UIDLabel!
    @IBOutlet weak var retailerPriceLabel: UIDLabel!
    @IBOutlet weak var retailerRightArrow: UIDLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUIAppearance()
    }
}

extension MECProductRetailersCell {

    func configureUIAppearance() {
        retailerTitleLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        retailerPriceLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        retailerRightArrow.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryIcon
        self.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.listItemDefaultOffBackground
    }
}
