/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class ProductInfoTests: XCTestCase {
    
    func testInitialisersForProductInfo(){
        let product = ProductInfo(productCTN: "HX8001")
        XCTAssertNotNil(product, "product is not initialised")
        XCTAssert(product.productCTN == "HX8001", "product CTN does not match")
        
        if let product = ProductInfo(productCTN: "HX8001", quantity: 1) {
            XCTAssert(product.productCTN == "HX8001", "product CTN does not match")
            XCTAssert(product.productQuanity == 1, "product quantity does not match") 
        }
    }
    
}
