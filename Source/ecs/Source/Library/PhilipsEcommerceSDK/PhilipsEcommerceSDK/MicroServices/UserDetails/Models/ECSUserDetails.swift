/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSUserDetails

@objcMembers public class ECSUserProfile: NSObject, Codable {
    public var type: String?

    /// Janrain UUID
    /// - Since: 1905.0.0
    public var janrainUUID: String?

    /// Full name of the logged in user
    /// - Since: 1905.0.0
    public var fullName: String?

    /// UID of the user
    /// - Since: 1905.0.0
    public var uid: String?

    /// UID display string
    /// - Since: 1905.0.0
    public var displayUid: String?

    /// An object of type ECSCurrency which is type of currency user is using
    /// - Since: 1905.0.0
    public var currency: ECSCurrency?

    /// An object of type ECSAddress which is default selected address
    /// - Since: 1905.0.0
    public var defaultAddress: ECSAddress?

    /// An object of type ECSLanguage which is the language of the user
    /// - Since: 1905.0.0
    public var language: ECSLanguage?

    /// First name of the user
    /// - Since: 1905.0.0
    public var firstName: String?

    /// Last name of the user
    /// - Since: 1905.0.0
    public var lastName: String?

    enum CodingKeys: String, CodingKey {
        case type, janrainUUID, uid
        case currency, defaultAddress, displayUid, language, lastName, firstName
        case fullName = "name"
    }
}

// MARK: - ECSLanguage
@objcMembers public class ECSLanguage: NSObject, Codable {
    public var active: Bool?
    public var isocode, nativeName: String?
}
