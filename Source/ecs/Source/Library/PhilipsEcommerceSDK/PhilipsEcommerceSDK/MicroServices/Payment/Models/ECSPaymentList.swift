/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSPaymentList
@objcMembers class ECSPaymentList: NSObject, Codable {
    var payments: [ECSPayment]?
}

// MARK: - ECSPayment
@objcMembers public class ECSPayment: NSObject, Codable {

    /// Name of the Card holder
    /// - Since: 1905.0.0
    public var accountHolderName: String?

    /// Billing address associated with saved Card
    /// - Since: 1905.0.0
    public var billingAddress: ECSAddress?

    ///Card number
    /// - Since: 1905.0.0
    public var cardNumber: String?

    /// Type of the card
    /// - Since: 1905.0.0
    public var card: ECSCardType?

    /// Boolean which tells whether the payment is default or not
    /// - Since: 1905.0.0
    public var defaultPayment: Bool?

    /// Expiry month of the Card
    /// - Since: 1905.0.0
    public var expiryMonth: String?

    /// Expiry year of the card
    /// - Since: 1905.0.0
    public var expiryYear: String?

    /// Unique Id of the saved payment
    /// - Since: 1905.0.0
    public var paymentId: String?

    /// Last order date by using this card
    /// - Since: 1905.0.0
    public var lastSuccessfulOrderDate: String?

    /// Boolean tells whether the card is saved or not
    /// - Since: 1905.0.0
    public var saved: Bool?

    /// Subscription id
    /// - Since: 1905.0.0
    public var subscriptionID: String?

    enum CodingKeys: String, CodingKey {
        case accountHolderName, billingAddress, cardNumber
        case defaultPayment, expiryMonth
        case expiryYear, lastSuccessfulOrderDate, saved
        case subscriptionID = "subscriptionId"
        case paymentId = "id"
        case card = "cardType"
    }
}

// MARK: - ECSCardType
@objcMembers public class ECSCardType: NSObject, Codable {

    public var type: String?

    public var name: String?

    enum CodingKeys: String, CodingKey {
        case name
        case type = "code"
    }
}
