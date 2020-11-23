/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPOrderInfo {

    fileprivate var orderId: String!
    fileprivate var address: IAPUserAddress!

    init (inDict: [String: AnyObject]) {
        self.orderId = inDict[IAPConstants.IAPOrderInfoKeys.kOrderIdkey] as? String ?? ""
        if let addressData = inDict[IAPConstants.IAPOrderInfoKeys.kDeliveryAddresskey] as? [String: AnyObject] {
            self.address = IAPUserAddress.init(inDict: addressData)
        }
    }

    func getOrderId() -> String {
        return self.orderId
    }
    
    func getAddress() -> IAPUserAddress {
        return self.address
    }
}
