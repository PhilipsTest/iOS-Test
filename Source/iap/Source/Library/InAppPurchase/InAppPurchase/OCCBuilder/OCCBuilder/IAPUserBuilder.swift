/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

protocol IAPPurchaseHistoryURLBuilderProtocol {
    
    func getPurchaseHistoryOverViewURL()->String
    func getPurchaseHistoryOrderDetailURL(_ withOrderID:String)->String
    func getPurchaseHistoryOverViewURLWithCurrentPage(_ withCurrentPage:Int, withSortField:String)->String
}

extension IAPPurchaseHistoryURLBuilderProtocol where Self : IAPUserBuilder {
    
    func getPurchaseHistoryOverViewURL()->String {
        return self.getUserBaseURL() + "/" + IAPConstants.IAPPurchaseHistoryModelKeys.kPurchaseHistoryOveriViewURL
    }
    
    func getPurchaseHistoryOrderDetailURL(_ withOrderID:String)->String {
        return self.getPurchaseHistoryOverViewURL() + "/" + withOrderID + "?" + IAPConstants.IAPUserBuilderKeys.kFieldsKey + "=" + IAPConstants.IAPUserBuilderKeys.kFullKey + "&lang="
    }
    
    func getPurchaseHistoryOverViewURLWithCurrentPage(_ withCurrentPage: Int, withSortField: String) -> String {
        return self.getPurchaseHistoryOverViewURL() + "?"
            + IAPConstants.IAPUserBuilderKeys.kCurrentPage + "="
            + "\(withCurrentPage)" + "&"
            + IAPConstants.IAPUserBuilderKeys.kSortKey + "=" + withSortField
    }
}


class IAPUserBuilder : IAPBaseURLBuilder, IAPPurchaseHistoryURLBuilderProtocol {
    fileprivate var userId:String!
    
    init (inUserId:String) {
        self.userId = inUserId
        super.init()
    }
    
    func getUserID()->String {
        return self.userId
    }
    
    func getUserBaseURL()->String {
        return super.getBaseURL()+"/"+IAPConstants.IAPUserBuilderKeys.kUsers+"/"+self.userId
    }
    
    func getUserDefaultAddressURL() -> String {
        return self.getUserBaseURL()
    }
    
    func getUserPaymentDetailsURL()->String {
        return self.getUserBaseURL()+"/"+IAPConstants.IAPUserBuilderKeys.kUserPaymentDetails
    }
    
}
