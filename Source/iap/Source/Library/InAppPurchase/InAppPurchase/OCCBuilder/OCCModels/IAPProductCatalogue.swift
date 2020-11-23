/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient

class IAPProductModel {
    fileprivate var productCTN: String = ""
    fileprivate var totalPrice: String = ""
    fileprivate var totalPriceValue: String = ""
    fileprivate var discountPrice: String = ""
    fileprivate var discountedPriceValue = ""
    fileprivate var priceDict: [String: AnyObject] = [String: AnyObject]()
    fileprivate var productTitle: String = ""
    fileprivate var productDescription: String = ""
    fileprivate var productThumbnailImageURL: String = ""
    fileprivate var quantity: Int = 1
    fileprivate var productDetailURLS = [PRXAssetAsset]()
    fileprivate var productDetailFetchError: NSError?
    fileprivate var entryNumber: Int = 0
    fileprivate var stockAmount: Int = 0
    fileprivate var productBasePrice: String = ""
    fileprivate var subCategory: String = ""
    fileprivate var stockLevelStatus: String = ""
    fileprivate var trackingURL: String?
    
    var disclaimers: [IAPProductDisclaimer] = []
    init(inDict: [String: AnyObject] = [String: AnyObject]()) {
        if let code = inDict[IAPConstants.IAPProductCatalogue.kProductCTNKey] as? String {
            self.productCTN = code
        }

        if let stockDict = inDict[IAPConstants.IAPProductCatalogue.kProductStockKey] as? [String: AnyObject] {
            if let stockStatus = stockDict[IAPConstants.IAPProductCatalogue.kProductStockStatusKey] as? String {
                self.stockLevelStatus = stockStatus
            }
            if let amount = stockDict[IAPConstants.IAPShoppingCartKeys.kStockLevelKey] as? Int {
                self.stockAmount = amount
            }
        }

        if let priceDictionary = inDict[IAPConstants.IAPProductCatalogue.kProductPriceKey] as? [String: AnyObject] {
            self.priceDict = priceDictionary
            if let priceValue = priceDictionary[IAPConstants.IAPProductCatalogue.kProductFormattedKey] as? String {
                self.totalPrice = priceValue
            }
            if let rawPriceValue =  priceDictionary[IAPConstants.IAPProductCatalogue.kProductPriceValueKey] as? NSNumber {
                self.totalPriceValue = rawPriceValue.stringValue
            }
        }
        
        if let discountPriceDictionary = inDict[IAPConstants.IAPProductCatalogue.kProductDiscountPriceKey] as? [String: AnyObject] {
            self.priceDict = discountPriceDictionary
            if let discountPriceValue = discountPriceDictionary[IAPConstants.IAPProductCatalogue.kProductFormattedKey] as? String {
                self.discountPrice = discountPriceValue
            }
            if let rawDiscountedPriceValue =  discountPriceDictionary[IAPConstants.IAPProductCatalogue.kProductPriceValueKey] as? NSNumber {
                self.discountedPriceValue = rawDiscountedPriceValue.stringValue
            }
        }
        //super.init()
    }
    
    init(withCTN: String) {
        self.productCTN = withCTN
    }

    // MARK: Setters
    func setProductTitle(_ inTitle: String) {
        self.productTitle = inTitle
    }

    func setProductDescription(_ inDescription: String) {
        self.productDescription = inDescription
    }

    func setThumbnailImageURL(_ inURL: String) {
        self.productThumbnailImageURL = inURL
    }

    func setQuantity(_ inQuantity: Int) {
        self.quantity = inQuantity
    }

    func setProductDetailFetchError(_ inError: NSError) {
        self.productDetailFetchError = inError
    }

    func setProductDetailURLS (_ inDetailURLS: [PRXAssetAsset]) {
        self.productDetailURLS = inDetailURLS
        for url in self.productDetailURLS {
            url.asset = url.asset + "?wid=%@&hei=%@&$pnglarge$&fit=fit,1"
        }
    }

