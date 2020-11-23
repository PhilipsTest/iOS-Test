/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
@testable import UAPPFrameworkDev

class FlowManager : BaseFlowManager {
    
    /**
     Returns singleton instance of this class
     */
    static let sharedInstance = FlowManager()
    
    private override init() {
        super.init()
    }
    
    override func populateStateMap(_ stateMap: inout StateMapType) {
        stateMap[AppStates.Welcome] = WelcomeState()
        stateMap[AppStates.HamburgerMenu] = HamburgerMenuState()
        stateMap[AppStates.Home] = HomeState()
        stateMap[AppStates.Settings] = SettingsState()
        stateMap[AppStates.About] = AboutState()
    }
    
    override func populateConditionMap(_ conditionMap: inout ConditionMapType) {
        conditionMap[AppConditions.IsDonePressed] = WelcomeDonePressedCondition()
        conditionMap[AppConditions.IsLoggedIn] = LoginCondition()
    }
}
