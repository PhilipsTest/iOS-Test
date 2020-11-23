//
//  StringExtensionTests.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import XCTest
@testable import PhilipsProductRegistrationDev

class StringExtensionTests: XCTestCase {

     func testParseJSONWithInvalidJSONString() {
        let str = "{\"1\":{\"keyOne\":\"valueOne\",\"keyTwo\",\"valueTwo\"},\"success\":1}"
        let dict = str.parseJSONString
        XCTAssertNil(dict)
    }
//*********
//    func testParseJSONWithvalidJSONString() {
//        let str = "{\"1\":{\"keyOne\":\"valueOne\",\"keyTwo\":\"valueTwo\"},\"success\":1}"
//        let dict:Dictionary = str.parseJSONString
//        XCTAssertNotNil(dict)
//        XCTAssertTrue(dict?["success"] == true)
//        XCTAssertNotNil(dict?["1"])
//        XCTAssertEqual(dict["1"]!!["keyOne"], "valueOne")
//        XCTAssertEqual(dict!["1"]!!["keyTwo"], "valueTwo")
//    }
//    
    func testRegxForEMail() {
        let regx = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        var email = "ravi.com"
        XCTAssertEqual(email.isMatchWith(pattern: regx), false)
        email = "ravi@com"
        XCTAssertEqual(email.isMatchWith(pattern: regx), false)
        email = "sample@ga.com"
        XCTAssertEqual(email.isMatchWith(pattern: regx), true)
        email = "sample@gamil.some"
        XCTAssertEqual(email.isMatchWith(pattern: regx), true)
    }
    
    func testRegxForTelePhone() {
        let regx = "^\\(\\d{3}\\)[-]\\d{2}[-]\\d{4}$"
        var phone = "(080)--180-2333355"
        XCTAssertEqual(phone.isMatchWith(pattern: regx), false)
        phone = "(080)-180-2333355"
        XCTAssertEqual(phone.isMatchWith(pattern: regx), false)
        phone = "(080)-18-2333"
        XCTAssertEqual(phone.isMatchWith(pattern: regx), true)
        phone = "(080-18-2333"
        XCTAssertEqual(phone.isMatchWith(pattern: regx), false)
        phone = "080-18-2333"
        XCTAssertEqual(phone.isMatchWith(pattern: regx), false)
    }
    
    func testInvalidRegx() {
        let regx = "$%&*#)$!@#$(!~?"
        let phone = "(080)--180-2333355"
        XCTAssertEqual(phone.isMatchWith(pattern: regx), false)
    }
    
    func testStringLengthForNilString(){
        let string = String()
        XCTAssertEqual(string.length, 0)
    }
    
    func testStringLengthForEmptyString(){
        let string: String = ""
        XCTAssertEqual(string.length, 0)
    }
    
    func testStringLengthForTest(){
        let string: String = "Test"
        XCTAssertEqual(string.length, 4)
        let registration: String = "registration"
        XCTAssertEqual(registration.length, 12)
    }
    
    func testTrimmWhiteSpace() {
        let string: String = "   "
        XCTAssertEqual(string.trimmWhiteSpaces, "")
        XCTAssertEqual(string.length, 3)
        XCTAssertEqual(string.trimmWhiteSpaces.length, 0)
    }
    
    func testTrimmStringWhiteSpace() {
        let string: String = "ProductRegistration   "
        XCTAssertEqual(string.trimmWhiteSpaces, "ProductRegistration")
        XCTAssertEqual(string.length, 22)
        XCTAssertEqual(string.trimmWhiteSpaces.length, 19)
    }
    
    func testTrimmStringWithSpaceAndWhiteSpace() {
        let string: String = "Product Registration   "
        XCTAssertEqual(string.trimmWhiteSpaces, "Product Registration")
        XCTAssertEqual(string.length, 23)
        XCTAssertEqual(string.trimmWhiteSpaces.length, 20)
    }
}
