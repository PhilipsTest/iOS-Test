/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPOrderBuilder:IAPUserBuilder {
    
    init(userID:String) {
        super.init(inUserId: userID)
    }
    
    func getOrderURL()->String {
        return self.getUserBaseURL() + "/" + IAPConstants.IAPPaymentKeys.kOrdersKey
    }
    
}