/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPShoppingCartDatasourceTests: XCTestCase {
    
    let shoppingDataSource = IAPShoppingCartDataSource()
    var productModels: [IAPProductModel] = []
    
    override func setUp() {
        super.setUp()
        IAPConfiguration.sharedInstance.locale = "en_US"
        let dictionary   = self.deserializeData("IAPProductSampleResponse")
        let productsInfo = IAPProductModelCollection(inDict: dictionary!)
        productModels = productsInfo.getProducts()
        
    }
    
   func testGetProductInformationFromPRX() {
        IAPPRXDataDownloader().getProductInformationFromPRX(productModels, completion: { (withProducts:[IAPProductModel]) -> () in
            XCTAssert(withProducts.count > 0, "Returned prx product information is not valid")
        })
    }
    
    func testGetPRXProductDetailsAssets() {
        IAPPRXDataDownloader().getPRXProductDetailsAssets(productModels[0]) { (successProductInfo:IAPProductModel, errorCTNList:String) in
            XCTAssertNotNil(successProductInfo, "Returned prx product information is not valid")
        }
    }
    
    func testGetCartInformation() {
        shoppingDataSource.getCartInformation(productModels,success:{ (inSuccess, cartInfoObject, withProductList) -> () in
            XCTAssertNotNil(cartInfoObject,"cart info returned is nil")
            XCTAssertNotNil(withProductList,"product list returned is nil")
            XCTAssertTrue(inSuccess, "Success response should be returned")
        }) { (inError: NSError) -> () in
            XCTAssertNotNil(inError, "Error returned is nil")
        }
    }
    
    func testUpdateQuantity() {
        shoppingDataSource.product = productModels[0]
        shoppingDataSource.quantity = 5
        shoppingDataSource.updateQuantity({ (inSuccess:Bool) in
            XCTAssertTrue(inSuccess, "Response should be true")
        }) { (inError:NSError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
}
