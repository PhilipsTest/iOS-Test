/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class HamburgerMenuViewControllerTests: XCTestCase {
    
    var hamburgerViewController:HamburgerMenuViewController!
    var popoverContent:PopAlertViewController!

    override func setUp() {
        super.setUp()
        let popStoryboard : UIStoryboard = UIStoryboard(name: Constants.HAMBURGER_MENU_STORYBOARD_ID, bundle: nil)
        popoverContent = popStoryboard.instantiateViewController(withIdentifier: Constants.POPUP_VIEWCONTROLLER_STORYBOARD_ID) as! PopAlertViewController
        popoverContent.loadView()
        hamburgerViewController = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.HamburgerMenu)?.getViewController() as! HamburgerMenuViewController
    }
    
    func testSecurityViolationForPassCode(){
        hamburgerViewController.presentPopUpBasedOnViolations(statusOfViolation: SecurityIdentifier.PASSCODE_TEXT.rawValue)
         XCTAssertEqual(popoverContent.alertMessageText?.text, UnitTestConstants.BLANK_STRING)
    }
    
    func testSecurityViolationForJailbreak(){
        hamburgerViewController.presentPopUpBasedOnViolations(statusOfViolation: SecurityIdentifier.JAILBREAK_TEXT.rawValue)
        XCTAssertEqual(popoverContent.alertMessageText?.text, UnitTestConstants.BLANK_STRING)
    }
    
    func testSecurityViolationForPassCodeAndJailbreak(){
        hamburgerViewController.presentPopUpBasedOnViolations(statusOfViolation: SecurityIdentifier.PASSCODE_AND_JAILBREAK_TEXT.rawValue)
        XCTAssertEqual(popoverContent.alertMessageText?.text, UnitTestConstants.BLANK_STRING)
    }
}
