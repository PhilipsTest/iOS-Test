/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPOCCCartInterfaceBuilderTests: XCTestCase {
    
   func testInterfaceCreation() {
        let interfaceBuilder = IAPOCCCartInterfaceBuilder(inUserID:"12345")!
        XCTAssertNotNil(interfaceBuilder,"Builder not initialised")
        
        var occInterface = interfaceBuilder.withQuantity(19).buildInterface()
        XCTAssertNotNil(occInterface,"Interface is not properly initialised")
        XCTAssert(occInterface.quantity == 19,"Quantities don't match")
        
        occInterface = interfaceBuilder.withProductCode("XYA").buildInterface()
        XCTAssertNotNil(occInterface,"Interface is not properly initialised")
        XCTAssert(occInterface.productCode == "XYA","Codes don't match")
        
        occInterface = interfaceBuilder.withVoucherCode("abc").buildVoucherInterface()
        XCTAssertNotNil(occInterface,"Interface is not properly initialised")
        XCTAssert(occInterface.voucherCode == "abc","Codes don't match")
        
        occInterface = interfaceBuilder.withEntryNumber(20).withProductCode("XYA").withFetchDetail(true).withCartID("Current").withCurrentPage(0).buildInterface()
        XCTAssertNotNil(occInterface,"Interface is not properly initialised")
        XCTAssert(occInterface.productCode == "XYA","Codes don't match")
        XCTAssert(occInterface.entryNumber == 20,"Entry number don't match")
        XCTAssert(occInterface.cartID == "Current","Quantities don't match")
        XCTAssert(occInterface.shouldFetchDetail == true, "Values don't match")
        XCTAssert(occInterface.currentPage == 0,"Current page don't match")
    }
}

