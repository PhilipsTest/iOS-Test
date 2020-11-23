/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import CommonCrypto
import SFHFKeychainUtils

class PIMJanrainHandler : NSObject {
    
    let appInfra = PIMSettingsManager.sharedInstance.appInfraInstance()
    
    override init() {
        super.init()
    }
    
    //TODO: getting appinfra from singleton directly. need to refactor
    func doJanrainUserExists() -> Bool {
        do {
            let legacyUserRecord = try appInfra?.storageProvider.fetchValue(forKey: PIMConstants.LegacyJanrainKeys.JANRAIN_CAPTURE_USER)
            return legacyUserRecord != nil ? true : false
        } catch {
            //TODO: error handling
        }
        return false
    }
    
    //TODO: needs to do error handling and force unwrapping
    func refreshUserJanrainAccessToken(completionHandler:@escaping (String?,Error?) -> ()) {
        fetchJanrainBaseURLFromSD { (baseUrl, locale) in
            
            guard let parameter = self.generateJRRequestParameters() else {
                completionHandler(nil,PIMErrorBuilder.buildInvalidRefreshTokenError())
                PIMUtilities.logMessage(.debug, eventId: self.description, message: "No Access token")
                completionHandler(nil,PIMErrorBuilder.buildInvalidRefreshTokenError())
                return
            }
            
            parameter.locale = locale.replacingOccurrences(of: "_", with: "-")
            parameter.url_string = baseUrl
            
            PIMJRSignatureCreator.refreshJRAccessToken(with:parameter, completionHandler: { (response, data, error) in
                guard error == nil else {
                    completionHandler(nil,PIMErrorBuilder.buidNetworkError(httpCode: (error as NSError?)?.code ?? PIMMappedError.PIMServerError.rawValue))
                    PIMUtilities.logMessage(.debug, eventId: self.description, message: "Access token reqeust error \(String(describing: error?.localizedDescription))")
                    return
                }
                guard let accessToken = self.filterAccessTokenFromTokenResponse(data) else {
                    PIMUtilities.logMessage(.debug, eventId: self.description, message: "Signature or input is invalid as per JR \(String(describing: error?.localizedDescription))")
                    completionHandler(nil,PIMErrorBuilder.buildInvalidRefreshTokenError())
                    return
                }
                completionHandler(accessToken, nil)
            })
        }
    }
    
    func filterAccessTokenFromTokenResponse(_ receivedData: Data?) -> String? {
        guard let data = receivedData else {
            PIMUtilities.logMessage(.debug, eventId: self.description, message: "No Access token in JR response data")
            return nil
        }
        do {
            if let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
                guard let validAccessToken = jsonData["access_token"] as? String  else {
                    PIMUtilities.logMessage(.debug, eventId: self.description, message: "No Access token in JR response data")
                    return nil
                }
                return validAccessToken
            }
        } catch {
            PIMUtilities.logMessage(.debug, eventId: self.description, message: "No Access token")
        }
        return nil
    }
    
    // MARK: -
    // MARK: Supported methods
    func fetchJanrainBaseURLFromSD(completionHandler:@escaping (String, String) -> ()) {
        let serviceId = PIMConstants.ServiceIDs.JANRAIN_BASE_URL; appInfra?.serviceDiscovery.getServicesWithCountryPreference([serviceId], withCompletionHandler: { (serviceDict, error) in
            guard let serviceUrl = serviceDict?[serviceId]?.url,
                let locale = serviceDict?[serviceId]?.locale else {
                    return
            }
            completionHandler(serviceUrl, locale)
        }, replacement: nil)
    }
    
    func readDataFromKeychain(tokenName: String) -> String? {
        var keychainData: String?
        let bundleID = Bundle.main.bundleIdentifier
        let serviceName = PIMConstants.LegacyJanrainKeys.JANRAIN_CAPTURE_KEYCHAIN_IDENTIFIER + "." + tokenName + "." + bundleID! + "."
        do {
            keychainData = try SFHFKeychainUtils.getPasswordForUsernameOld(PIMConstants.LegacyJanrainKeys.JANRAIN_KEYCHAIN_USER, andServiceName: serviceName)
        }catch let error {
            PIMUtilities.logMessage(.debug, eventId: self.description, message: "Error reading item from Keychain \(String(describing: error.localizedDescription))")
        }
        return keychainData
    }
    
    func deleteDataFromKeychain(tokenName: String) {
        let bundleID = Bundle.main.bundleIdentifier
        let serviceName = PIMConstants.LegacyJanrainKeys.JANRAIN_CAPTURE_KEYCHAIN_IDENTIFIER + "." + tokenName + "." + bundleID! + "."
        var error: NSError?
        _ = SFHFKeychainUtils.deleteItem(forUsername: PIMConstants.LegacyJanrainKeys.JANRAIN_KEYCHAIN_USER, andServiceName: serviceName, error: &error, withAccessible: false)
        if(error != nil) {
            PIMUtilities.logMessage(.debug, eventId: self.description, message: "Error deleting item from Keychain \(String(describing: error?.localizedDescription))")
        }
    }
    
    func generateJRRequestParameters() -> PIMJRRequestParameters? {
        var parameter:PIMJRRequestParameters?
        let accessToken = readDataFromKeychain(tokenName: PIMConstants.LegacyJanrainKeys.JANRAIN_ACCESS_TOKEN)
        let refreshSecret = readDataFromKeychain(tokenName: PIMConstants.LegacyJanrainKeys.JANRAIN_REFRESH_SECRET)
        let date = getSignatureDate()
        
        guard accessToken != nil && refreshSecret != nil else {
            return nil
        }
        
        guard let token = accessToken, let secret = refreshSecret else {
            return nil
        }
        
        parameter = PIMJRRequestParameters()
        parameter?.access_token = token;
        parameter?.refresh_secret = secret;
        parameter?.date_string = date;
        
        parameter?.client_id = PIMUtilities.getStaticConfig(PIMConstants.Network.LEGACY_CLIENT_ID, appinfraConfig: PIMSettingsManager.sharedInstance.appInfraInstance()?.appConfig)
        return parameter
    }
    
    func getSignatureDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        if let time = NSTimeZone(name: "UTC") {
            dateFormatter.timeZone = time as TimeZone
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let utcTime = appInfra?.time.getUTCTime()
        let dateString = dateFormatter.string(from: utcTime!)
        return dateString
    }
}
