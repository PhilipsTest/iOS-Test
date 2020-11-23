/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS

extension UIButton {

    @IBInspectable var localizedTitle: String {
        set (key) {
            setTitle(Utilites.aFLocalizedString(key), for: .normal)
        }
        get {
            return title(for: .normal)!
        }
    }
}
