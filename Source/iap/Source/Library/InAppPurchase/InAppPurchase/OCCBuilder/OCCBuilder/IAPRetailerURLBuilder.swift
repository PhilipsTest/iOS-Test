/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPRetailerURLBuilder {
   
    fileprivate var locale : String!
    fileprivate var productCode : String!
    
    convenience init(inProductCode : String, inLocale : String){
        self.init()
        self.productCode = inProductCode
        self.locale = inLocale
    }
    
    func getWhereToBuyRetailerURL() -> String {
        return IAPConstants.IAPRetailerURLKeys.kScheme + "://"
            + IAPConstants.IAPRetailerURLKeys.kHostport + "/"
            + IAPConstants.IAPRetailerURLKeys.kWebroot + "/"
            + IAPConstants.IAPRetailerURLKeys.kVersion + "/"
            + IAPConstants.IAPRetailerURLKeys.kSector + "/"
            + self.locale + "/" + "online-retailers?product=" + self.productCode
    }
    
    func getHostPort() -> String {
        return IAPConstants.IAPRetailerURLKeys.kHostport
    }
}
