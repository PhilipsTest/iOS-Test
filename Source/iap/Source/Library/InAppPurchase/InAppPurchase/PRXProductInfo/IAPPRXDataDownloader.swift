//
//  IAPPRXDataDownloader.swift
//  InAppPurchase
//
//  Created by Prasad Devadiga on 26/11/18.
//  Copyright © 2018 Rakesh R. All rights reserved.
//

import UIKit
import PhilipsPRXClient

class IAPPRXDataDownloader: NSObject {

    func getProductInformationFromPRX(_ products:[IAPProductModel], completion: @escaping ([IAPProductModel])->()) {

        var productCTNs: [String] = []
        let requestDispathQueue = DispatchQueue(label: "IAPPRXQueue", attributes: [])
        let prxInterface = IAPPRXInterface()

        requestDispathQueue.async { () -> Void in
            products.forEach({ productCTNs.append($0.getProductCTN())})
                let restManager = prxInterface.getPRXRequestManager()
                let summaryBuilder = prxInterface.getPRXSummaryListBuilder(B2C, productCTNs: productCTNs, catalog: CONSUMER)

                prxInterface.getInformationForProducts(restManager, prxSummaryBuilder: summaryBuilder, products: products) { (inProducts: [IAPProductModel]) -> () in
                    DispatchQueue.main.async {
                        completion(inProducts)
                    }
                }
        }
    }

    func getPRXProductDisclaimerText(_ productInfo: IAPProductModel, completion:@escaping ([IAPProductDisclaimer])->()) {
        let prxInterface = IAPPRXInterface()
        let requestManager = prxInterface.getPRXRequestManager()
        let prxAssetBuilder = prxInterface.getPRXDisclaimerBuilder(B2C, productCTN: productInfo.getProductCTN(), catalog: CONSUMER)
        prxInterface.getPRXProductDisclaimer(requestManager, prxAssetBuilder: prxAssetBuilder) { (disclaimerList) in
            productInfo.disclaimers = disclaimerList
            completion(disclaimerList)
        }
    }
    
    func getPRXProductDetailsAssets(_ productInfo:IAPProductModel, completion:@escaping (IAPProductModel,String)->()) {

        let prxInterface = IAPPRXInterface()
        let requestManager = prxInterface.getPRXRequestManager()
        let prxAssetBuilder = prxInterface.getPRXAssetBuilder(B2C, productCTN: productInfo.getProductCTN(), catalog: CONSUMER)

        prxInterface.getPRXProductDetailsAssets(requestManager, prxAssetBuilder: prxAssetBuilder, productInfo: productInfo) {
            (successProductInfo:IAPProductModel, errorCTN:String) -> () in
            completion(successProductInfo, errorCTN)
        }
    }

}
