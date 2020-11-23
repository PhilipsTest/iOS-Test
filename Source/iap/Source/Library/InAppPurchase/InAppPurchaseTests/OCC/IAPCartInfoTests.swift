/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPCartInfoTests: XCTestCase {
    
    func testShoppingCartInfo() {
                
        let dict = self.deserializeData("IAPOCCCartInfoSampleResponse")
        let cartModelInfo = IAPCartInfo(inDict: dict! as NSDictionary)
        XCTAssertNotNil(cartModelInfo)
        
        XCTAssert(cartModelInfo.getcartID() == "14000097235", "CartId does not match")
        XCTAssert(cartModelInfo.getTotalItems() == 2, "Total items does not match")
        XCTAssert(cartModelInfo.getTotalPrice() == "$174.90", "Total Price does not match")
        XCTAssert(cartModelInfo.getTotalPriceWithTax() == "$192.05", "Total price with tax does not match")
        XCTAssert(cartModelInfo.getCurrencyTypeIso() == "USD", "Currency type does not match")
        
    }
}
