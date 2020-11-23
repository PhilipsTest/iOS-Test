/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
@testable import UAPPFrameworkDev

/** WelcomeState class is inherited from UIBaseState, Manages navigation to it corresponding ViewController, Manage state
 */
class WelcomeState: BaseState {
    
    //MARK: BaseState method implementation
    
    override init() {
        super.init(stateId : AppStates.Welcome)
    }
}
