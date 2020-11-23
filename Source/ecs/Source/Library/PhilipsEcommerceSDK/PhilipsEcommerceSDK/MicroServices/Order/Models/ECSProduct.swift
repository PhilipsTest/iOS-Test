/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient

// MARK: - ECSProduct
@objcMembers public class ECSProduct: NSObject, Codable {
    public var availableForPickup: Bool?

    /// CTN of the product
    /// - Since: 1905.0.0
    public var ctn: String?

    /// Discounted price of the product
    /// - Since: 1905.0.0
    public var discountPrice: ECSPrice?

    /// Name of the product present in Hybris
    /// - Since: 1905.0.0
    public var name: String?

    /// Price of the product
    /// - Since: 1905.0.0
    public var price: ECSPrice?

    /// tells the stock information of the product in Hybris
    /// - Since: 1905.0.0
    public var stock: ECSStock?

    public var potentialPromotions: [ECSPotentialPromotion]?

    /// Tells the product is purchasable or not
    /// - Since: 1905.0.0
    public var purchasable: Bool?

    /// Gives full detail about the product, this detail is fetched from PRX server
    /// - Since: 1905.0.0
    public var productPRXSummary: PRXSummaryData?

    /// Asset information of the product
    /// - Since: 1905.0.0
    public var productAssets: PRXAssetData?

    /// Disclaimer information about the product
    /// - Since: 1905.0.0
    public var productDisclaimers: PRXDisclaimerData?

    /// String which tells the delivery time of the product
    /// - Since: 1905.0.0
    public var deliveryTime: String?

    /// Gives the list of promotions for the product
    /// - Since: 1905.0.0
    public var productPromotionList: ECSProductPromotionList?

    public var isTaxExemptionApplicable: Bool?
    public var productType: String?
    public var configurable: Bool?
    public var categories: [ECSCategory]?
    public var url: String?
    public var volumePricesFlag: Bool?
    public var priceRange: ECSPriceRange?

    enum CodingKeys: String, CodingKey {
        case availableForPickup, discountPrice, name, price, priceRange, stock, url
        case volumePricesFlag, potentialPromotions, purchasable, categories, configurable
        case deliveryTime, isTaxExemptionApplicable, productType, productPromotionList
        case ctn = "code"
    }
}

// MARK: - ECSProductPromotionList
@objcMembers public class ECSProductPromotionList: NSObject, Codable {
    public var promotions: [ECSProductPromotion]?
}

// MARK: - ECSCategory
@objcMembers public class ECSCategory: NSObject, Codable {
    public var code: String?
    public var url: String?
}

// MARK: - ECSPotentialPromotion
@objcMembers public class ECSPotentialPromotion: NSObject, Codable {
    public var code: String?
}

// MARK: - ECSStock
@objcMembers public class ECSStock: NSObject, Codable {
    public var stockLevelStatus: String?
    public var stockLevel: Int?
}

// MARK: - ECSPriceRange
@objcMembers public class ECSPriceRange: NSObject, Codable {
}
