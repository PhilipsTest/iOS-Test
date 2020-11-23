/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSOAuthData
@objcMembers public class ECSOAuthData: NSObject, Codable {

    /// Access token of the hybris
    /// - Since: 1905.0.0
    public var accessToken: String?

    /// Token which is used to refresh the access token
    /// - Since: 1905.0.0
    public var refreshToken: String?

    /// Type of the token
    /// - Since: 1905.0.0
    public var tokenType: String?

    /// An integer represent the expiry time of access token
    /// - Since: 1905.0.0
    public var expiresIn: Int?

    /// Scope of the OAuth
    /// - Since: 1905.0.0
    public var scope: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case scope
    }
}
