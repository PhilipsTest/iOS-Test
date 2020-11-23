/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSDeliveryModes
@objcMembers class ECSDeliveryModes: NSObject, Codable {
    var deliveryModes: [ECSDeliveryMode]?
}

// MARK: - ECSDeliveryMode
@objcMembers public class ECSDeliveryMode: NSObject, Codable {

    /// Unique id of the delivery mode
    /// - Since: 1905.0.0
    public var deliveryModeId: String?

    /// Delivery cost of this delivery mode
    /// - Since: 1905.0.0
    public var deliveryCost: ECSPrice?

    /// Description of delivery mode
    /// - Since: 1905.0.0
    public var deliveryModeDescription: String?

    /// Name of delivery mode
    /// - Since: 1905.0.0
    public var deliveryModeName: String?

    /// Boolean suggesting whether delivery mode is of type pickup or not.
    /// If pickup point is true, it indicates that order can be collected at different collection points like UPS, DHL etc
    ///- Note: If this Boolean is true, then parameters such as house number, last name, etc
    /// will be removed from the Delivery Address and the Shipment should be picked up from the
    /// collection point.
    /// - Since: 2003.0.0
    public var pickupPoint: Bool?

    enum CodingKeys: String, CodingKey {
        case deliveryModeId = "code"
        case deliveryCost, pickupPoint
        case deliveryModeDescription = "description"
        case deliveryModeName = "name"
    }
}

extension ECSDeliveryModes {

    func fetchNonPickupDeliveryModes() -> [ECSDeliveryMode]? {
        return deliveryModes?.filter({ $0.pickupPoint ?? false == false })
    }
}
