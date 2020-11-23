//
//  DemoProductRegistrationStateTests.swift
//  AppFramework
//
//  Created by Philips on 7/5/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework

class DemoProductRegistrationStateTests: XCTestCase {
    
    func testNavigateCheckNil() {
        XCTAssertNotNil(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.DemoProductRegistrationState)?.getViewController())
    }
}
