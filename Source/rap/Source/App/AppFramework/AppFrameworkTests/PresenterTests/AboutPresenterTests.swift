/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class AboutPresenterTests: XCTestCase {
    let aboutPresenter  = AboutPresenter(_viewController: AboutViewController())
    
    func testAboutPresenterCheckNil(){
        XCTAssertNotNil(aboutPresenter)
    }
    
    func testOnEventForTermsAndCondition(){
       _ = aboutPresenter.onEvent(Constants.TERMS_AND_CONDITION_TEXT)

        XCTAssertEqual(Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId,AppStates.TermsAndPrivacy)
    }
    
    func testOnEventForPrivacyPolicy(){
        _ = aboutPresenter.onEvent(Constants.PRIVACY_POLICY_TEXT ?? "")

        XCTAssertEqual(Constants.APPDELEGATE?.getFlowManager().getCurrentState()?.stateId, AppStates.TermsAndPrivacy)
    }
}
