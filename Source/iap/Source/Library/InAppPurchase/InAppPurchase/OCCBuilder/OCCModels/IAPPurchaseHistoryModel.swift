/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPPurchaseHistoryModel: Equatable {
    fileprivate var orderID: String!
    fileprivate var orderPlacedDate: String!
    fileprivate var orderPlacedDateValue: Date!
    fileprivate var orderStatus: String?
    fileprivate var orderDisplayStatus: String!
    fileprivate var orderPriceValue: String!
    var orderDisplayDate: String!
    
    var products = [IAPProductModel]()
    fileprivate var itemsCount: Int = 1
    fileprivate var deliveryAddress: IAPUserAddress!
    fileprivate var billingAddress: IAPUserAddress!
    fileprivate var cardType: String! = ""
    fileprivate var cardNumber: String! = ""
    fileprivate var deliveryCost: String! = ""
    fileprivate var deliveryCostName: String! = ""
    fileprivate var orderTrackURL: String! = ""
    fileprivate var deliveryStatus: String! = ""
    fileprivate var trackingId: String! = ""
    fileprivate var totalTax: String! = ""
    
    init? (inDictionary: [String: AnyObject]) {
        guard let orderId = inDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderCode] as? String,
              let orderDate = inDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderPlacedDate] as? String,
              let orderstatus = inDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kPurchaseStatusDisplay] as? String,
        let totalDict = inDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderTotal] as? [String: AnyObject],
              let priceValue = totalDict[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderFormattedTotal] as? String else {
                return nil
        }
        
        self.orderID = orderId
        self.orderDisplayStatus = orderstatus
        self.orderPriceValue = priceValue
        self.orderPlacedDate = orderDate
        self.orderDisplayDate = self.provideDisplayDate()
        self.orderPlacedDateValue = self.provideDateFromDisplayDate()
        self.orderStatus = inDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kPurchaseStatus] as? String
    }

    func getOrderID()-> String {
        return self.orderID
    }
    
    func getOrderPlacedDate()-> String {
        return self.orderPlacedDate
    }
    
    func getOrderPlacedDateValue()-> Date {
        return self.orderPlacedDateValue
    }

    func getOrderStatus() -> String? {
        return self.orderStatus
    }

    func getOrderDisplayStatus()-> String {
        return self.orderDisplayStatus
    }

    func getOrderPriceValue()-> String {
        return self.orderPriceValue
    }

    // MARK: Order detail getters
    func getDeliveryAddress()-> IAPUserAddress? {
        return self.deliveryAddress
    }
    
    func getBillingAddress() -> IAPUserAddress? {
        return self.billingAddress
    }
    
    func getCardType() -> String {
        return self.cardType
    }
    
    func getCardNumber() -> String {
        return self.cardNumber
    }
    
    func getOrderTrackURL() -> String {
        return self.orderTrackURL
    }
    
    func getDeliveryStatus()-> String {
        return self.deliveryStatus
    }
    
    func getDeliveryCost()-> String {
        return self.deliveryCost
    }
    
    func getDeliveryCostName() -> String {
        return self.deliveryCostName
    }
    
    func getItemsCount() -> Int {
        return self.itemsCount
    }
    
    func getOrderTrackingId() -> String{
        return self.trackingId
    }
    
    func getTotalTax() -> String {
        return self.totalTax
    }
}

func ==(lhs: IAPPurchaseHistoryModel, rhs: IAPPurchaseHistoryModel) -> Bool {
    return lhs.getOrderID()==rhs.getOrderID()
}

extension IAPPurchaseHistoryModel {
    
    func provideDisplayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = IAPConstants.IAPPurchaseHistoryModelKeys.kServerDateFormat
        
        let orderPlacedDisplayDate = dateFormatter.date(from: self.orderPlacedDate)
        dateFormatter.dateFormat = IAPConstants.IAPPurchaseHistoryModelKeys.kOrderDateFormat
        let displayDate = dateFormatter.string(from: orderPlacedDisplayDate!)
        
