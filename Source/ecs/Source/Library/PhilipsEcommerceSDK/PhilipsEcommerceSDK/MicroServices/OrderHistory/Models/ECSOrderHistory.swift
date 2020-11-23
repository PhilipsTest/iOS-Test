/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSOrderHistory
@objcMembers public class ECSOrderHistory: NSObject, Codable {
    public var orders: [ECSOrder]?
    public var pagination: ECSPagination?
    public var sorts: [ECSSort]?
}

// MARK: - ECSOrder
/**
   ECSOrder gives brief information about the order history
  - Since: 1905.0.0
 */
@objcMembers public class ECSOrder: NSObject, Codable {

    /// Unique id of order
    /// - Since: 1905.0.0
    public var orderID: String?

    /// GUID of the order
    /// - Since: 1905.0.0
    public var guid: String?

    /// String which tells the order placed date
    /// - Since: 1905.0.0
    public var placedDateString: String?

    /// String tells the status of the order
    /// - Since: 1905.0.0
    public var status: String?

    /// Display texts of the order status
    /// - Since: 1905.0.0
    public var statusDisplay: String?

    /// ECSPrice which tells the total price of the order
    /// - Since: 1905.0.0
    public var total: ECSPrice?

    /// An object of ECSOrderDetail which represent the complete details of the order
    /// - Since: 1905.0.0
    public var orderDetails: ECSOrderDetail?

    enum CodingKeys: String, CodingKey {
        case orderID = "code"
        case placedDateString = "placed"
        case guid, status, statusDisplay, total
    }
}

// MARK: - ECSSort
@objcMembers public class ECSSort: NSObject, Codable {
    public var code: String?
    public var selected: Bool?
}
