/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

// MARK: - ECSOrderDetail
import Foundation

@objcMembers public class ECSOrderDetail: NSObject, Codable {
    public var type: String?
    public var appliedOrderPromotions: [ECSOrderPromotion]?
    public var appliedProductPromotions: [ECSProductPromotion]?
    public var appliedVouchers: [ECSVoucher]?
    public var calculated: Bool?

    /// Unique id of the placed order
    /// - Since: 1905.0.0
    public var orderID: String?

    /// Address to which the order has to be delivered
    /// - Since: 1905.0.0
    public var deliveryAddress: ECSAddress?

    /// Shipping cost of the order
    /// - Since: 1905.0.0
    public var deliveryCost: ECSPrice?

    /// quantity of the item which has to be delivered
    /// - Since: 1905.0.0
    public var deliveryItemsQuantity: Int?

    /// Delivery mode selected for the order
    /// - Since: 1905.0.0
    public var deliveryMode: ECSDeliveryMode?
    var deliveryOrderGroups: [ECSDeliveryOrderGroup]?
    public var entries: [ECSEntry]?

    /// Payment infomation used for the order
    /// - Since: 1905.0.0
    public var paymentInfo: ECSPayment?
    public var guid: String?
    public var net: Bool?

    /// Total discount on the order
    /// - Since: 1905.0.0
    public var orderDiscounts: ECSPrice?

    /// Total discount on products
    /// - Since: 1905.0.0
    public var productDiscounts: ECSPrice?
    public var pickupItemsQuantity: Int?
    public var site: String?
    public var store: String?
    public var subTotal: ECSPrice?

    /// Total discount
    /// - Since: 1905.0.0
    public var totalDiscounts: ECSPrice?

    /// Total items in order
    /// - Since: 1905.0.0
    public var totalItems: Int?

    /// Total price of the order
    /// - Since: 1905.0.0
    public var totalPrice: ECSPrice?

    /// Total price of the order which include TAX
    /// - Since: 1905.0.0
    public var totalPriceWithTax: ECSPrice?

    /// Total tax of the order
    /// - Since: 1905.0.0
    public var totalTax: ECSPrice?

    /// User detail
    /// - Since: 1905.0.0
    public var user: ECSUser?

    /// Order creation date in string format
    /// - Since: 1905.0.0
    public var created: String?

    /// Delivery status of the order
    /// - Since: 1905.0.0
    public var deliveryStatus: String?

    public var guestCustomer: Bool?

    /// Status of the order
    /// - Since: 1905.0.0
    public var status: String?

    /// Display text of status of the order
    /// - Since: 1905.0.0
    public var statusDisplay: String?
    public var consignments: [ECSConsignment]?
    public var unconsignedEntries: [ECSEntry]?

    enum CodingKeys: String, CodingKey {
        case type, appliedOrderPromotions, appliedProductPromotions, appliedVouchers, calculated
        case orderID = "code"
        case deliveryAddress, deliveryCost, deliveryItemsQuantity, deliveryMode, deliveryOrderGroups
        case entries, paymentInfo, guid, net, orderDiscounts, pickupItemsQuantity, productDiscounts
        case site, store, subTotal, totalDiscounts, totalItems, totalPrice, totalPriceWithTax, totalTax
        case user, consignments, created, deliveryStatus, guestCustomer, status, statusDisplay, unconsignedEntries
    }
}

// MARK: - ECSUser
@objcMembers public class ECSUser: NSObject, Codable {
    public var janrainUUID, name, uid: String?
}

// MARK: - ECSConsignment
@objcMembers public class ECSConsignment: NSObject, Codable {
    public var code: String?
    public var entries: [ECSConsignmentEntry]?
    public var shippingAddress: ECSAddress?
    public var status: String?
    public var statusDate: String?
}

// MARK: - ECSConsignmentEntry
@objcMembers public class ECSConsignmentEntry: NSObject, Codable {
    public var orderEntry: ECSEntry?
    public var quantity, shippedQuantity: Int?
    public var trackAndTraceIDs, trackAndTraceUrls: [String]?
}
