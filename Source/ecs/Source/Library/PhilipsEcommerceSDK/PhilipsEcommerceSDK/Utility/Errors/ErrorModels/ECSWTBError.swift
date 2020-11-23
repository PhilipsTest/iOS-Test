/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSWTBError
@objcMembers class ECSWTBError: NSObject, Codable {
    var success: Bool?
    var failureReason: String?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case success, failureReason, message
    }
}
