/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import PhilipsUIKitDLS

class MECCheckoutDeliveryModeCell: UITableViewCell {

    @IBOutlet weak var deliveryModeName: UIDLabel!
    @IBOutlet weak var deliveryModeDescriptionLabel: UIDLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI() {
        deliveryModeName.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
        deliveryModeDescriptionLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemTertiaryText
    }
}
