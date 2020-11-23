/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

class IAPOAuthConfigurationData {

    class func isDataLoadedFromHybris() -> Bool {
        return IAPConfiguration.sharedInstance.isHybrisEnabled
    }

    class func loadConfigurationInformation() -> (String?, String?, String?) {
        return (IAPOAuthConfigurationData.getConfigValueForKey(IAPConstants.IAPConfigurationKeys.kSchemeKey),
                IAPOAuthConfigurationData.getConfigValueForKey(IAPConstants.IAPConfigurationKeys.kWebRootKey),
                IAPOAuthConfigurationData.getConfigValueForKey(IAPConstants.IAPConfigurationKeys.kVersionKey))
    }
    
    class func loadInAppPurchaseConfigurationInformation() -> (String?, String?) {
        let hostPort = IAPOAuthConfigurationData.getInAppConfigValueForKey(IAPConstants.IAPConfigurationKeys.kHostPortKey)
        return (hostPort as? String, IAPConfigurationData.configurationSiteId())
    }
    
    class func getConfigValueForKey(_ inKey: String) -> String {
        guard let jsonDict = IAPOAuthConfigurationData.loadConfigurationJSONData("Configuration") else {
            return ""
        }
        return (jsonDict[inKey] as? String ?? "")
    }
    
    class func getInAppConfigValueForKey(_ key: String!) -> Any?{
        do{
            let value = try IAPConfiguration.sharedInstance.sharedAppInfra?.appConfig.getPropertyForKey(key,group:"IAP")
            if let result = value {
                return result
            } else {
                return nil
            }
        }catch let error as NSError{
            IAPConfiguration.sharedInstance.iapAppLogging?.log(.error, eventId: "IAP", message:error.localizedDescription)
        }
        return nil
    }
    
    class func getBaseURL() -> String {
        return IAPConfiguration.sharedInstance.baseURL!
    }
    
    class func getURLValue(_ onSuccess: @escaping (String) -> Void) {
        
        IAPConfiguration.sharedInstance.sharedAppInfra.serviceDiscovery.getServicesWithLanguagePreference(["iap.baseurl"], withCompletionHandler: { (returnedServices, inError) in
            guard inError == nil else {
                return
            }
            guard returnedServices != nil else {
                return
            }
            
            guard let aService = returnedServices?["iap.baseurl"] else {
                return
            }
            
            guard let aURL = aService.url else {
                return
            }
            
            onSuccess((aURL.removeCharacterAtEndOfString(6)!))
            
        }, replacement: nil)
    }
    
    class func getWorldPayStatusURLS() -> (successURL: String?,
        cancelURL: String?,
        failureURL: String?,
        pendingURL: String?) {
        return (IAPOAuthConfigurationData.getConfigValueForKey(IAPConstants.IAPConfigurationKeys.kWorldpaySuccessURLKey),
                IAPOAuthConfigurationData.getConfigValueForKey(IAPConstants.IAPConfigurationKeys.kWorldpayFailureURLKey),
                IAPOAuthConfigurationData.getConfigValueForKey(IAPConstants.IAPConfigurationKeys.kWorldpayPendingURLKey),
                IAPOAuthConfigurationData.getConfigValueForKey(IAPConstants.IAPConfigurationKeys.kWorldpayCancelURLKey))
    }

    fileprivate class func loadConfigurationJSONData(_ resourcePath: String) -> NSDictionary? {
        guard let path = IAPUtility.getBundle().path(forResource: resourcePath,
                                                             ofType: "json") else { return nil }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData,
                                    options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: String]
            return jsonDict as NSDictionary?
        } catch _ as NSError {
            //print("Data conversion error::: \(error.localizedDescription)")
        }
        return nil
    }

    fileprivate class func loadJSONDataFromFile(_ resourcePath: String)-> [String: AnyObject]? {
        guard let path = Bundle.main.path(forResource: resourcePath, ofType: "json") else { return nil }
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil}
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData,
                                                            options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
            return jsonDict
        } catch _ as NSError {
            //print("Data conversion error::: \(error.localizedDescription)")
        }
        return nil
    }
}
