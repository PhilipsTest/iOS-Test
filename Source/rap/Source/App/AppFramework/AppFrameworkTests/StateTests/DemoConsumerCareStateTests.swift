//
//  DemoConsumerCareState.swift
//  AppFramework
//
//  Created by Philips on 7/5/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework

class DemoConsumerCareState: XCTestCase {
    
    func testDemoConsumerCareViewController() {
       XCTAssertNotNil(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.DemoConsumerCareState)?.getViewController() )
    }
}
