/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient

// MARK: - ECSPILProducts
@objcMembers public class ECSPILProducts: NSObject, Codable {
    public var products: [ECSPILProduct]?

    enum CodingKeys: String, CodingKey {
        case products = "commerceProducts"
    }
}

// MARK: - ECSPILProduct
@objcMembers public class ECSPILProduct: NSObject, Codable {
    public var ctn, type: String?
    public var attributes: ECSPILAttributes?

    /// Summary details of the product
    public var productPRXSummary: PRXSummaryData?

    /// Asset details about the product
    /// - Since: 1905.0.0
    public var productAssets: PRXAssetData?

    /// Disclaimer information about the product
    /// - Since: 1905.0.0
    public var productDisclaimers: PRXDisclaimerData?

    enum CodingKeys: String, CodingKey {
        case ctn = "id"
        case type, attributes
    }
}

// MARK: - ECSPILAttributes
@objcMembers public class ECSPILAttributes: NSObject, Codable {
    public var title: String?
    public var image: String?
    public var availability: ECSPILProductAvailability?
    public var deliveryTime: String?
    public var price, discountPrice: ECSPILPrice?
    public var references: [ECSPILReference]?
    public var promotions: ECSPILPromotions?
    public var taxRelief: Bool?
}

// MARK: - ECSPILProductAvailability
@objcMembers public class ECSPILProductAvailability: NSObject, Codable {
    public var status: String?
    public var quantity: Int?
}

// MARK: - ECSPILPromotions
@objcMembers public class ECSPILPromotions: NSObject, Codable {
    public var productPromotions: [ECSPILProductPromotion]?
}

// MARK: - ECSPILReference
@objcMembers public class ECSPILReference: NSObject, Codable {
    public var type, ctn, title: String?
    public var image: String?
    public var price, discountPrice: ECSPILPrice?
    public var availability: ECSPILProductAvailability?
    public var productType: String?

    enum CodingKeys: String, CodingKey {
        case ctn = "id"
        case type, title, image, price, discountPrice, availability, productType
    }
}
