/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import UAPPFramework

class UserRegEnvSettingsState: BaseState {
    
    //MARK: BaseState method implementations
    
    override init() {
        super.init(stateId : AppStates.UserRegistrationEnvironmentSettings)
    }
    
    /** Navigation to it corresponding ViewController is implemented in getViewController method 
     - returns ViewController to be navigated to
     */
    override func getViewController() -> UIViewController? {
        let regEnvVC : UIViewController?
        let storyBoard = UIStoryboard(name: Constants.USER_REGISTRATION_ENVIRONMENT_STORYBOARD_NAME, bundle: nil)
        regEnvVC = storyBoard.instantiateViewController(withIdentifier: Constants.USER_REGISTRATION_ENVIRONMENT_VIEWCONTROLLER_STORYBOARD_ID)
        return regEnvVC
    }
}
