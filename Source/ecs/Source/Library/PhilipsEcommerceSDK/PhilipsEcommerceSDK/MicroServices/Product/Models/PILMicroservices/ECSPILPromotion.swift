/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSPILProductPromotion
@objcMembers public class ECSPILProductPromotion: NSObject, Codable {
    public var consumedItems: [ECSPILConsumedItem]?
    public var promotionCode: String?
    public var endDate: String?
    public var promotionPrice, promotionDiscount: ECSPILPrice?
    public var type: String?
    public var percentageDiscount: Int?

    enum CodingKeys: String, CodingKey {
        case promotionCode = "id"
        case endDate, promotionPrice, promotionDiscount, consumedItems
        case type, percentageDiscount
    }
}

// MARK: - ECSPILConsumedItem
@objcMembers public class ECSPILConsumedItem: NSObject, Codable {
    public var adjustedUnitPrice: ECSPILPrice?
    public var itemCartOrder, quantity: Int?
}

// MARK: - ECSPILOrderPromotion
@objcMembers public class ECSPILOrderPromotion: NSObject, Codable {
    public var promotionCode, type, enabled: String?
    public var endDate: String?
    public var message: String?
    public var promotionDiscount: ECSPILOrderPromotionDiscountPrice?

    enum CodingKeys: String, CodingKey {
        case promotionCode = "code"
        case type, enabled
        case endDate, message, promotionDiscount
    }
}
