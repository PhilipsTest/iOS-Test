/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSPILShoppingCart
@objcMembers public class ECSPILShoppingCart: NSObject, Codable {
    public var data: ECSPILDataClass?
}

// MARK: - ECSPILDataClass
@objcMembers public class ECSPILDataClass: NSObject, Codable {
    public var cartID, type: String?
    public var attributes: ECSPILCartAttributes?

    enum CodingKeys: String, CodingKey {
        case cartID = "id"
        case type, attributes
    }
}

// MARK: - ECSPILCartAttributes
@objcMembers public class ECSPILCartAttributes: NSObject, Codable {
    public var email: String?
    public var pricing: ECSPILPricing?
    public var promotions: ECSPILShoppingCartPromotions?
    public var ageConsent, ageConsentApplied, marketingOptinApplied: Bool?
    public var units, deliveryUnits: Int?
    public var items: [ECSPILItem]?
    public var deliveryMode: ECSPILDeliveryMode?
    public var applicableDeliveryModes: [ECSPILDeliveryMode]?
    public var appliedVouchers: [ECSPILAppliedVoucher]?
    public var deliveryAddress: ECSPILAddress?
    public var notifications: [ECSPILNotification]?
}

// MARK: - ECSPILDeliveryMode
@objcMembers public class ECSPILDeliveryMode: NSObject, Codable {
    public var deliveryModeId: String?
    public var deliveryCost: ECSPILPrice?
    public var deliveryModeDescription, deliveryModeName: String?
    public var isCollectionPoint: Bool?

    enum CodingKeys: String, CodingKey {
        case deliveryModeId = "id"
        case deliveryModeName = "label"
        case deliveryCost
        case deliveryModeDescription = "description"
        case isCollectionPoint
    }
}

// MARK: - ECSPILAppliedVoucher
@objcMembers public class ECSPILAppliedVoucher: NSObject, Codable {
    public var voucherCode: String?
    public var name: String?
    public var voucherDescription: String?
    public var freeShipping: Bool?
    public var voucherDiscount, value: ECSPILPrice?

    enum CodingKeys: String, CodingKey {
        case voucherCode = "id"
        case voucherDescription = "description"
        case freeShipping, value, name, voucherDiscount
    }
}

// MARK: - ECSPILAddress
@objcMembers public class ECSPILAddress: NSObject, Codable {
    public var billingAddress: Bool?
    public var country: ECSPILCountry?
    public var defaultAddress: Bool?
    public var firstName, houseNumber, addressId, lastName: String?
    public var line1, line2, phone, postalCode: String?
    public var region: ECSPILRegion?
    public var deliveryAddress: Bool?
    public var titleCode, town: String?
    public var isCollectionPoint: Bool?

    enum CodingKeys: String, CodingKey {
        case addressId = "id"
        case billingAddress, country, defaultAddress
        case firstName, houseNumber, lastName
        case line1, line2, phone, postalCode
        case region, deliveryAddress, titleCode, town, isCollectionPoint
    }
}

// MARK: - ECSPILCountry
@objcMembers public class ECSPILCountry: NSObject, Codable {
    public var isocode, name: String?
}

// MARK: - ECSPILRegion
@objcMembers public class ECSPILRegion: NSObject, Codable {
    public var isocode, isocodeShort, name: String?
}

// MARK: - ECSPILItem
@objcMembers public class ECSPILItem: NSObject, Codable {
    public var entryNumber, ctn, title: String?
    public var image: String?
    public var quantity: Int?
    public var availability: ECSPILProductAvailability?
    public var price, discountPrice, totalPrice: ECSPILPrice?

    enum CodingKeys: String, CodingKey {
        case entryNumber = "id"
        case ctn = "itemId"
        case title, image, quantity, availability
        case price, discountPrice, totalPrice
    }
}

// MARK: - ECSPILNotification
@objcMembers public class ECSPILNotification: NSObject, Codable {
    public var notificationId, notificationMessage: String?
    public var orderBlocking: Bool?

    enum CodingKeys: String, CodingKey {
        case notificationId = "id"
        case notificationMessage = "message"
        case orderBlocking
    }
}
// MARK: - ECSPILPricing
@objcMembers public class ECSPILPricing: NSObject, Codable {
    public var net: Bool?
    public var total, subTotal, tax, orderDiscount: ECSPILPrice?
    public var itemDiscount, delivery, totalDelivery, orderDiscountNoDelivery: ECSPILPrice?
    public var totalDiscountNoDelivery, totalNoDelivery, totalDiscount: ECSPILPrice?
}

// MARK: - ECSPILShoppingCartPromotions
@objcMembers public class ECSPILShoppingCartPromotions: NSObject, Codable {
    public var potentialOrderPromotions: [ECSPILOrderPromotion]?
    public var appliedOrderPromotions: [ECSPILOrderPromotion]?
    public var potentialProductPromotions: [ECSPILProductPromotion]?
    public var appliedProductPromotions: [ECSPILProductPromotion]?

    enum CodingKeys: String, CodingKey {
        case potentialOrderPromotions = "potentialPromotions"
        case appliedOrderPromotions = "appliedPromotions"
        case potentialProductPromotions, appliedProductPromotions
    }
}
