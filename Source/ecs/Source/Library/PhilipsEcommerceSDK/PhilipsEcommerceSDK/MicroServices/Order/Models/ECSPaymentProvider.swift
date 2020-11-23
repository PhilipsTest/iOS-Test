/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

@objcMembers public class ECSPaymentProvider: NSObject, Codable {

    public var paymentProviderURL: String?

    enum CodingKeys: String, CodingKey {
        case paymentProviderURL = "paymentProviderUrl"
    }
}
