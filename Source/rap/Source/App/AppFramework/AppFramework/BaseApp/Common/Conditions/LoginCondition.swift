/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework

class LoginCondition: BaseCondition {
    
    override init() {
        super.init(conditionId: AppConditions.IsLoggedIn)
    }
    
    override func isSatisfied() -> Bool {
        return ((Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistration) as? UserRegistrationState)?.isUserLoggedIn)!
    }
}
