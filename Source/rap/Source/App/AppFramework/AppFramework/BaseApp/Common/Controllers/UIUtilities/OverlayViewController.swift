/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS

protocol OverlayDelegate {
    func dismissOverlay() -> Void
}

class OverlayViewController: UIViewController {

    var delegate: OverlayDelegate?

    var descriptionLabel: ParagraphUIDLabel! {
        return descriptionBaseLabel as? ParagraphUIDLabel
    }
    
    @IBOutlet weak var descriptionBaseLabel: UIDLabel!
    @IBOutlet weak var dismissButton: UIDButton!

    @IBAction func dismissOverlay() {
        delegate?.dismissOverlay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.theme = createGrayTheme(.bright)
        dismissButton.theme = createGrayTheme(.veryLight)
    }

    func createGrayTheme(_ tonalRange: UIDTonalRange) -> UIDTheme {
        return UIDTheme(themeConfiguration: UIDThemeConfiguration(colorRange: UIDColorRange.gray, tonalRange: tonalRange))
    }
}