    func setEntryNumber(_ inEntryNumber: Int) {
        self.entryNumber = inEntryNumber
    }

    func setTotalPrice(_ inPrice: String) {
        self.totalPrice = inPrice
    }

    func setDiscountPrice(_ inPrice: String) {
        self.discountPrice = inPrice
    }

    func setProductBasePrice(_ inPrice: String) {
        self.productBasePrice = inPrice
    }
    
    func setStockAmount(_ inStockAmount: Int) {
        self.stockAmount = inStockAmount
    }

    func setStockLevelStatus(_ stockLevelStatus: String) {
        self.stockLevelStatus = stockLevelStatus
    }

    func setProductCTN(_ inCTN: String) {
        self.productCTN = inCTN
    }
    
    func setProductSubCategory(_ inSubCategory: String) {
        self.subCategory = inSubCategory
    }
    
    func setProductTrackingURL(inTrackingURL: String) {
        self.trackingURL = inTrackingURL
    }
    
    // MARK: Getters
    func getQuantity() -> Int {
        return self.quantity
    }
    
    func getProductCTN() -> String {
        return self.productCTN
    }
    
    func getProductStockLevelStatus() -> String {
        return self.stockLevelStatus
    }
    
    func getTotalPrice()->String {
        return self.totalPrice
    }
    
    func getPriceValue()->String {
        return self.totalPriceValue
    }
    
    func getDiscountPrice()->String {
        return self.discountPrice
    }
    
    func getDiscountPriceValue()->String {
        return self.discountedPriceValue
    }
    
    func getProductBasePriceValue()->String {
        return self.productBasePrice
    }
    
    func getProductTitle()->String {
        return self.productTitle
    }
    
    func getProductDescription()->String {
        return self.productDescription
    }
    
    func getProductThumbnailImageURL()->String {
        return self.productThumbnailImageURL
    }
    
    func getProductDetailURLS()->[PRXAssetAsset] {
        return self.productDetailURLS
    }
    
    func getEntryNumber() -> Int {
        return self.entryNumber
    }
    
    func getStockAmount() -> Int {
        return self.stockAmount
    }
    
    func getSubCategory() -> String {
        return self.subCategory
    }
    
    func getDetailFetchError() -> NSError? {
        return self.productDetailFetchError
    }
    
    func getTrackingURL() -> String? {
        return self.trackingURL
    }
}

extension IAPProductModel {
    func updateValue(_ withDict: [String: AnyObject]) {
        if let discountPriceDict = withDict[IAPConstants.IAPProductCatalogue.kProductDiscountPriceKey] as? [String: AnyObject] {
            if let discountPriceValue = discountPriceDict[IAPConstants.IAPProductCatalogue.kProductFormattedKey] as? String {
                self.discountPrice = discountPriceValue
            }
            if let rawDiscountedPriceValue =  discountPriceDict[IAPConstants.IAPProductCatalogue.kProductPriceValueKey] as? NSNumber {
                self.discountedPriceValue = rawDiscountedPriceValue.stringValue
            }
        }
        
        if let priceDictionary = withDict[IAPConstants.IAPProductCatalogue.kProductPriceKey] as? [String: AnyObject] {
            self.priceDict = priceDictionary
            if let priceValue = priceDictionary[IAPConstants.IAPProductCatalogue.kProductFormattedKey] as? String {
                self.totalPrice = priceValue
            }
            if let rawPriceValue =  priceDictionary[IAPConstants.IAPProductCatalogue.kProductPriceValueKey] as? NSNumber {
                self.totalPriceValue = rawPriceValue.stringValue
            }
        }
    }
}

class IAPProductModelCollection {
    fileprivate var products: [IAPProductModel] = [IAPProductModel]()
    convenience init(inDict: [String: AnyObject]) {
        self.init()
        if let products = inDict[IAPConstants.IAPProductCatalogue.kProductKey] as? [[String: AnyObject]] {
            self.products = products.map {(IAPProductModel(inDict: $0))}
        }
    }
    func getProducts() -> [IAPProductModel] {
        return self.products
    }
}
