/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient
import AppInfra

class IAPPRXInterface {
    fileprivate var locale: String!
    func getPRXProductDetailsAssets(_ requestManager: PRXRequestManager,
                                    prxAssetBuilder: PRXAssetRequest,
                                    productInfo: IAPProductModel,
                                    completion:@escaping (IAPProductModel, String) -> Void) {
        requestManager.execute(prxAssetBuilder, completion: { (inData: PRXResponseData?) in
            self.setProductThumbnails(productInfo, inData: inData!)
            completion(productInfo, "")
            }) { (inError) in
                productInfo.setProductDetailFetchError(inError! as NSError)
                completion(productInfo, "")
        }
    }

    func getPRXProductDisclaimer(_ requestManager: PRXRequestManager,
                                 prxAssetBuilder: PRXDisclaimerRequest, completion: @escaping ([IAPProductDisclaimer]) -> Void)  {
        requestManager.execute(prxAssetBuilder, completion: { (inData: PRXResponseData?) in
            guard let disclamerData = inData as? PRXDisclaimerResponse,
                let disclaimerList = disclamerData.data.disclaimers.disclaimer as? [PRXDisclaimer] else {
                    completion([])
                return
            }
            var mappedDisclaimers: [IAPProductDisclaimer] = []
            for disclaimer in disclaimerList {
                mappedDisclaimers.append(IAPProductDisclaimer(with: disclaimer))
            }
            completion(mappedDisclaimers)

        }) { (inError) in
            completion([])
        }
    }
    
    func getInformationForProducts(_ withManager: PRXRequestManager,
                                  prxSummaryBuilder: PRXSummaryListRequest,
                                  products: [IAPProductModel], completion: @escaping ([IAPProductModel]) -> Void) {
        withManager.execute(prxSummaryBuilder, completion: { (inData: PRXResponseData?) in
            guard let passedInData = inData as? PRXSummaryListResponse, passedInData.success else {
                completion(products)
                return
            }
            self.setProductSummaryList(for: passedInData, with: products)
            completion(products)
        }) { (inError) in
            completion(products)
        }
    }
    
    func setProductSummaryList(for response: PRXSummaryListResponse, with productModels: [IAPProductModel]) {
        if let productSummaryList = response.data as? [PRXSummaryData] {
            var productSummaryDict = [String:PRXSummaryData]()
            for productSummary in productSummaryList {
                productSummaryDict[productSummary.ctn] = productSummary
            }
            self.setProductsInfo(in: productModels, with: productSummaryDict)
        }
    }
    
    func setProductThumbnails(_ productInfo: IAPProductModel, inData: PRXResponseData) {
        if  let passedInData = inData as? PRXAssetResponse {
            if let convertedData = passedInData.data.assets.asset as? [PRXAssetAsset] {
                let productDetailsURLS: NSMutableArray = []
                for imageType in ["RTP", "APP", "DPP", "MI1", "PID"] {
                    let predicate = NSPredicate(format: "type =%@", imageType)
                    let imageArray: NSArray = (convertedData as NSArray).filtered(using: predicate) as NSArray
                    guard imageArray.count>0 else { continue }
                    productDetailsURLS.add(imageArray.object(at: 0))
                }
                if let productURLS = productDetailsURLS as? [PRXAssetAsset] {
                    productInfo.setProductDetailURLS(productURLS)
                }
            }
        }
    }
    
    func setProductsInfo(in inProducts: [IAPProductModel], with productData: [String:PRXSummaryData]) {
        for iapProduct in inProducts {
            if let productSummaryData = productData[iapProduct.getProductCTN()] {
                if let productTitle = productSummaryData.productTitle {
                    iapProduct.setProductTitle(productTitle)
                }
                
                if let marketingText = productSummaryData.marketingTextHeader {
                    iapProduct.setProductDescription(marketingText)
                }
                
                if let thumbImage = productSummaryData.imageURL {
                    iapProduct.setThumbnailImageURL(thumbImage)
                }
                
                if let subcateg = productSummaryData.subcategory {
                    iapProduct.setProductSubCategory(subcateg)
                }
            }
        }
    }

    init() {
        self.locale = IAPConfiguration.sharedInstance.locale!
    }

    func getLocale() -> String {
        return self.locale
    }
    
    func getPRXRequestManager() -> PRXRequestManager {
        let sharedAppInfra = IAPConfiguration.sharedInstance.sharedAppInfra
        let prxDependencies: PRXDependencies = PRXDependencies(appInfra: sharedAppInfra, parentTLA: "IAP")
        let requestManager: PRXRequestManager = PRXRequestManager(dependencies: prxDependencies)
        return requestManager
    }
    
    func getPRXAssetBuilder(_ sector: Sector, productCTN: String, catalog: Catalog) -> PRXAssetRequest {
        return PRXAssetRequest(sector: sector, ctnNumber: productCTN, catalog: catalog)
    }

    func getPRXDisclaimerBuilder(_ sector: Sector, productCTN: String, catalog: Catalog) -> PRXDisclaimerRequest {
        return PRXDisclaimerRequest(sector: sector, ctnNumber: productCTN, catalog: catalog)
    }
    
    func getPRXSummaryListBuilder(_ sector: Sector, productCTNs: [String], catalog: Catalog) -> PRXSummaryListRequest {
        return PRXSummaryListRequest(sector: sector, ctnNumbers: productCTNs, catalog: catalog)
    }
}
