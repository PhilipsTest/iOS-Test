/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework

class SplashState: BaseState {
    
    override init() {
        super.init(stateId : AppStates.Splash)
    }
    
    override func getViewController() -> UIViewController? {
        let splashVC : UIViewController?
        let storyBoard = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil)
        splashVC = storyBoard.instantiateViewController(withIdentifier: Constants.SPLASH_VIEWCONTROLLER_STORYBOARD_ID)
        return splashVC
    }
    
}
