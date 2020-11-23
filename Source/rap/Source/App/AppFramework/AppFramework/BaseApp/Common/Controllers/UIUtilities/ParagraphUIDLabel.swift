/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import PhilipsUIKitDLS

@IBDesignable
class ParagraphUIDLabel: UIDLabel {
    
    @IBInspectable var paragraphLocalizedText: String? {
        didSet {
            if let localizedText = paragraphLocalizedText {
                labelType = .value
                text(Utilites.aFLocalizedString(localizedText)!, lineSpacing: UIDLineSpacing)
            }
        }
    }
}