        return displayDate.replaceCharacter("-", withCharacter: "/")
    }
    
    func provideDateFromDisplayDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = IAPConstants.IAPPurchaseHistoryModelKeys.kServerDateFormat
        
        let orderPlacedDisplayDate = dateFormatter.date(from: self.orderPlacedDate)!
        return orderPlacedDisplayDate
    }
    
    func initialiseOrderDetails(_ orderDetailDictionary: [String: AnyObject]) {
        if let paymentDict = orderDetailDictionary[
            IAPConstants.IAPPurchaseHistoryModelKeys.kOrderPaymentInfoKey] as? [String: AnyObject] {
            if let billingAddressDict = paymentDict[
                IAPConstants.IAPPurchaseHistoryModelKeys.kOrderBillingAddressKey] as? [String: AnyObject] {
                self.billingAddress = IAPUserAddress(inDict: billingAddressDict)
            }
            self.cardNumber = paymentDict[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderCardNumberKey] as? String ?? ""
            if let cardTypeDict = paymentDict[
                IAPConstants.IAPPurchaseHistoryModelKeys.kOrderCardTypeKey] as? [String: AnyObject] {
                self.cardType = cardTypeDict[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderCardCodeKey] as? String ?? ""
            }
        }
        if let shippingAddressDict = orderDetailDictionary[
            IAPConstants.IAPPurchaseHistoryModelKeys.kOrderDeliveryAddressKey] as? [String: AnyObject] {
            self.deliveryAddress = IAPUserAddress(inDict: shippingAddressDict)
        }
        self.itemsCount = orderDetailDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderProductQuantityKey] as? Int ?? 0
        self.deliveryStatus = orderDetailDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderDeliveryStatusKey] as? String ?? ""
        self.orderTrackURL = orderDetailDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderTrackingURLKey] as? String ?? ""
        if let deliveryModeDict = orderDetailDictionary[
            IAPConstants.IAPPurchaseHistoryModelKeys.kDeliveryModeKey] as? [String: AnyObject] {
            self.deliveryCostName = deliveryModeDict[IAPConstants.IAPDeliveryModeKeys.kNameKey] as? String ?? ""
            if let deliveryCostDict = deliveryModeDict[IAPConstants.IAPPurchaseHistoryModelKeys.kDeliveryCostKey] as? [String: AnyObject] {
                self.deliveryCost = deliveryCostDict[IAPConstants.IAPPurchaseHistoryModelKeys.kDeliveryCostFormattedKey] as? String ?? ""
            }
        }
        if let taxOrderDict = orderDetailDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderTaxKey] as? [String: AnyObject] {
            self.totalTax = taxOrderDict[IAPConstants.IAPPurchaseHistoryModelKeys.kFormmatedValueKey] as? String ?? ""
        }

        if let consignments = orderDetailDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.consignments] as? [[String: AnyObject]] {
            self.trackingId = consignments.first?[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderTrackingId] as? String ?? ""
        }
        createProducts(orderDetailDictionary: orderDetailDictionary)
    }

    private func updateOrderTrackingDetails(entryList: [[String: AnyObject]], productObject: IAPProductModel) {
        let fileteredProduct = entryList.filter{
            guard let orderEntry = $0[IAPConstants.IAPPurchaseHistoryModelKeys.orderEntry] as? [String: Any] else { return false }
            guard let product = orderEntry[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderProductKey] as? [String: Any] else { return false }
            guard let ctn = product[IAPConstants.IAPShoppingCartKeys.kCtnCodeKey] as? String else { return false }
            return ctn == productObject.getProductCTN()
        }
        guard fileteredProduct.count > 0 else {
            return
        }
        guard let productTrackingURLs = fileteredProduct.first?[IAPConstants.IAPPurchaseHistoryModelKeys.trackingUrls] as? [String],
            let productTrackingIds = fileteredProduct.first?[IAPConstants.IAPPurchaseHistoryModelKeys.trackingIds] as? [String] else {
            return
        }

        let url = formatTrackingURL(trackingURL: productTrackingURLs.first, trackingID: productTrackingIds.first)
        productObject.setProductTrackingURL(inTrackingURL:url)
    }
    
    private func formatTrackingURL(trackingURL: String?, trackingID: String?) -> String {
        if let _trackingURL = trackingURL, let _trackingID = trackingID {
            let temp = _trackingURL.replaceCharacter("{\(_trackingID)=", withCharacter: "")
            return temp.replaceCharacter("}", withCharacter: "")
        }
        return ""
    }
    
    func createProducts(orderDetailDictionary: [String: AnyObject]) {
        if let entriesDict = orderDetailDictionary[
            IAPConstants.IAPPurchaseHistoryModelKeys.kOrderDetailProductEntriesKey] as? [[String: AnyObject]] {
            self.products = entriesDict.map ({
                var productModel = IAPProductModel()
                if let productInfoDict =
                    $0[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderProductKey] as? [String: AnyObject] {
                    productModel = IAPProductModel(inDict: productInfoDict)
                }
                if let productQuantity = $0[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderPRoductQuantityKey] as? Int {
                    productModel.setQuantity(productQuantity)
                }
                if let productPriceDict = $0[IAPConstants.IAPShoppingCartKeys.kTotalPriceKey] as? [String: AnyObject] {
                    if let productPrice = productPriceDict[
                        IAPConstants.IAPPurchaseHistoryModelKeys.kOrderFormattedTotal] as? String {
                        productModel.setTotalPrice(productPrice)
                    }
                }
                if let consentmentList = orderDetailDictionary[IAPConstants.IAPPurchaseHistoryModelKeys.consignments] as? [[String: Any]],
                    let entries = consentmentList.first?[IAPConstants.IAPPurchaseHistoryModelKeys.kOrderDetailProductEntriesKey] as? [[String: AnyObject]] {
                    updateOrderTrackingDetails(entryList: entries, productObject: productModel)
                }
                return productModel
            })
        }
    }
}
