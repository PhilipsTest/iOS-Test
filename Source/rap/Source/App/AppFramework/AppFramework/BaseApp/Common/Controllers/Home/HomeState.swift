/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import UAPPFramework

/** HomeState class is inherited from UIBaseState, Manages navigation to it corresponding ViewController, Manage state
 */
class HomeState : BaseState {
    
    //MARK: BaseState method implementation
    
    /// Initialiser
    override init() {
        super.init(stateId : AppStates.Home)
    }
    
	/** Method getViewController gets the Viewcontroller to be navigated to
	*/
    override func getViewController() -> UIViewController? {
        let homeVC : UIViewController?
        let storyBoard = UIStoryboard(name: Constants.HOME_STORYBOARD_NAME, bundle: nil)
        homeVC = storyBoard.instantiateViewController(withIdentifier: Constants.HOME_VIEWCONTROLLER_STORYBOARD_ID)
        return homeVC
    }
    
}
