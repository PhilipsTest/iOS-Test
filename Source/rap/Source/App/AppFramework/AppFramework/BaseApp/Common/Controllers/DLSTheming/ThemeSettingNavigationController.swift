/** © Koninklijke Philips N.V., 2017. All rights reserved. */

import UIKit
import PhilipsUIKitDLS

class ThemeSettingNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let currentTheme = UIDThemeManager.sharedInstance.defaultTheme {
            let statusBarStyle: () -> UIStatusBarStyle = {
                switch currentTheme.navigationTonalRange {
                case .ultraLight, .veryLight:
                    return .default
                default:
                    return .lightContent
                }
            }
            return statusBarStyle()
        }
        return .lightContent
    }
}
