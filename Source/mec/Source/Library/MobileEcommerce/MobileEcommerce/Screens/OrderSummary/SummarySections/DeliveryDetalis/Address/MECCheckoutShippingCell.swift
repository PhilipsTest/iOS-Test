/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import PhilipsUIKitDLS

class MECCheckoutShippingCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UIDLabel!
    @IBOutlet weak var shippingAddressLabel: UIDLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI() {
        userNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        shippingAddressLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
    }
}
