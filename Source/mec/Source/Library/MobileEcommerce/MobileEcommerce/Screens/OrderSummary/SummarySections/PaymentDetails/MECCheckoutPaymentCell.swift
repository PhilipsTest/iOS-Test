/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import PhilipsUIKitDLS

class MECCheckoutPaymentCell: UITableViewCell {

    @IBOutlet weak var cardNumberLabel: UIDLabel!
    @IBOutlet weak var cardExpiryLabel: UIDLabel!
    @IBOutlet weak var cardHolderNameLabel: UIDLabel!
    @IBOutlet weak var cardAddressLabel: UIDLabel!

    func configureUI() {
        cardNumberLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        cardExpiryLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
        cardHolderNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        cardAddressLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
    }
}
