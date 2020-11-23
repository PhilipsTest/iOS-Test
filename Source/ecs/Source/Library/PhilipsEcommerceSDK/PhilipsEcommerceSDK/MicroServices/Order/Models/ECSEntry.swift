/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSCurrency
@objcMembers public class ECSCurrency: NSObject, Codable {
    public var active: Bool?

    /// ISO code of currency
    /// - Since: 1905.0.0
    public var isocode: String?

    /// Symbol of currency
    /// - Since: 1905.0.0
    public var symbol: String?
}

// MARK: - ECSDeliveryOrderGroup
@objcMembers class ECSDeliveryOrderGroup: NSObject, Codable {
    var entries: [ECSEntry]?
    var totalPriceWithTax: ECSPrice?
}

// MARK: - ECSEntry
@objcMembers public class ECSEntry: NSObject, Codable {
    public var basePrice: ECSPrice?
    public var entryNumber: Int?
    public var product: ECSProduct?
    public var quantity: Int?
    public var totalPrice: ECSPrice?
    public var updateable: Bool?
    public var vertexTaxAmount: ECSPrice?
    public var vertexTaxPercent: Int?
}
