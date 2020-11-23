/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsPRXClient
@testable import InAppPurchaseDev

class IAPCartDataSourceTests: XCTestCase {

    func testInformationModelFetchForShoppingCart() {
        let dictionary   = self.deserializeData("IAPProductSampleResponse")
        let productsInfo = IAPProductModelCollection(inDict: dictionary!)
        var productInfo = productsInfo.getProducts().first!
        
        let dictionaryWithValues = ["code":"12345","totalItems":12] as [String : Any]
        let cartInfo = IAPCartInfo(inDict: dictionaryWithValues as NSDictionary)
        XCTAssert(cartInfo.cartID != nil, "Cart Id is not properly set")
        XCTAssert(cartInfo.totalItems == 12, "Total items count is not proper")
        
        let cartEntryInfo = IAPCartEntriesInfo()
        cartEntryInfo.stockAmount = 32
        cartEntryInfo.quantity    = 22
        cartEntryInfo.entryNumber = 10
        
        productInfo = cartInfo.getProductModel(cartEntryInfo)
        XCTAssert(productInfo.getStockAmount() == 32, "Stock amount is not correct")
        XCTAssert(productInfo.getQuantity() == 22, "Quantity is not matching")
        XCTAssert(productInfo.getEntryNumber() == 10, "Entry number is not equal")
        
        XCTAssertNil(productInfo.getDetailFetchError(), "Error is not nil")
        productInfo.setProductDetailFetchError(NSError(domain: "Test Error", code: -1009, userInfo: nil))
        XCTAssertNotNil(productInfo.getDetailFetchError(), "Error is nil even after setting it explicitly")
    }
}
