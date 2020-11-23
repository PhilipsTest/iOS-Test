/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS

extension UIDButton {
    var localizedTitleForNormal: String {
        set (key) {
            setTitle(NSLocalizedString(key, comment: ""), for: .normal)
        }
        get {
            return title(for: .normal)!
        }
    }
    
    var localizedTitleForHighlighted: String {
        set (key) {
            setTitle(NSLocalizedString(key, comment: ""), for: .highlighted)
        }
        get {
            return title(for: .highlighted)!
        }
    }
}
