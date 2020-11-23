/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import UAPPFramework

/** WelcomeState class is inherited from UIBaseState, Manages navigation to it corresponding ViewController, Manage state
 */
class WelcomeState: BaseState {
    var welcomeController:UIViewController?
    //MARK: BaseState method implementation
    
    override init() {
        super.init(stateId : AppStates.Welcome)
    }
    
    /** Navigation to it corresponding ViewController is implemented in getViewController method 
     - returns ViewController to be navigated to
     */
    override func getViewController() -> UIViewController? {
        if (welcomeController == nil){
        let storyBoard = UIStoryboard(name: Constants.WELCOME_STORYBOARD_NAME, bundle: nil)
        welcomeController = storyBoard.instantiateViewController(withIdentifier: Constants.WELCOME_PAGE_VIEW_CONTROLLER_STORYBOARD_ID)
            
        return welcomeController
        }else{
            return welcomeController
        }
    }
}
