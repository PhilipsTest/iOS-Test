/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPConfigurationData {
    
    var catalogId:String?
    var faqUrl:String?
    var helpDeskEmail:String?
    var helpDeskPhone:String?
    var helpUrl:String?
    var rootCategory:String?
    var siteId:String?

    convenience init(inDictionary:NSDictionary) {
        
        self.init()
        
        self.catalogId = inDictionary[IAPConstants.IAPConfigDataKeys.kCatalogId] as? String
        self.faqUrl = inDictionary[IAPConstants.IAPConfigDataKeys.kFaqUrl] as? String
        self.helpDeskEmail = inDictionary[IAPConstants.IAPConfigDataKeys.kHelpDeskEmail] as? String
        self.helpDeskPhone = inDictionary[IAPConstants.IAPConfigDataKeys.kHelpDeskPhone] as? String
        self.helpUrl = inDictionary[IAPConstants.IAPConfigDataKeys.kHelpUrl] as? String
        self.rootCategory = inDictionary[IAPConstants.IAPConfigDataKeys.kRootCategory] as? String
        self.siteId = inDictionary[IAPConstants.IAPConfigDataKeys.kSiteId] as? String

        IAPConfiguration.sharedInstance.configurationData = self
        guard self.siteId != nil else { return }
        IAPConfiguration.sharedInstance.setConfigurationSiteID(self.siteId!)
    }
    
    class func configurationSiteId() -> String {
        
        if let site = IAPConfiguration.sharedInstance.getConfigurationSiteID() {
            return site
        }
        return ""
    }
}
