/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSPILPrice
@objcMembers public class ECSPILPrice: NSObject, Codable {
    public var currency: String?
    public var formattedValue: String?
    public var value: Double?
}

// MARK: - ECSPILOrderPromotionDiscountPrice
@objcMembers public class ECSPILOrderPromotionDiscountPrice: NSObject, Codable {
    public var currencyISO, formattedValue, priceType: String?
    public var value: Double?

    enum CodingKeys: String, CodingKey {
        case currencyISO = "currencyIso"
        case formattedValue, priceType, value
    }
}
