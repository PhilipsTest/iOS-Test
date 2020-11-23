/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPCartInfo {
    
    var cartID: String!
    var totalItems: Int!
    var totalPrice: String!
    var totalPriceWithTax: String!
    var currencyTypeIso: String!
    var shippingCost: String!
    var deliveryModeName: String!
    var deliveryModeDescription = ""
    var vatTotal: String!
    var entries = [IAPProductModel]()
    var isTaxInclusive = false
    var priceWithTax: String!
    var freeShipping = false
    var freeDelivery: String?
    var totalUnitCount: Int!
    var orderDiscounts: IAPOrderDiscountList?
    var voucherDiscounts: IAPVoucherList?
    

    convenience init(inDict: NSDictionary) {
        self.init()
        typealias CartKey = IAPConstants.IAPShoppingCartInfoKeys
        typealias JsonDictionary = [String: AnyObject]
        
        cartID = inDict[CartKey.kCartIDKey] as? String
        totalItems = inDict[CartKey.kTotalItemsKey] as? Int
        
        totalUnitCount = inDict[CartKey.kTotalUnitCountKey] as? Int
        
        if let priceDict = inDict[CartKey.kTotalPriceKey] as? JsonDictionary {
            totalPrice = priceDict[CartKey.kFormattedValueKey] as? String
            currencyTypeIso = priceDict[CartKey.kCurrencyTypeIsoKey] as? String
        }
        
        if let priceWithTaxDict    = inDict[CartKey.kTotalPriceWithTaxKey] as? JsonDictionary {
            totalPriceWithTax  = priceWithTaxDict[CartKey.kFormattedValueKey] as? String
        }
        
        if let taxDictTo   = inDict[CartKey.kTotalTaxKey] as? JsonDictionary {
            vatTotal  = taxDictTo[CartKey.kFormattedValueKey] as? String
        }
        
        if let deliveryModeDict = inDict[CartKey.kDeliveryModeKey] as? JsonDictionary {
            
            if let deliveryMethodName = deliveryModeDict[CartKey.kDeliveryModeNameKey] as? String {
                deliveryModeName = deliveryMethodName
            }
            if let deliveryMethodDescription = deliveryModeDict[IAPConstants.IAPDeliveryModeKeys.kDescriptionKey] as? String {
                deliveryModeDescription = deliveryMethodDescription
            }
            
            let shippingCostDict = deliveryModeDict[CartKey.kShippingCostKey] as? JsonDictionary
            shippingCost = shippingCostDict![CartKey.kFormattedValueKey] as? String
        }
        
        var entriesCreated      = [IAPProductModel]()
        let entriesDict         = inDict["entries"] as? [JsonDictionary]
        
        if let entriesDictionary = entriesDict {
            entriesCreated = entriesDictionary.map { (getProductModel(IAPCartEntriesInfo(inDict:$0))) }
        }
        
        entries = entriesCreated
        
        guard let taxInclusion = inDict[CartKey.kTaxInclusionKey] as? Bool else { return }
        isTaxInclusive = taxInclusion
        
        
        if let appliedOrderPromotionsList = inDict[IAPConstants.IAPOrderDiscountKeys.kAppliedOrderPromotionsKey] as? [JsonDictionary] {
            if let appliedPromotionsFirstObject = appliedOrderPromotionsList.first {
                if let promotions = appliedPromotionsFirstObject[IAPConstants.IAPOrderDiscountKeys.kPromotionKey] as? JsonDictionary {
                    if let codeStr = promotions["code"] as? String {
                        // need to add the localized string for "free" once we get
                        if
                            nil != codeStr.range(of: "ship", options: .caseInsensitive),
                            nil != codeStr.range(of: "free", options: .caseInsensitive) {
                            freeShipping = true
                            // Need to add localized string
                            freeDelivery = IAPLocalizedString("iap_free_Delivery") ?? ""
                        }
                    }
                }
            }
            orderDiscounts = IAPOrderDiscountList(inDict: appliedOrderPromotionsList)
        }
        
        if let voucherResponse = inDict as? JsonDictionary {
            voucherDiscounts = IAPVoucherList(inDict: voucherResponse, isFromCart: true)
        }
    }
    
    func getcartID() -> String {
        return cartID
    }
    
    func getTotalItems()->Int {
        return totalItems
    }
    
    func getTotalUnitCount()->Int {
        return totalUnitCount
    }
    
    func getTotalPrice()->String {
        return totalPrice
    }
    
    func getTotalPriceWithTax()->String {
        return totalPriceWithTax
    }
    
    func getCurrencyTypeIso()->String {
        return currencyTypeIso
    }
    
    func getProductModel(_ productObject: IAPCartEntriesInfo)->IAPProductModel {
        let productModel = IAPProductModel()
        productModel.setStockAmount(productObject.stockAmount)
        if let stockLevelStatus = productObject.stockLevelStatus{
            productModel.setStockLevelStatus(stockLevelStatus)
        }
        productModel.setEntryNumber(productObject.entryNumber)
        productModel.setQuantity(productObject.quantity)
        if let price = productObject.productPrice {
            productModel.setTotalPrice(price)
        }
        
        if let basePrice = productObject.productBasePrice {
            productModel.setProductBasePrice(basePrice)
        }
        
        if let codeNumber = productObject.ctn {
            productModel.setProductCTN(codeNumber)
        }
        return productModel
    }
}

