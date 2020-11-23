/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import Foundation
@testable import UAPPFrameworkDev

class WelcomeDonePressedCondition: BaseCondition {
    
    override init() {
        super.init(conditionId: AppConditions.IsDonePressed)
    }
    
    override func isSatisfied() -> Bool {
        return true
    }
}
