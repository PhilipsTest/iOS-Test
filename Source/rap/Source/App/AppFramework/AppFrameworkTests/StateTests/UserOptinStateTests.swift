//
//  UserOptinStateTests.swift
//  AppFrameworkTests
//
//  Created by philips on 7/18/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework

class UserOptinStateTests: XCTestCase {
    
    var userOptinState : UserOptinState?
    var returnedViewController: UIViewController?
    
    override func setUp() {
        super.setUp()
        returnedViewController = nil
    }
    
    func testUserOptinState() {
        userOptinState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserOptin) as? UserOptinState
        returnedViewController = userOptinState?.getViewController()
        XCTAssertNotNil(returnedViewController)
    }
    
    func testUserOptinControllerNil() {
        userOptinState?.userRegistrationState = nil
        returnedViewController = userOptinState?.getViewController()
        XCTAssertNil(returnedViewController)
    }
    
}
