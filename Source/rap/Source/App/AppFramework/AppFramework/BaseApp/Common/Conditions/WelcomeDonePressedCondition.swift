/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import Foundation
import UAPPFramework

class WelcomeDonePressedCondition: BaseCondition {
    
    override init() {
        super.init(conditionId: AppConditions.IsDonePressed)
    }
    
    override func isSatisfied() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.WELCOME_SCREEN_SHOWN_FLAG_STATE)
    }
}
