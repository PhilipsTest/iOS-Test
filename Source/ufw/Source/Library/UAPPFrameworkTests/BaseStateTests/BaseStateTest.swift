/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import UAPPFrameworkDev

class MockBaseState : BaseState {
    
    override func getViewController() -> UIViewController? {
        return nil
    }
}

class BaseStateTest: XCTestCase {
    
    var state : BaseState?
    
    override func setUp() {
        super.setUp()
        state = MockBaseState()
    }

    func testGetViewController() {
        XCTAssertNil(state?.getViewController())
    }
    
    func testSetCompletionHandler() {
        let hamburgerState = HamburgerMenuState()
        state?.setStateCompletionDelegate(hamburgerState)
        XCTAssertNotNil(state?.stateCompletionHandler)
    }
}
