/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework
@testable import PhilipsUIKitDLS

class HamburgerMenuPresenterTests: XCTestCase {
    var menuMockObj : HamburgerMenuMockViewController?
    let hamburgerPresenter = HamburgerMenuPresenter(_viewController : HamburgerMenuViewController())

    override func setUp() {
        super.setUp()
        menuMockObj = HamburgerMenuMockViewController()
        menuMockObj?.intialiazeMock()
    }
    
   func testHamburgeronEventNil() {
        XCTAssertNil(hamburgerPresenter.onEvent(UnitTestConstants.BLANK_STRING))
    }
    
    func testHamburgeronEventDummyValue() {
        XCTAssertNil(hamburgerPresenter.onEvent(UnitTestConstants.BLANK_STRING))
    }
    
    func testonEventHome() {
        _ = hamburgerPresenter.onEvent(UnitTestConstants.HAMBURGER_HOME_CLICK)

        XCTAssertEqual(Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId, AppStates.Home)
    }    
    
    func testonEventUserRegistrationEnvironment() {
        // UserRegistrationEnvironment is not added in Json. So this click should not trigger any state change.
        let oldState = Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId
        _ = hamburgerPresenter.onEvent(UnitTestConstants.HAMBURGER_USER_REGISTRATION_ENVIRONMENT_CLICK)

        XCTAssertEqual(Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId, oldState)
    }
    
    func testonEventSettingsFailure() {
       _ = hamburgerPresenter.onEvent(UnitTestConstants.HAMBURGER_SETTINGS_CLICK)

        XCTAssertNotEqual(Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId, AppStates.About)
    }
}
