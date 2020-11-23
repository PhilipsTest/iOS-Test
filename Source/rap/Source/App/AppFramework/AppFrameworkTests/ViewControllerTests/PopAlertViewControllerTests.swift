/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework
@testable import PhilipsUIKitDLS

class PopAlertViewControllerTests: XCTestCase {
    var popoverContent = PopAlertViewController()

    override func setUp() {
        super.setUp()
       
        let popStoryboard : UIStoryboard = UIStoryboard(name: Constants.HAMBURGER_MENU_STORYBOARD_ID, bundle: nil)
        popoverContent = popStoryboard.instantiateViewController(withIdentifier: Constants.POPUP_VIEWCONTROLLER_STORYBOARD_ID) as! PopAlertViewController
        popoverContent.loadView()
    }
    
    func testCheckForNil(){
        XCTAssertNotNil(popoverContent)
    }
    
    func testShowAlertStatuSwitchChangedPasscode(){
        let mockSwitch = UIDSwitch()
        mockSwitch.isOn = false
        popoverContent.isPasscodeAndJailbreakViolation = SecurityIdentifier.PASSCODE_TEXT.rawValue
        popoverContent.showAlertStatuSwitchChanged(mockSwitch)

        XCTAssertFalse(UserDefaults.standard.value(forKey: Constants.DONT_SHOW_MESSAGE_FOR_PASSCODE) as! Bool)
    }
    
    func testShowAlertStatuSwitchChangedJailbreak(){
        let mockSwitch = UIDSwitch()
        mockSwitch.isOn = false
        popoverContent.isPasscodeAndJailbreakViolation = SecurityIdentifier.JAILBREAK_TEXT.rawValue
        popoverContent.showAlertStatuSwitchChanged(mockSwitch)
        XCTAssertFalse(UserDefaults.standard.value(forKey: Constants.DONT_SHOW_MESSAGE_FOR_JAILBREAK) as! Bool)
    }
    
    func testShowAlertStatuSwitchChangedPasscodeAndJailbreak(){
        let mockSwitch = UIDSwitch()
        mockSwitch.isOn = false
        popoverContent.isPasscodeAndJailbreakViolation = SecurityIdentifier.PASSCODE_AND_JAILBREAK_TEXT.rawValue
        popoverContent.showAlertStatuSwitchChanged(mockSwitch)
        XCTAssertFalse(UserDefaults.standard.value(forKey: Constants.DONT_SHOW_MESSAGE_FOR_PASSCODE_AND_JAILBREAK) as! Bool)
    }
}
