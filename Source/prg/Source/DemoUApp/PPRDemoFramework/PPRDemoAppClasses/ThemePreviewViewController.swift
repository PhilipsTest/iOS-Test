/** © Koninklijke Philips N.V., 2016. All rights reserved. */

import UIKit
import PhilipsUIKitDLS

// ****************************************************
// MARK: - ThemePreviewViewController
// ****************************************************
class ThemePreviewViewController: UIViewController {
    
    @IBAction func handleDoneButtonPressed(_ sender: UIBarButtonItem) {
        UIDThemeManager.sharedInstance.setNavigationBarShadowLevel(.two)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleSingleTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
