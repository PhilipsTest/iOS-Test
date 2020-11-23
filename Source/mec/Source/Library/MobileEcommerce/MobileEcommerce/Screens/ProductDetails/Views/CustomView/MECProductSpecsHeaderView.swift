/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS

class MECProductSpecsHeaderView: UIView {

    @IBOutlet weak var productSpecHeaderView: UIDView!
    @IBOutlet weak var productSpecHeaderLabel: UIDLabel!
}

extension MECProductSpecsHeaderView {

    func configureUIAppearance() {
        backgroundColor = .clear
        productSpecHeaderView.backgroundColor = UIDThemeManager.sharedInstance.defaultTheme?.contentSecondaryNeutralBackground
        productSpecHeaderLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.contentItemPrimaryText
    }
}
