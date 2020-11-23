/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import PhilipsIconFontDLS

class MECZeroSearchResultView: UIView {
    @IBOutlet var infoLabel: UIDLabel!
    @IBOutlet var zeroResultTitle: UIDLabel!
    @IBOutlet var zeroResultDescription: UIDLabel!

    func showNoSearchResult(searchTerm: String) {
        infoLabel.textColor = UIDThemeManager.sharedInstance.defaultTheme?.buttonPrimaryFocusBackground
        infoLabel.font = UIFont.iconFont(size: 22.0)
        infoLabel.text = PhilipsDLSIcon.unicode(iconType: .infoCircle)
        zeroResultTitle.text = MECLocalizedString("mec_no_result") + " " + searchTerm
        zeroResultDescription.text = MECLocalizedString("mec_zero_results_message")
    }
}
