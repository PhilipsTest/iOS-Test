/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class WelcomePresenterTests: XCTestCase {

    let welcomePresenter  = StateBasedNavigationPresenter(_viewController : WelcomeViewController(), forState: AppStates.Welcome)

//    func testonEventSkipButton() {
//        _ = welcomePresenter.onEvent(UnitTestConstants.WELCOME_SKIP_BUTTON_CLICK)
//        XCTAssertEqual(Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId, AppStates.CookieConsent)
//    }
//
//    func testonEventDoneButton() {
//        _ = welcomePresenter.onEvent(UnitTestConstants.WELCOME_DONE_BUTTON_CLICK)
//        XCTAssertEqual(Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId, AppStates.CookieConsent)
//    }

    func testUnknownEventPreservesAppState() {
        let oldState = Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId
        _ = welcomePresenter.onEvent(UnitTestConstants.BLANK_STRING)
        XCTAssertEqual(Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId, oldState)
    }
}
