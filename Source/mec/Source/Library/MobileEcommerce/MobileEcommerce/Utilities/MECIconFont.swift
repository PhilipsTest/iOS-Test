/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

enum MECIconFontType: Int {
    case grid = 0xF001
    case cart = 0xF002
    case downArrow = 0xF003
    case currency = 0xF004
    case delete = 0xF005
    case filterSelected = 0xF006
    case filter = 0xF007
}

final class MECIconFont: NSObject {
   class func unicode(iconType: MECIconFontType) -> String {
        return String(format: "%C", unichar(iconType.rawValue))
    }
}
