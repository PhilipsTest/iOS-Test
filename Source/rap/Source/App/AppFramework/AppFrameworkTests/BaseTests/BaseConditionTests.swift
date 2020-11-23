//
//  BaseConditionTests.swift
//  AppFramework
//
//  Created by Philips on 1/17/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest

@testable import AppFramework
@testable import UAPPFramework

class BaseConditionTests: XCTestCase {
    
    var baseConditionObj: BaseCondition?
    
    override func setUp() {
        super.setUp()
        baseConditionObj = BaseCondition.init()
    }
    
    func testConditionEqualityCheck(){
        
        let onBoardingConditionFirstObj = OnboardingCompleteCondition()
        let onBoardingConditionSecoundObj = OnboardingCompleteCondition()
        
        XCTAssertNotEqual(onBoardingConditionFirstObj,onBoardingConditionSecoundObj)
    }
}
