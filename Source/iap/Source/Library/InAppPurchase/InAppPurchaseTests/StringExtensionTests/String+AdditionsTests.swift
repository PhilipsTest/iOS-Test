/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class StringAdditionsTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        IAPConfiguration.sharedInstance.locale = "en_US"
    }
    
    func testLength() {
        let stringToBeTested    = "IAPPurchase"
        let copyString:NSString = "IAPPurchase"
        XCTAssert(stringToBeTested.length == copyString.length,"Value returned is not right")
    }
    
    func testRange() {
        let stringToBeTested    = "IAPPurchase"
        var stringToBeChecked   = "IAP"
        //XCTAssert(stringToBeTested.contains(stringToBeChecked) == true,"Value returned is not right")
        
        stringToBeChecked       = "zzz"
        //XCTAssert(stringToBeTested.contains(stringToBeChecked) == false,"Value returned is not right")
    }
    
    func testReplaceCharacter() {
        let stringToBeTested    = "IAPPurchase"
        XCTAssert(stringToBeTested.replaceCharacter("P", withCharacter: "X") == "IAXXurchase", "strings don't match")
    }
    
    func testReplaceCharacters(){
        let stringToBeTested = "123-456-789"
        XCTAssert(stringToBeTested.replaceCharacters("-", withCharacter: "") == "123456789", "Strings dont match")
    }

    func testLangAppend() {
        var stringToBeTested1: String = "http://www.occ.philips.com?firstParameter"
        var stringToBeTested2: String = "http://www.occ.philips.com"
        
        let string1AfterCalculation = stringToBeTested1.appendedLanguageURL()
        let string2AfterCalculation = stringToBeTested2.appendedLanguageURL()
        
        //XCTAssert(stringToBeTested2.contains("?lang="),"Computed string is not right")
        //XCTAssert(stringToBeTested1.contains("&lang="),"Computed string is not right")
        
        let height1 = string1AfterCalculation.heightWithConstrainedWidth(10, font: UIFont.boldSystemFont(ofSize: 14))
        XCTAssert(height1 > 0, "Height returned is not right")
        
        let height2 = string1AfterCalculation.heightWithConstrainedWidth(5, font: UIFont.boldSystemFont(ofSize: 14))
        XCTAssert(height1 < height2, "Heights are not properly returned")
    }
}
