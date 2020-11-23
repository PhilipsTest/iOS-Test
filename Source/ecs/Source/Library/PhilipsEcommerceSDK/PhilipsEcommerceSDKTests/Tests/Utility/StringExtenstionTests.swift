/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class StringExtenstionTests: XCTestCase {

    func testIsValidCTNValid() {
        var ctn = "HD9240/94"
        XCTAssertTrue(ctn.isValidCTN())
    }
    
    func testIsValidCTNInvalidSpaceInbetween() {
        var ctn = "HD92 40/94"
        XCTAssertFalse(ctn.isValidCTN())
    }
    
    func testIsValidCTNEmptyString() {
        var ctn = ""
        XCTAssertFalse(ctn.isValidCTN())
    }
    
    func testIsValidCTNSpaceLeft() {
        var ctn = " HD9240/94"
        XCTAssertTrue(ctn.isValidCTN())
        XCTAssertEqual(ctn, "HD9240/94")
    }
    
    func testIsValidCTNSpaceRight() {
        var ctn = "HD9240/94 "
        XCTAssertTrue(ctn.isValidCTN())
        XCTAssertEqual(ctn, "HD9240/94")
    }
}
