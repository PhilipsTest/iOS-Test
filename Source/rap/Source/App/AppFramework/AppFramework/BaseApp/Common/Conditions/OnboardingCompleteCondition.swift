/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework

class OnboardingCompleteCondition : BaseCondition {
    
    override init() {
        super.init(conditionId: AppConditions.IsOnboardingComplete)
    }
    
    override func isSatisfied() -> Bool {
        var isSatisfied = false
        
        if !((Constants.APPDELEGATE?.getFlowManager().getCondition(AppConditions.IsLoggedIn)?.isSatisfied())!) && (Constants.APPDELEGATE?.getFlowManager().getCondition(AppConditions.IsDonePressed)?.isSatisfied())! {
            isSatisfied = true
        }
        return isSatisfied
    }
}
