/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev
@testable import PhilipsPRXClient
@testable import AppInfra

class IAPPRXInterfaceTest: XCTestCase {

  func testInitialisation() {
        let prxInterface = IAPPRXInterface()
        XCTAssertNotNil(prxInterface.getLocale(), "Locale is not initialised")
        
        let requestManager = prxInterface.getPRXRequestManager()
        XCTAssertNotNil(requestManager, "Request Manager is nil")
        
        let assetBuilder = prxInterface.getPRXAssetBuilder(B2C, productCTN: "HX9042/64", catalog: CONSUMER)
        XCTAssertNotNil(assetBuilder, "Asset Builder is nil")

    let summaryBuilder =  prxInterface.getPRXSummaryListBuilder(B2C, productCTNs: ["HX9042/64"], catalog: CONSUMER)
        XCTAssertNotNil(summaryBuilder, "Summary Builder is nil")
    }
    
    func testSetProductInfoForOneProduct() {
        let productModel = IAPProductModel(withCTN: "HX8071/10")
        let summaryResponse = PRXSummaryListResponse()
        
        let summaryDict = self.deserializeData("IAPPRXSummaryResponse")!
        if let summaryListDict = summaryDict["data"] as? [[AnyHashable: Any]] {
            summaryResponse.data = [PRXSummaryData.modelObject(with: summaryListDict.first)]
            summaryResponse.success = true
            let prxInterface = IAPPRXInterface()
            prxInterface.setProductSummaryList(for: summaryResponse, with: [productModel])
        }
        XCTAssertNotEqual(productModel.getProductTitle().count, 0)
        XCTAssertNotNil(productModel.getProductDescription(), "Description is nil")
        XCTAssertNotEqual(productModel.getProductThumbnailImageURL().count, 0)
        XCTAssertNotEqual(productModel.getSubCategory().count, 0)
    }
    
    func testSetProductInfoForMultipleProducts() {
        let productModelFirst = IAPProductModel(withCTN: "HX8071/10")
        let productModelSecond = IAPProductModel(withCTN: "HX6876/29")
        let summaryResponse = PRXSummaryListResponse()
        
        let summaryDict = self.deserializeData("IAPPRXSummaryResponse")!
        if let summaryListDict = summaryDict["data"] as? [[AnyHashable: Any]] {
            var productData = [PRXSummaryData]()
            for summary in summaryListDict {
                productData.append(PRXSummaryData.modelObject(with: summary))
            }
            summaryResponse.data = productData
            summaryResponse.success = true
            let prxInterface = IAPPRXInterface()
            prxInterface.setProductSummaryList(for: summaryResponse, with: [productModelFirst,productModelSecond])
        }
        XCTAssertNotEqual(productModelFirst.getProductTitle().count, 0)
        XCTAssertNotNil(productModelFirst.getProductDescription(), "Description is nil")
        XCTAssertNotEqual(productModelFirst.getProductThumbnailImageURL().count, 0)
        XCTAssertNotEqual(productModelFirst.getSubCategory().count, 0)
        
        XCTAssertNotEqual(productModelSecond.getProductTitle().count, 0)
        XCTAssertNotNil(productModelSecond.getProductDescription(), "Description is nil")
        XCTAssertNotEqual(productModelSecond.getProductThumbnailImageURL().count, 0)
        XCTAssertNotEqual(productModelSecond.getSubCategory().count, 0)
    }
    
    func testSetProductInfoForMultipleProductsWithOneAvailableCTN() {
        let productModelFirst = IAPProductModel(withCTN: "HX8071/10")
        let productModelSecond = IAPProductModel(withCTN: "HX9042/64")
        let summaryResponse = PRXSummaryListResponse()
        
        let summaryDict = self.deserializeData("IAPPRXSummaryResponse")!
        if let summaryListDict = summaryDict["data"] as? [[AnyHashable: Any]] {
            var productData = [PRXSummaryData]()
            for summary in summaryListDict {
                productData.append(PRXSummaryData.modelObject(with: summary))
            }
            summaryResponse.data = productData
            summaryResponse.success = true
            let prxInterface = IAPPRXInterface()
            prxInterface.setProductSummaryList(for: summaryResponse, with: [productModelFirst,productModelSecond])
        }
        XCTAssertNotEqual(productModelFirst.getProductTitle().count, 0)
        XCTAssertNotNil(productModelFirst.getProductDescription(), "Description is nil")
        XCTAssertNotEqual(productModelFirst.getProductThumbnailImageURL().count, 0)
        XCTAssertNotEqual(productModelFirst.getSubCategory().count, 0)
        
        XCTAssertEqual(productModelSecond.getProductTitle().count, 0)
        XCTAssertEqual(productModelSecond.getProductThumbnailImageURL().count, 0)
        XCTAssertEqual(productModelSecond.getSubCategory().count, 0)
    }
    
