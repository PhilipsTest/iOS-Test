/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest

@testable import InAppPurchaseDev

class IAPFlowInputTests: XCTestCase {
    
    func testDefaultInit() {
        let defaultFlowInput = IAPFlowInput()
        XCTAssertNotNil(defaultFlowInput, "IAPFlowInput object is not initialized")
    }
    
    func testInitWithCTN() {
        let flowInput = IAPFlowInput(inCTN: "12345")
        XCTAssertNotNil(flowInput, "IAPFlowInput object is not initialized")
        XCTAssert(flowInput.getProductCTN() == "12345", "ctn value is not set")
    }
    
    func testInitWithCtnList() {
        let flowInput = IAPFlowInput(inCTNList: ["12345","54321"])
        XCTAssertNotNil(flowInput, "IAPFlowInput object is not initialized")
        XCTAssertNotNil(flowInput.getProductCTNList(), "IAPFlowInput object does not contain any array list")
    }
}
