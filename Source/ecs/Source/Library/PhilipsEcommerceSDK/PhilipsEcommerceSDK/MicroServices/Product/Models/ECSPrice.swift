/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSPrice

/// This class provides the details of the price including value, currency ISO code, type of price and fomatted string
@objcMembers public class ECSPrice: NSObject, Codable {

    /// ISO code of the currency
    /// - Since: 1905.0.0
    public var currencyISO: String?

    /// Formatted string of the price including currency code
    /// - Since: 1905.0.0
    public var formattedValue: String?

    /// Type of the price
    /// - Since: 1905.0.0
    public var priceType: String?

    /// Actual price value
    /// - Since: 1905.0.0
    public var value: Double?

    enum CodingKeys: String, CodingKey {
        case currencyISO = "currencyIso"
        case formattedValue, priceType, value
    }
}
