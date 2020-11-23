/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
@testable import UAPPFrameworkDev

/** HomeState class is inherited from UIBaseState, Manages navigation to it corresponding ViewController, Manage state
 */
class HomeState : BaseState {
    
    //MARK: BaseState method implementation
    
    /// Initialiser
    override init() {
        super.init(stateId : AppStates.Home)
    }
    
}
