/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPNoInternetViewTests: XCTestCase {
    
    weak var delegate:IAPNoInternetProtocol?
    var internetView:IAPNoInternetView!
    var internetViewDelegate: IAPInternetViewTest!
    
    override func setUp() {
        super.setUp()
        internetViewDelegate = IAPInternetViewTest()
        internetView = IAPNoInternetView.instanceFromNib()
    }
    
    func testInitializeText() {
        var checkString = IAPLocalizedString("iap_check_internet_connection")
        internetView?.initialiseText()
        XCTAssertTrue(checkString == internetView?.noInternetLabel.text, "Label text string is incorrect")
        
        checkString = "Check String"
        internetView?.initialiseText()
        XCTAssertFalse(checkString == internetView?.noInternetLabel.text, "Label text string is incorrect")
    }
    
    func testTryAgainButtonPressed() {
        let sender = UIView(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        internetView?.delegate = internetViewDelegate
        internetView?.tryAgainButtonTapped(sender)
        XCTAssertTrue(internetViewDelegate.tapTryAgainMethodInvoked == true, "Try Again Button is not tapped")
    }
}

class IAPInternetViewTest: IAPNoInternetProtocol {
    var tapTryAgainMethodInvoked = false
    
    func didTapTryAgain() {
        tapTryAgainMethodInvoked = true
    }
}
