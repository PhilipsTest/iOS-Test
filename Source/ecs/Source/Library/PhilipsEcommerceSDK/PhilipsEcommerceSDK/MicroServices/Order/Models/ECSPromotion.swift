/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSOrderPromotion
@objcMembers public class ECSOrderPromotion: NSObject, Codable {
    public var appliedOrderPromotionDescription: String?
    public var promotion: ECSPromotion?

    enum CodingKeys: String, CodingKey {
        case appliedOrderPromotionDescription = "description"
        case promotion
    }
}

// MARK: - ECSPromotion
@objcMembers public class ECSPromotion: NSObject, Codable {
    public var promotionCode: String?
    public var promotionDescription: String?
    public var enabled: Bool?
    public var endDate: String?
    public var itemType: String?
    public var promotionDiscount: ECSPrice?
    public var firedMessages: [String]?
    public var percentageDiscount: Int?
    public var name: String?

    enum CodingKeys: String, CodingKey {
        case promotionCode = "code"
        case promotionDescription = "description"
        case enabled, endDate, itemType, promotionDiscount, firedMessages, percentageDiscount, name
    }
}

// MARK: - ECSConsumedEntry
@objcMembers public class ECSConsumedEntry: NSObject, Codable {
    public var adjustedUnitPrice: Double?
    public var orderEntryNumber: Int?
    public var quantity: Int?
}
