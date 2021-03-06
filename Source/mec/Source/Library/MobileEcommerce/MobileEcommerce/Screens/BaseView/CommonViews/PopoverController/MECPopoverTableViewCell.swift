/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECPopoverTableViewCell: UITableViewCell {

    @IBOutlet weak var titleText: UIDLabel!
}

extension MECPopoverTableViewCell {

    func setupUI() {
        titleText.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
    }
}
