/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPRetailerModel {
    
    var retailerName: String!
    var isProductAvailabile: Bool = false
    var isPhilipsStore: String!
    var buyURL: String!
    var logoURL: String!
    var retailerParam: String!
    
    init(inDict: [String: AnyObject]){
        if let name = inDict[IAPConstants.IAPRetailerKeys.kRetailerNameKey] as? String {
            self.retailerName = name
        }
        
        if let avail = inDict[IAPConstants.IAPRetailerKeys.kRetailerProductAvailability] as? String {
            self.isProductAvailabile = (avail == "YES") ? true : false
        }
        
        if let url = inDict[IAPConstants.IAPRetailerKeys.kRetailerBuyURL] as? String {
            self.buyURL = url 
        }
        
        if let imageURL = inDict[IAPConstants.IAPRetailerKeys.kRetailerLogoURL] as? String {
            self.logoURL = imageURL
        }
        
        if let philipsStoreAvailable = inDict[IAPConstants.IAPRetailerKeys.kPhilipsStoreAvailable] as? String {
            self.isPhilipsStore = philipsStoreAvailable
        }
        
        if let retailerParam = inDict[IAPConstants.IAPRetailerKeys.kRetailerParam] as? String {
            self.retailerParam = retailerParam
        }
    }
}

class IAPRetailerModelCollection {
    fileprivate var retailers:[IAPRetailerModel] = [IAPRetailerModel]()

    init(inDict:[String: AnyObject]) {
        if let wrbResults = inDict[IAPConstants.IAPRetailerKeys.kWRBResults] as? [String: AnyObject] {
            if let onlineStores = wrbResults[IAPConstants.IAPRetailerKeys.kOnlineStores] as? [String: AnyObject] {
                if let stores = onlineStores[IAPConstants.IAPRetailerKeys.kStores] as? [String: AnyObject] {
                    if let retailersArray = stores[IAPConstants.IAPRetailerKeys.kStore] as? [[String:AnyObject]] {
                        for retailer in retailersArray {
                            if IAPOAuthConfigurationData.isDataLoadedFromHybris() {
                                if retailer["isPhilipsStore"] as? String == "N"{
                                    self.retailers.append(IAPRetailerModel(inDict: retailer))
                                }
                                continue
                            }
                            self.retailers.append(IAPRetailerModel(inDict: retailer))
                        }
                    }
                }
            }
        }
    }

    func getRetailers()->[IAPRetailerModel] {
        return self.retailers
    }
}
