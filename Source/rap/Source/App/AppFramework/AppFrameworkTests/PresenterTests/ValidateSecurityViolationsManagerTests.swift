/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class ValidateSecurityViolationsManagerTests: XCTestCase {
    let validateSecurityViolationsManager  = ValidateSecurityViolationsManager()

    func testCheckForSecurityViolationOfPasscodeAndJailbreak(){
        let status = validateSecurityViolationsManager.checkForSecurityViolation(jailbreakStatus: Constants.TRUE_TEXT, passcodeStatus: false)
        XCTAssertEqual(status, SecurityIdentifier.PASSCODE_AND_JAILBREAK_TEXT.rawValue)
    }

    func testCheckForSecurityViolationOfPasscode(){
        let status = validateSecurityViolationsManager.checkForSecurityViolation(jailbreakStatus: Constants.FALSE_TEXT, passcodeStatus: false)
        XCTAssertEqual(status, SecurityIdentifier.PASSCODE_TEXT.rawValue)
    }

    func testCheckForSecurityViolationOfJailbreak(){
        UserDefaults.standard.set(false, forKey: Constants.DONT_SHOW_MESSAGE_FOR_PASSCODE)
        let status = validateSecurityViolationsManager.checkForSecurityViolation(jailbreakStatus: Constants.TRUE_TEXT, passcodeStatus: true)
        XCTAssertEqual(status, SecurityIdentifier.JAILBREAK_TEXT.rawValue)
    }
    
    func testCheckPreConditionsForSecurityViolations(){
        let status = validateSecurityViolationsManager.checkPreConditionsForSecurityViolations()
        XCTAssertEqual(status, Constants.NO_VIOLATION_TEXT)
    }
}
