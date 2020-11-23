/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

//MARK: Configuration API url creation
//MARK:
protocol IAPConfigurationURLProtocol : class {
    func proivdeAppConfigurationBaseURL(_ withLocale:String, withProposition:String) -> String
}

extension IAPConfigurationURLProtocol where Self : IAPBaseURLBuilder {
    func proivdeAppConfigurationBaseURL(_ withLocale:String,withProposition:String) -> String {
        return String(format: "%@/%@/%@/inAppConfig/%@/%@?lang=", arguments: [self.hostPort,self.webRoot,self.version,withLocale,withProposition])
    }
}
//MARK: End of Configuration API url creation
//MARK:

class IAPBaseURLBuilder: IAPConfigurationURLProtocol {
    var baseurl:String!
    var scheme:String!
    var hostPort:String!
    var webRoot:String!
    var version:String!
    var site:String!
    
    init(){
        let (_,webRoot,version) = IAPOAuthConfigurationData.loadConfigurationInformation()
        let (_, site) = IAPOAuthConfigurationData.loadInAppPurchaseConfigurationInformation()
        //self.scheme     = IAPConfiguration.sharedInstance.baseURL//scheme
        self.hostPort   = IAPConfiguration.sharedInstance.baseURL//hostPort
        self.webRoot    = webRoot
        self.version    = version
        self.site       = site
        self.baseurl    = String(format: "%@/%@/%@/%@", arguments: [self.hostPort,self.webRoot,self.version,self.site])
    }
    
    func getBaseURL()->String {
        return self.baseurl
    }
    
    func getHostPort()->String {
        return self.hostPort
    }
    
    func getBaseURLWithMetaInfo() -> String {
        return String(format: "%@/%@/%@/metainfo", arguments: [self.hostPort,self.webRoot,self.version])
    }
    
}
