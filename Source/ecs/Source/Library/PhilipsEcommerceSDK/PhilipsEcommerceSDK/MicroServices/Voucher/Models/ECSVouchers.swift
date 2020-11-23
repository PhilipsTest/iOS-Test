/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSVoucherList
@objcMembers class ECSVoucherList: NSObject, Codable {
    public var vouchers: [ECSVoucher]?
}

// MARK: - ECSVoucher

/// This class tells the information about the voucher
@objcMembers public class ECSVoucher: NSObject, Codable {
    public var appliedValue: ECSPrice?
    public var promotionCode: String?
    public var currency: ECSCurrency?
    public var appliedVoucherDescription: String?
    public var freeShipping: Bool?
    public var name: String?
    public var value: Int?
    public var valueFormatted: String?
    public var valueString: String?
    public var voucherCode: String?

    enum CodingKeys: String, CodingKey {
        case promotionCode = "code"
        case appliedValue, currency
        case appliedVoucherDescription = "description"
        case freeShipping, name, value, valueFormatted, valueString, voucherCode
    }
}
