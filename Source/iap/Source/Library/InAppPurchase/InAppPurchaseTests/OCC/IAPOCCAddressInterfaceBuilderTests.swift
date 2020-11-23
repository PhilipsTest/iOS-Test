/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPOCCAddressInterfaceBuilderTests: XCTestCase {
    
    func testInterfaceCreation(){
        let interfaceBuilder = IAPOCCAddressInterfaceBuilder(inUserID: "12345")!
        XCTAssertNotNil(interfaceBuilder,"Builder not initialised")
        
        var occInterface = interfaceBuilder.withRegionCode(
            "US-CA").withPostalCode("92821").withTitleCode("mr.").withFirstName("Mathew").withLastName(
                "Perry").withPhone2("2222").withPhone1("1111").withTown("CA").withAddressLine1(
                    "Line1").withAddressLine2("Line2").withCountryCode(
                        "US").buildInterface()

        XCTAssertNotNil(occInterface, "Interface is not properly initialised")
        XCTAssert(occInterface.regionCode == "US-CA","Region codes don't match")
        XCTAssert(occInterface.postalCode == "92821","Postal Codes don't match")
        XCTAssert(occInterface.titleCode == "mr.","Title Codes don't match")
        XCTAssert(occInterface.firstName == "Mathew", "First Names don't match")
        XCTAssert(occInterface.lastName == "Perry","Last Names don't match")
        XCTAssert(occInterface.phone1 == "1111", "Phone 1 numbers don't match")
        XCTAssert(occInterface.phone2 == "2222", "Phone 2 numbers don't match")
        XCTAssert(occInterface.addressLine1 == "Line1", "Address line 1  don't match")
        XCTAssert(occInterface.addressLine2 == "Line2", "Address line 2 don't match")
        XCTAssert(occInterface.countryCode == "US", "Country Codes don't match")
        
        occInterface = interfaceBuilder.withDefault(false).withAddressID("1000").buildInterface()
        XCTAssertNotNil(occInterface,"Interface is not properly initialised")
        XCTAssert(occInterface.defaultAddress == false,"Default value don't match")
        XCTAssert(occInterface.addressID == "1000", "Address id doesnt match")
        
    }
    
    func testPurchaseHistoryBuilder() {
        let interfaceBuilder = IAPOCCAddressInterfaceBuilder(inUserID: "12345")!
        XCTAssertNotNil(interfaceBuilder,"Builder not initialised")
        
        var occInterface = interfaceBuilder.withPurchaseHistoryCurrentPage(0).buildPurchaseHistoryInterface()
        XCTAssertNotNil(occInterface, "Interface is not initialised")
        XCTAssert(occInterface.purchaseHistoryCurrentPage == interfaceBuilder.purchaseHistorycurrentPage, "Current pages don't match")
        
        occInterface = interfaceBuilder.withPurchaseHistoryCurrentPage(1).buildPurchaseHistoryInterface()
        XCTAssertNotNil(occInterface, "Interface is not initialised")
        XCTAssert(occInterface.purchaseHistoryCurrentPage == interfaceBuilder.purchaseHistorycurrentPage, "Current pages don't match")
    }
    
}
