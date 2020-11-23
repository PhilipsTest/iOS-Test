//
//  ConsumerCareStateTest.swift
//  AppFramework
//
//  Created by Philips on 1/16/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest

@testable import AppFramework
@testable import PhilipsRegistration
@testable import PhilipsConsumerCare

class ConsumerCareStateTest: XCTestCase {

     func testViewControllerNil(){
        var nextState : BaseState?
        do {
            try nextState = Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.HamburgerMenu), forEventId:UnitTestConstants.HELP_STORYBOARD_NAME)
        } catch {
            
        }
        XCTAssertNotNil(nextState)
        XCTAssertNotNil(nextState?.getViewController())
    }
}
