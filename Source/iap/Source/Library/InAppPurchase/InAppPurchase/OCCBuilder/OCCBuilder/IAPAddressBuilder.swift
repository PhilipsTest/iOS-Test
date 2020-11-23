/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPAddressBuilder: IAPUserBuilder {
    
    fileprivate var addressID: String!
    
    init (inUserID: String, inAddressID: String="") {
        self.addressID = inAddressID
        super.init(inUserId: inUserID)
    }
    
    fileprivate func getBaseAddressURL() -> String {
        return super.getUserBaseURL()+"/"+IAPConstants.IAPAddressBuilderKeys.kUserAddress
    }
    
    func getUserAddressesURL() -> String {
        return self.getBaseAddressURL() + "?" + IAPConstants.IAPAddressBuilderKeys.kFields + "=" + IAPConstants.IAPAddressBuilderKeys.kFieldsValue + "&lang="
    }
    
    func getAddDeliveryAddressURL() -> String {
        return self.getUserAddressesURL()
    }
    
    func getAddressID() -> String {
        return self.addressID
    }
    
    func getUpdateAddressURL() -> String {
        return self.getBaseAddressURL()+"/"+self.getAddressID()
    }
    
    func getDeliveryAddressURL() -> String {
        return super.getUserBaseURL() + "/" +
            IAPConstants.IAPAddressBuilderKeys.kCartsKey+"/" +
            IAPConstants.IAPAddressBuilderKeys.kCartsValue+"/" +
            IAPConstants.IAPAddressBuilderKeys.kUserAddress + "/" +
            IAPConstants.IAPAddressBuilderKeys.kDeliveryKey
    }
    
    func getRegionsURL(_ withCountryCode: String)->String {
        return super.getBaseURLWithMetaInfo()+"/"+IAPConstants.IAPAddressBuilderKeys.kRegionsKey + "/" + withCountryCode + "?lang="
    }
    
}
