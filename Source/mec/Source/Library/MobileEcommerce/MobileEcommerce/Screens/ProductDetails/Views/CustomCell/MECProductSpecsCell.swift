/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECProductSpecsCell: UITableViewCell {
    @IBOutlet weak var specItemNameLabel: UIDLabel!
    @IBOutlet weak var specItemValueLabel: UIDLabel!
    @IBOutlet weak var specMainView: UIDView!
}

extension MECProductSpecsCell {

    func customizeCellAppearance() {
        specMainView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentPrimaryBackground
        specItemNameLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemSecondaryText
        specItemValueLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
    }
}
