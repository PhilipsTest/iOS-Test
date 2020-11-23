/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import PhilipsPRXClient
@testable import InAppPurchaseDev

class IAPProductCatalogueTests: XCTestCase {

    func testProductModelCreation() {
        let dictionary   = self.deserializeData("IAPProductSampleResponse")
        let productsInfo = IAPProductModelCollection(inDict: dictionary!)
        XCTAssert(productsInfo.getProducts().count != 0, "Product models are not created")
        XCTAssert(productsInfo.getProducts().count == 3, "Product models count isn't right")
    }
    
    func testPaginationModelCreation() {
        let dictionary   = self.deserializeData("IAPProductSampleResponse")
        if let paginationDict = dictionary!["pagination"] as? [String: AnyObject] {
            let paginationModel = IAPPaginationModel(inDict: paginationDict)
            XCTAssert(paginationModel.getCurrentPage() == 0)
            XCTAssert(paginationModel.getPageSize() == 20)
            XCTAssert(paginationModel.getTotalPages() == 2)
            
            paginationModel.setIsFecthing(false)
            XCTAssert(paginationModel.isDataPending() == true, "Value is not matching")
            
            paginationModel.setIsFecthing(true)
            XCTAssert(paginationModel.isDataPending() == false, "Value is not matching")
            
            var dict = paginationDict
            dict.removeValue(forKey: IAPConstants.IAPPaginationKeys.kCurrentPageKey)
            let paginationModel1 = IAPPaginationModel(inDict: dict)
            XCTAssert(paginationModel1.getCurrentPage() == 0)
            XCTAssert(paginationModel1.getPageSize() == 20)
            XCTAssert(paginationModel1.getTotalPages() == 1)
        } else {
            assertionFailure("Paging failed")
        }
    }
    
    func testIAPProductModelSettersAndGetters(){
        let product = IAPProductModel()
        product.setProductTitle("Sonicare")
        product.setQuantity(1)
        product.setProductCTN("HX8011")
        product.setTotalPrice("150")
        product.setEntryNumber(0)
        product.setStockAmount(20)
        product.setDiscountPrice("100")
        product.setProductDetailURLS([PRXAssetAsset]())
        product.setThumbnailImageURL("www.google.com")
        product.setProductDescription("Brush")
        
        XCTAssert(product.getQuantity() == 1, "Quantity is not set")
        XCTAssert(product.getProductTitle() == "Sonicare", "Title is not set")
        XCTAssert(product.getProductCTN() == "HX8011", "CTN is not set")
        XCTAssert(product.getTotalPrice() == "150", "Total Price is not set")
        XCTAssert(product.getEntryNumber() == 0, "Entry Number is not set")
        XCTAssert(product.getStockAmount() == 20, "Stock Amount is not set")
        XCTAssert(product.getDiscountPrice() == "100", "Discount Price is not set")
        XCTAssert(product.getProductDetailURLS() == [PRXAssetAsset](), "ProductDetail URLs is not set")
        XCTAssert(product.getProductThumbnailImageURL() == "www.google.com", "ThumbnailImageURL is not set")
        XCTAssert(product.getProductDescription() == "Brush", "Product Description is not set")
    }
}
