/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSConfig
@objcMembers public class ECSConfig: NSObject, Codable {

    /// Catalog id of the proposition
    /// - Since: 1905.0.0
    public var catalogID: String?

    /// help desk email id
    /// - Since: 1905.0.0
    public var helpDeskEmail: String?

    /// Help desk phone number
    /// - Since: 1905.0.0
    public var helpDeskPhone: String?

    /// Help URL
    /// - Since: 1905.0.0
    public var helpURL: String?

    /// Faq URL
    /// - Since: 1905.0.0
    public var faqURL: String?

    public var net: Bool?

    /// Root category of the proposition
    /// - Since: 1905.0.0
    public var rootCategory: String?

    /// Site id of the which is configured for the proposition
    /// - Since: 1905.0.0
    public var siteID: String?

    /// device location code
    /// - Since: 1905.0.0
    public var locale: String?

    /// Whether Hybris is Available for the selected Locale
    /// - Since: 2003.0.0
    public var isHybrisAvailable: Bool? = false

    enum CodingKeys: String, CodingKey {
        case catalogID = "catalogId"
        case faqURL = "faqUrl"
        case helpDeskEmail, helpDeskPhone, locale, isHybrisAvailable
        case helpURL = "helpUrl"
        case net, rootCategory
        case siteID = "siteId"
    }
}
