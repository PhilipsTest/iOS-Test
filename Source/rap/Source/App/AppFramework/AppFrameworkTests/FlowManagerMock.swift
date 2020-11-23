//
//  FlowManagerMock.swift
//  AppFramework
//
//  Created by Philips on 1/16/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import Foundation

@testable import AppFramework
@testable import UAPPFramework

class FlowManagerMock : BaseFlowManager{
    
    fileprivate static let sharedInstance = FlowManagerMock()
    
    fileprivate override init() {
        super.init()
    }
    
    static func getInstance() -> BaseFlowManager {
        return sharedInstance
    }

    
    override func populateStateMap( _ stateMap: inout StateMapType) {
        stateMap[AppStateMock.InAppPurchaseCartState] = InAppPurchaseCartState()
         stateMap[AppStateMock.InAppPurchaseOrderHistoryState] = InAppPurchaseOrderHistoryState()
    }
    
    override func populateConditionMap( _ conditionMap: inout ConditionMapType) {
        conditionMap[AppConditions.IsDonePressed] = WelcomeDonePressedCondition()
        conditionMap[AppConditions.IsLoggedIn] = LoginCondition()
        conditionMap[AppConditions.IsOnboardingComplete] = OnboardingCompleteCondition()
    }
    
    }
    
    
    
