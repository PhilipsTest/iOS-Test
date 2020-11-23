/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPCartBuilder:IAPUserBuilder {
    
    fileprivate var cartID: String!
    
    init (cartID: String = "",userID: String) {
        self.cartID = cartID
        super.init(inUserId: userID)
    }
    
    func getCardID() -> String {
        return self.cartID
    }
    
    func getCreateCartURL() -> String {
        return super.getUserBaseURL()+"/"+IAPConstants.IAPCartBuilderKeys.kCarts
    }
    
    func getCurrentCartURL() -> String {
        return super.getUserBaseURL() + "/" + IAPConstants.IAPCartBuilderKeys.kCarts + "/" + IAPConstants.IAPAddressBuilderKeys.kCartsValue
    }
    
    func getCartDeleteURL() -> String {
        return self.getCreateCartURL()+"/"+self.cartID
    }
    
    func getCartEntryURL()->String {
        return self.getCreateCartURL()+"/"+self.getCardID()+"/"
    }
    
    func getCartEntryDetailURL()->String {
        return String(self.getCartEntryURL().dropLast())+"?"+IAPConstants.IAPCartBuilderKeys.kFields+"="+IAPConstants.IAPCartBuilderKeys.kFieldValue + "&lang="
    }
    
    func getAddProductURL()->String {
        return self.getCartEntryURL()+IAPConstants.IAPCartBuilderKeys.kEntries
    }
    
    func getUpdateDeliveryModeURL() ->String {
        return self.getCartEntryURL() + IAPConstants.IAPCartBuilderKeys.kSetDeliveyMode
    }
    
    func getDeliveryModeURL() -> String {
        return self.getCartEntryURL() + IAPConstants.IAPCartBuilderKeys.kGetDeliveyMode
    }
    
    func getReauthPaymentURL()->String {
        return self.getCartEntryURL() + IAPConstants.IAPCartBuilderKeys.kSetPaymentDetails
    }
}
