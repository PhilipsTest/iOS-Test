/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra
import PlatformInterfaces

class IAPConfiguration: NSObject, UserDataDelegate {
    
    var productsList: [ProductInfo] = [ProductInfo]()
    fileprivate var blackListRetailers: [String] = []
    
    var sharedAppInfra: AIAppInfra!
    var userDetails = [String: String]()
    var locale: String?
    var siteID: String?
    var oauthInfo :IAPOAuthInfo?
    var configuration :IAPConfigurationData!
    fileprivate var configurationSiteID :String?
    var configurationData: IAPConfigurationData?
    var cartIconDelegate: IAPCartIconProtocol?
    var isHybrisEnabled: Bool = false
    var baseURL: String?
    var iapAppTagging: AIAppTaggingProtocol?
    var iapAppLogging: AILoggingProtocol?
    var sharedUDInterface: UserDataInterface?
    var voucherId: String?
    weak var orderFlowCompletionDelegate: IAPOrderFlowCompletionProtocol?
    var supportsHybris: Bool = true
    var maximumCartCount: Int = 0
    weak var bannerConfigDelegate: IAPBannerConfigurationProtocol?
    static let sharedInstance = IAPConfiguration()

    static func setIAPConfiguration(_ localeField: String, inAppInfra: AIAppInfra)
    {
        sharedInstance.locale = localeField
        sharedInstance.siteID = ""
        sharedInstance.sharedAppInfra = inAppInfra
    }
    
    override init () {
    }
    
    func setSiteIdentifier(_ siteId:String) {
        self.siteID = siteId
    }
    
    func getJanrinUUID() -> String? {
        return getUserDetails([UserDetailConstants.UUID])?[UserDetailConstants.UUID]
    }
    
    func getJanrinAccessToken() -> String? {
        
        return getUserDetails([UserDetailConstants.ACCESS_TOKEN])?[UserDetailConstants.ACCESS_TOKEN]
    }
    
    func getUDInterface() -> UserDataInterface? {
        return self.sharedUDInterface
    }

    func setOauth(_ inOauth:IAPOAuthInfo) {
        self.oauthInfo = inOauth
    }
    
    func setConfigurationSiteID(_ inSiteID:String) {
        self.configurationSiteID = inSiteID
    }
    
    func getConfigurationSiteID() -> String? {
        return self.configurationSiteID
    }
    
    func setBlackListRetailers(_ inputList:[String]) {
        blackListRetailers = inputList
    }
    
    func getBlackListRetailers() -> [String] {
        return blackListRetailers
    }
    
    func setIAPAppTagging(_ appTaggingInstance:AIAppTaggingProtocol) {
        self.iapAppTagging = appTaggingInstance
    }
    
    func setIAPAppLogging(_ appLoggingInstance:AILoggingProtocol) {
        self.iapAppLogging = appLoggingInstance
    }
    
    func setUserDataInterface(_ userDataInterface:UserDataInterface) {
        self.sharedUDInterface = userDataInterface
        userDataInterface.addUserDataInterfaceListener(IAPConfiguration.sharedInstance)
    }
    
    func getUserDetails(_ list: Array<String>) -> Dictionary<String, String>? {
        let userDetails =  try? self.sharedUDInterface?.userDetails(list)
        return userDetails as? Dictionary<String, String>
    }
    
    // MARK: Regestration delegate methods
    func logoutSessionSuccess() {
        self.oauthInfo = nil
    }

    func isInternetReachable() -> Bool {
        return sharedAppInfra.restClient.isInternetReachable()
    }

    func log(_ level: AILogLevel, eventId: String!, message: String!) {
        sharedAppInfra.logging.log(level, eventId: eventId, message: message)
    }
    
    func getIAPSDURL(forKey key:String,completionHandler:((String?, Error?) -> Void)?, replacement: [AnyHashable : Any]?) {
        let SDURLKey:String = "iap.\(key)"
        self.sharedAppInfra.serviceDiscovery.getServicesWithCountryPreference([SDURLKey], withCompletionHandler: { (returnedValue, inError) in
            var url:String?
            if let serviceDiscoveryValue = returnedValue?[SDURLKey] {
                url = serviceDiscoveryValue.url
            }
            completionHandler?(url,inError)
        }, replacement: replacement)
    }
    
    func fetchSDURLForKey(forKey key:String,completionHandler:@escaping ((String?, Error?) -> Void)) {
        self.getIAPSDURL(forKey: key, completionHandler:  { (returnedValue, inError) in
            completionHandler(returnedValue,inError)
        }, replacement:nil)
    }
}

class ProductInfo {
    var productCTN : String
    var productQuanity : Int
    
    init? (productCTN : String, quantity : Int) {
        self.productCTN = productCTN
        self.productQuanity = quantity
    }
    
    init (productCTN : String) {
        self.productCTN = productCTN
        self.productQuanity = 1
    }
}
