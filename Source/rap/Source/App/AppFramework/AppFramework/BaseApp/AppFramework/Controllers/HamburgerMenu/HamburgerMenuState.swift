/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import UAPPFramework

class HamburgerMenuState : BaseState {
    
    //MARK: Variable Declarations
    
    //MARK: BaseState method implementations
    
    override init() {
        super.init(stateId : AppStates.HamburgerMenu)
    }
    
    override func getViewController() -> UIViewController? {
        let hamburgerMenuVC : UIViewController?
        let storyBoard = UIStoryboard(name: Constants.HAMBURGER_MENU_STORYBOARD_ID, bundle: nil)
        hamburgerMenuVC = storyBoard.instantiateViewController(withIdentifier: Constants.HAMBURGER_MENU_CONTROLLER_STORYBOARD_ID)
        return hamburgerMenuVC
    }
}
