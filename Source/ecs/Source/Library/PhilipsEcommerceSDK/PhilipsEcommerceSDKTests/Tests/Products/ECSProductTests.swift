/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSProductTests: XCTestCase {

    override func setUp() {
        super.setUp()
        ECSConfiguration.shared.baseURL = "https://test.com"
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchFormattedProductWithValidCTN() {
        let testMicro = ECSProductMicroServices()
        XCTAssertEqual(testMicro.fetchFormattedProduct(ctn: "HX3451/02"), "HX3451_02")
    }
    
    func testFetchFormattedProductWithInValidCTN() {
        let testMicro = ECSProductMicroServices()
        XCTAssertEqual(testMicro.fetchFormattedProduct(ctn: "HX3451"), "HX3451")
    }
    
    func testFetchFormattedProductWithBlankCTN() {
        let testMicro = ECSProductMicroServices()
        XCTAssertEqual(testMicro.fetchFormattedProduct(ctn: ""), "")
    }
    
    func testFetchFormattedProductWithAlreadyFormattedCTN() {
        let testMicro = ECSProductMicroServices()
        XCTAssertEqual(testMicro.fetchFormattedProduct(ctn: "HX3451_02"), "HX3451_02")
    }
}
