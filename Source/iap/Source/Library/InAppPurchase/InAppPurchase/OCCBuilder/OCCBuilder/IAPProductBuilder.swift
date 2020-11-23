/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPProductBuilder:IAPBaseURLBuilder {
    fileprivate var productCode:String!
    
    init(inProductCode:String = "") {
        self.productCode = inProductCode
    }
    
    fileprivate func getSearchBaseURL()->String {
        return self.getBaseURL() + "/" + IAPConstants.IAPProductKeys.kProductKey + "/" + IAPConstants.IAPProductKeys.kSearchKey + "?" +  IAPConstants.IAPProductKeys.kQueryKey + "="
    }
    
    func getProductSearchURL()->String {
        return self.getBaseURL() + "/" + IAPConstants.IAPProductKeys.kProductKey + "/" + self.getProductCode()
    }
    
    func getProductCatalogueURL(_ withCurrentPage:Int)->String {
        let categoryString = IAPConstants.IAPProductKeys.kCatalogueKey + "\(IAPConfiguration.sharedInstance.configurationData?.rootCategory ?? "")"
        return self.getSearchBaseURL() + categoryString + "&" + IAPConstants.IAPProductKeys.kCurrentPage + "=" + "\(withCurrentPage)" + "&lang="
    }
    
    func provideAllProductCatalogueURL(_ withPageSize:Int)-> String {
        let categoryString = IAPConstants.IAPProductKeys.kCatalogueKey + "\(IAPConfiguration.sharedInstance.configurationData?.rootCategory ?? "")"
        return self.getSearchBaseURL() + categoryString + "&" + IAPConstants.IAPProductKeys.kPageSizeKey + "=" + "\(withPageSize)" + "&lang="// + languageCode
    }
    
    func getProductCode()->String {
        return self.productCode
    }
}