    func testSetProductInfoForMultipleProductsWithNoAvailableCTN() {
        let productModelFirst = IAPProductModel(withCTN: "HX8071/10")
        let productModelSecond = IAPProductModel(withCTN: "HD7870_10")
        let summaryResponse = PRXSummaryListResponse()
        
        let summaryDict = self.deserializeData("IAPPRXSummaryResponse")!
        if let summaryListDict = summaryDict["data"] as? [[AnyHashable: Any]] {
            var productData = [PRXSummaryData]()
            for summary in summaryListDict {
                productData.append(PRXSummaryData.modelObject(with: summary))
            }
            summaryResponse.data = productData
            summaryResponse.success = true
            let prxInterface = IAPPRXInterface()
            prxInterface.setProductSummaryList(for: summaryResponse, with: [productModelFirst,productModelSecond])
        }
        XCTAssertEqual(productModelSecond.getProductTitle().count, 0)
        XCTAssertEqual(productModelSecond.getProductThumbnailImageURL().count, 0)
        XCTAssertEqual(productModelSecond.getSubCategory().count, 0)
        
        XCTAssertEqual(productModelSecond.getProductTitle().count, 0)
        XCTAssertEqual(productModelSecond.getProductThumbnailImageURL().count, 0)
        XCTAssertEqual(productModelSecond.getSubCategory().count, 0)
    }
    
    func testSetProductThumbnails() {
        let prxInterface = IAPPRXInterface()
        let productModel = IAPProductModel()
        let assetResponse = PRXAssetResponse()
        
        let assetDict = self.deserializeData("IAPPRXAssetResponse")!
        if let data = PRXAssetData.modelObject(with: assetDict["data"] as? [AnyHashable: Any]) {
            assetResponse.data = data
            assetResponse.success = true
            prxInterface.setProductThumbnails(productModel, inData: assetResponse)
        }
        XCTAssert(productModel.getProductDetailURLS().count > 0, "Asset detail urls are not set")
    }
    
    func testGetInfromationSuccess() {
        let manager = IAPPRXTestRequestManager()
        manager.jsonName = "IAPPRXSummaryResponse"
        
        let productModel = IAPProductModel()
        productModel.setProductCTN("HX8071/10")
        
        let prxInterface = IAPPRXInterface()
        let summaryBuilder =  prxInterface.getPRXSummaryListBuilder(B2C, productCTNs: ["HX9042/64"], catalog: CONSUMER)
        prxInterface.getInformationForProducts(manager, prxSummaryBuilder: summaryBuilder,
                                               products: [productModel]) { (inModel: [IAPProductModel]) in
            XCTAssertNotEqual(inModel.first?.getProductTitle().count, 0)
            XCTAssertNotNil(inModel.first?.getProductDescription(), "Description is nil")
            XCTAssertNotEqual(inModel.first?.getProductThumbnailImageURL().count, 0)
            XCTAssertNotEqual(inModel.first?.getSubCategory().count, 0)
        }
    }

    func testGetInfromationFailure() {
        let manager = IAPPRXTestRequestManager()
        manager.jsonName = "IAPPRXSummaryResponse"
        manager.isErrorToBeInvoked = true
        let productModel = IAPProductModel()
        productModel.setProductCTN("HX8071/10")
        let prxInterface = IAPPRXInterface()
        let summaryBuilder =  prxInterface.getPRXSummaryListBuilder(B2C, productCTNs: ["HX8071/10"], catalog: CONSUMER)
        prxInterface.getInformationForProducts(manager, prxSummaryBuilder: summaryBuilder,
                                               products: [productModel]) { (inModel: [IAPProductModel]) in
            XCTAssert(inModel.first?.getProductTitle().length == 0, "Title is empty")
            XCTAssert(inModel.first?.getProductDescription().length == 0, "Description is empty")
            XCTAssert(inModel.first?.getProductThumbnailImageURL().length == 0, "Thumbnail Image URL is empty")
            XCTAssert(inModel.first?.getSubCategory().length == 0, "Product sub category is empty")
        }
    }
    
