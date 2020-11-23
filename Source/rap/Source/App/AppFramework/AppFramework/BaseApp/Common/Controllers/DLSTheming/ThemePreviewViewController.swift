/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import UIKit
import PhilipsUIKitDLS

// ****************************************************
// MARK: - ThemePreviewViewController
// ****************************************************
class ThemePreviewViewController: UIViewController {
    
    @IBAction func handleDoneButtonPressed(_ sender: UIBarButtonItem) {
        UIDThemeManager.sharedInstance.setNavigationBarShadowLevel(.two)
        
        let presenter = StateBasedNavigationPresenter(_viewController: self, forState: AppStates.Welcome)
        presenter.onEvent("themeChanged")        
        let theme = UIDThemeManager.sharedInstance.defaultTheme
        let userDefaults = UserDefaults.standard
        let colorRangeNew = theme?.colorRange.rawValue
        let tonalRangeNew = theme?.tonalRange.rawValue
        let navTonalRangeNew = theme?.navigationTonalRange.rawValue
        userDefaults.set(colorRangeNew, forKey: Constants.THEME_COLOR_RANGE)
        userDefaults.set(tonalRangeNew, forKey: Constants.THEME_TONAL_RANGE)
        userDefaults.set(navTonalRangeNew, forKey: Constants.THEME_NAVTONAL_RANGE)
        userDefaults.synchronize()        
    }
    
    @IBAction func handleSingleTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
