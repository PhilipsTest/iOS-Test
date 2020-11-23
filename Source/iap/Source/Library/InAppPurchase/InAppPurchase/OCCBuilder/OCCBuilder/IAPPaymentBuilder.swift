/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPPaymentBuilder:IAPOrderBuilder {
    fileprivate var orderId:String!
    
    init(inOrderId:String,userID:String) {
        self.orderId = inOrderId
        super.init(userID: userID)
    }
    
    func getMakePaymentURL()->String {
        return self.getUserBaseURL() + "/" + IAPConstants.IAPPaymentKeys.kOrdersKey + "/" + self.orderId + "/" +  IAPConstants.IAPPaymentKeys.kPayKey
    }
    
    func getOrderId()->String {
        return self.orderId
    }
}
