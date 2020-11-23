/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSAddressListTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAddressListCase1() {
        let address1 = ECSAddress()
        address1.addressID = "123"
        address1.billingAddress = true
        address1.firstName = "test"
        address1.lastName = "test2"
        
        let addressList = address1.addressParameter
        XCTAssert(addressList["lastName"] == "test2")
        XCTAssert(addressList["addressID"] == nil)
    }
    
    func testAddressListCase2() {
        let address1 = ECSAddress()
        
        let addressList = address1.addressParameter
        XCTAssert(addressList["lastName"] == nil)
        XCTAssert(addressList["addressID"] == nil)
    }
}
