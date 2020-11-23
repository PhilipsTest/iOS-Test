/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPCartEntriesInfo {
    var ctn: String!
    var quantity = 1
    var entryNumber = 0
    var stockAmount = 0
    var stockLevelStatus: String?
    var productPrice: String!
    var productBasePrice: String!

    convenience init(inDict: [String: AnyObject]) {
        self.init()
        self.quantity       = inDict[IAPConstants.IAPShoppingCartKeys.kQuantityKey] as? Int ?? 0
        self.entryNumber    = inDict[IAPConstants.IAPShoppingCartKeys.kEntryNumberKey] as? Int ?? 0
        
        if let productDict = inDict[IAPConstants.IAPShoppingCartKeys.kProductKey] as? [String: AnyObject],
            let stockDict = productDict[IAPConstants.IAPShoppingCartKeys.kStockKey] as? [String: AnyObject] {

            self.ctn = productDict[IAPConstants.IAPShoppingCartKeys.kCtnCodeKey] as? String ?? ""
            if let status = stockDict[IAPConstants.IAPShoppingCartKeys.kStockLevelStatusKey] as? String {
                self.stockLevelStatus = status
                guard status != IAPConstants.IAPShoppingCartKeys.kOutOfStockKey else {
                    return
                }
                if let amount = stockDict[IAPConstants.IAPShoppingCartKeys.kStockLevelKey] as? Int {
                    self.stockAmount = amount
                }
            }
        }
        if let priceDict = inDict[IAPConstants.IAPShoppingCartKeys.kTotalPriceKey] as? [String: AnyObject] {
            self.productPrice   = priceDict[IAPConstants.IAPShoppingCartKeys.kPriceValueKey] as? String
        }
        if let basePriceDict = inDict[IAPConstants.IAPShoppingCartKeys.kProductPriceKey] as? [String: AnyObject] {
            self.productBasePrice   = basePriceDict[IAPConstants.IAPShoppingCartKeys.kPriceValueKey] as? String
        }
    }
}