    func testGetInfromationWithFalse() {
        let manager = IAPPRXTestRequestManager()
        manager.shouldReturnFalse = true
        let productModel = IAPProductModel()
        productModel.setProductCTN("HX8071/10")
        
        let prxInterface = IAPPRXInterface()
        let summaryBuilder =  prxInterface.getPRXSummaryListBuilder(B2C, productCTNs: ["HX8071/10"], catalog: CONSUMER)
        prxInterface.getInformationForProducts(manager, prxSummaryBuilder: summaryBuilder,
                                               products: [productModel]) { (inModel: [IAPProductModel]) in
            XCTAssert(inModel.first?.getProductTitle().length == 0, "Title is empty")
            XCTAssert(inModel.first?.getProductDescription().length == 0, "Description is empty")
            XCTAssert(inModel.first?.getProductThumbnailImageURL().length == 0, "Thumbnail Image URL is empty")
            XCTAssert(inModel.first?.getSubCategory().length == 0, "Product sub category is empty")
        }
    }

    func testGetDetailAssetSuccess() {
        let manager = IAPPRXTestRequestManager()
        manager.jsonName = "IAPPRXAssetResponse"
        manager.isErrorToBeInvoked = false
        let productModel = IAPProductModel()
        productModel.setProductCTN("HX9042/64")
        let prxInterface = IAPPRXInterface()
        let assetBuilder =  prxInterface.getPRXAssetBuilder(B2C, productCTN: "HX9042/64", catalog: CONSUMER)
        prxInterface.getPRXProductDetailsAssets(manager, prxAssetBuilder: assetBuilder,
                                            productInfo: productModel) { (inModel: IAPProductModel, erroCTN: String) in
            XCTAssert(inModel.getProductDetailURLS().count > 0, "Asset detail urls are not set")
        }
    }

    func testGetDetailAssetFailure() {
        let manager = IAPPRXTestRequestManager()
        manager.isErrorToBeInvoked = true
        let productModel = IAPProductModel()
        productModel.setProductCTN("HX9042/64")
        let prxInterface = IAPPRXInterface()
        let assetBuilder =  prxInterface.getPRXAssetBuilder(B2C, productCTN: "HX9042/64", catalog: CONSUMER)
        prxInterface.getPRXProductDetailsAssets(manager, prxAssetBuilder: assetBuilder,
                                            productInfo: productModel) { (inModel: IAPProductModel, erroCTN: String) in
            XCTAssert(inModel.getProductDetailURLS().count == 0, "Asset detail urls are set")
        }
    }

}

class IAPPRXTestRequestManager: PRXRequestManager {
    var jsonName: String!
    var isErrorToBeInvoked = false
    var shouldReturnFalse = false
    
    override func execute(_ request: PRXRequest!, completion: ((PRXResponseData?)-> ())!, failure: ((Error?) -> ())!) {
        guard self.isErrorToBeInvoked == false else {
            let error = NSError(domain: "Mocked Error", code: 1000, userInfo: nil)
            failure!(error)
            return
        }
        guard self.shouldReturnFalse == false else {
            let dict = self.deserializeData("IAPPRXSummaryFailureResponse")
            let response = request?.getResponse(dict)
            completion(response)
            return
        }
        let dict = self.deserializeData(self.jsonName)
        let response = request?.getResponse(dict)
        completion(response)
    }

}

extension IAPPRXTestRequestManager {
    func deserializeData (_ withJSONName: String) -> [String: AnyObject]? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: withJSONName, ofType: "json") else {
            return nil
        }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        var jsonDict: [String: AnyObject]?

        do {
            jsonDict = try JSONSerialization.jsonObject(with: data!,
                                        options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: AnyObject]
        } catch let inError as NSError {
            print("\(inError) is the error while converting JSON")
        }
        return jsonDict
    }
}
