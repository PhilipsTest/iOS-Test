/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSProductPromotion
@objcMembers public class ECSProductPromotion: NSObject, Codable {

    /// product of the promotion
    /// - Since: 1905.0.0
    public var baseProduct: String?

    /// Description of the promotion
    /// - Since: 1905.0.0
    public var promotionDescription: String?

    /// Boolean tells whether the promotion is enabled or not
    /// - Since: 1905.0.0
    public var enabled: Bool?

    /// Promotion end date
    /// - Since: 1905.0.0
    public var endDate: String?

    /// Promotional discount price
    /// - Since: 1905.0.0
    public var promotionDiscount: ECSPrice?

    /// Promotional price
    /// - Since: 1905.0.0
    public var promotionPrice: ECSPrice?

    public var itemType: String?
    public var partnerProducts: [String]?
    public var code: String?

    enum CodingKeys: String, CodingKey {
        case baseProduct, code
        case promotionDescription = "description"
        case enabled, endDate, itemType, partnerProducts, promotionDiscount, promotionPrice
    }
}
