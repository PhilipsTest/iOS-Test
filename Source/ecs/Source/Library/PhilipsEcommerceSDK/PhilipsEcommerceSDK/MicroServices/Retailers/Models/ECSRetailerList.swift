/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSRetailerList
@objcMembers public class ECSRetailerList: NSObject, Codable {

    public var wrbresults: ECSWrbResults?

    /// Shorthand variable to get the complete retailer list for the product
    /// - Since: 1905.0.0
    public var retailerList: [ECSRetailer]? {
        return wrbresults?.onlineStoresForProduct?.retailers?.retailer
    }
}

// MARK: - ECSWrbResults
@objcMembers public class ECSWrbResults: NSObject, Codable {

    /// Store loacator url
    /// - Since: 1905.0.0
    public var storeLocatorURL: String?
    public var eloquaSiteURL: String?
    public var showBuyButton: String?
    public var texts: ECSTexts?

    /// CTN of the product
    /// - Since: 1905.0.0
    public var ctn: String?

    /// An object which represent online store details
    /// - Since: 1905.0.0
    public var onlineStoresForProduct: ECSOnlineStoresForProduct?
    public var eloquaSiteID: Int?

    /// Boolean tells whether the retailer store is available or not
    /// - Since: 1905.0.0
    public var retailStoreAvailableFlag: Bool?

    enum CodingKeys: String, CodingKey {
        case storeLocatorURL = "storeLocatorUrl"
        case eloquaSiteURL = "EloquaSiteURL"
        case showBuyButton = "ShowBuyButton"
        case texts = "Texts"
        case ctn = "Ctn"
        case onlineStoresForProduct = "OnlineStoresForProduct"
        case eloquaSiteID = "EloquaSiteId"
        case retailStoreAvailableFlag = "RetailStoreAvailableFlag"
    }
}

// MARK: - ECSOnlineStoresForProduct
@objcMembers public class ECSOnlineStoresForProduct: NSObject, Codable {

    public var excludePhilipsShopInWTB: String?
    public var ctn: String?
    public var showPrice: String?

    /// This represent the Retailer store
    /// - Since: 1905.0.0
    public var retailers: ECSRetailers?

    enum CodingKeys: String, CodingKey {
        case excludePhilipsShopInWTB, showPrice, ctn
        case retailers = "Stores"
    }
}

// MARK: - ECSRetailers
@objcMembers public class ECSRetailers: NSObject, Codable {
    public var retailer: [ECSRetailer]?

    enum CodingKeys: String, CodingKey {
        case retailer = "Store"
    }
}

// MARK: - ECSRetailer
@objcMembers public class ECSRetailer: NSObject, Codable {
    /// Name of the store
    /// - Since: 1905.0.0
    public var name: String?

    /// Online price of the product in retailer store
    /// - Since: 1905.0.0
    public var philipsOnlinePrice: String?

    /// Tells whether its Philips store or not
    /// - Since: 1905.0.0
    public var isPhilipsStore: String?

    /// Tells the availibility of the product
    /// - Since: 1905.0.0
    public var availability: String?

    /// Type of the retailer store
    /// - Since: 1905.0.0
    public var storeType: String?

    ///
    /// - Since: 1905.0.0
    public var logoHeight, logoWidth: Int?
    public var xactparam: String?

    /// Buy url of the store
    /// - Since: 1905.0.0
    public var buyURL: String?

    /// Logo URL of the store
    /// - Since: 1905.0.0
    public var logoURL: String?
}

// MARK: - ECSTexts
@objcMembers public class ECSTexts: NSObject, Codable {

    public var text: [ECSText]?

    enum CodingKeys: String, CodingKey {
        case text = "Text"
    }
}

// MARK: - ECSText
@objcMembers public class ECSText: NSObject, Codable {

    public var key, value: String?

    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case value = "Value"
    }
}
