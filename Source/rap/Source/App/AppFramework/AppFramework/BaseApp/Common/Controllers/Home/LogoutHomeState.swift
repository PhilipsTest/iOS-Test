/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework

class LogoutHomeState : BaseState {
    
    override init() {
        super.init(stateId : AppStates.LogoutHome)
    }
    
    override func getViewController() -> UIViewController? {
        return nil
    }
}
