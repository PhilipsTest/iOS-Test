/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPPaymentInfo {
    fileprivate var accountHolderName: String!
    fileprivate var cardNumber: String!
    fileprivate var cardType: String!
    fileprivate var expiryMonth: String!
    fileprivate var expiryYear: String!
    fileprivate var paymentId: String!
    fileprivate var lastSuccessfulOrderDate: String!
    internal  var defaultPayment: Bool!
    fileprivate var billingAddress: IAPUserAddress!

    init (inDict: [String: AnyObject]) {
        self.accountHolderName = inDict[IAPConstants.IAPPaymentInfoKeys.kAccountHolderNamekey] as? String ?? ""
        self.cardNumber = inDict[IAPConstants.IAPPaymentInfoKeys.kCardNumberKey] as? String ?? ""
        self.expiryMonth = inDict[IAPConstants.IAPPaymentInfoKeys.kExpiryMonthKey] as? String ?? ""
        self.expiryYear = inDict[IAPConstants.IAPPaymentInfoKeys.kExpiryYearKey] as? String ?? ""
        self.paymentId = inDict[IAPConstants.IAPPaymentInfoKeys.kPaymentIdKey] as? String ?? ""
        self.lastSuccessfulOrderDate = inDict[IAPConstants.IAPPaymentInfoKeys.kLastSuccessfulOrderDateKey] as? String ?? ""
        self.defaultPayment = inDict[IAPConstants.IAPPaymentInfoKeys.kDefaultPaymentKey] as? Bool ?? false
        if let addressData = inDict[IAPConstants.IAPPaymentInfoKeys.KBillingAddressKey] as? [String: AnyObject] {
            self.billingAddress = IAPUserAddress(inDict: addressData)
        }
        if let cardTypeDict = inDict[IAPConstants.IAPPaymentInfoKeys.kCardTypeKey] as? [String: AnyObject] {
            self.cardType = cardTypeDict[IAPConstants.IAPPaymentInfoKeys.kCardTypeCodeKey] as? String ?? ""
        }
    }
    
    func getAccountHolderName() -> String {
        return self.accountHolderName
    }
    
    func getCardnumber() -> String {
        return self.cardNumber
    }
    
    func getCardType() -> String {
        return self.cardType
    }
    
    func getExpiryMonth() -> String {
        return self.expiryMonth
    }
    
    func getExpiryYear() -> String {
        return self.expiryYear
    }
    
    func getPaymentId() -> String {
        return self.paymentId
    }
    
    func getLastSuccessfulOrderDate() -> String {
        return self.lastSuccessfulOrderDate
    }
    
    func getDefaultPayment() -> Bool {
        return self.defaultPayment
    }
    
    func getBillingAddress() -> IAPUserAddress {
        return self.billingAddress
    }
    
}

class IAPPaymentDetailsInfo {
    var arrayOfPaymentDetails: [IAPPaymentInfo] = [IAPPaymentInfo]()
    init(inDict: [String: AnyObject]) {
        if let paymentDictionaries = inDict[IAPConstants.IAPPaymentInfoKeys.kPaymentDetailskey] as? [[String: AnyObject]] {
            arrayOfPaymentDetails = paymentDictionaries.map({IAPPaymentInfo(inDict: $0)})
            self.setDefaultPaymentValue()
        }
    }

    func setDefaultPaymentValue() {
        if let firstPaymentObject = self.arrayOfPaymentDetails.first {
            firstPaymentObject.defaultPayment = true
        }
    }
}
