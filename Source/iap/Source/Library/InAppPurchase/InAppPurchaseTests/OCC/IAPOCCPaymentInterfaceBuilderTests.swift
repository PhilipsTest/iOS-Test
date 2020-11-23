/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPOCCPaymentInterfaceBuilderTests: XCTestCase {
    
    func testInterfaceCreation(){
        let interfaceBuilder = IAPOCCPaymentInterfaceBuilder(inUserID: "12345")
        XCTAssertNotNil(interfaceBuilder,"Builder not initialised")
        
        let occInterface = interfaceBuilder?.withOrderID("1400").withPaymentID("4444").buildInterface()
        
        XCTAssertNotNil(occInterface,"Interface is not properly initialised")
        XCTAssert(occInterface?.orderID == "1400","Region codes don't match")
        XCTAssert(occInterface?.paymentID == "4444","Postal Codes don't match")
    }
}
