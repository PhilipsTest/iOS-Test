/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppAuth
import AppInfra

class PIMSettingsManager {
    
    static let COMPONENT_ID = "pim"
    static let sharedInstance = PIMSettingsManager()
    
    private var locale: String?
    private var executionHandler:((Error?) -> Void)?
    
    var logging:AILoggingProtocol?
    var tagging:AIAppTaggingProtocol?
    var restClient:AIRESTClientProtocol?
    var pimOIDCConfiguration: PIMOIDCConfiguration?
    var appinfra : AIAppInfra?
    var pimUserManager : PIMUserManager?
    var isUserMigrating : Bool = false // false at start
    var pimConsents: [String] = [String]()
    var pimLaunchFLow: PIMLaunchFlow = .noPrompt
    
    
    private init(){}
    
    func getClientID() -> String {
        let clientID = PIMUtilities.getStaticConfig(PIMConstants.Network.CLIENT_ID, appinfraConfig: self.appinfra?.appConfig)
        let migrationClientID = PIMUtilities.getStaticConfig(PIMConstants.Network.MIGRATION_CLIENT_ID, appinfraConfig: self.appinfra?.appConfig)
        let isUserMigratedFromJR = (PIMUserManager.isUserMigratedFromJR() || isUserMigrating == true)
        let appClientID = ((isUserMigratedFromJR == true) ? migrationClientID : clientID)
        return appClientID
    }
    
    func getRedirectURL() -> String {
        let clientID = PIMUtilities.getStaticConfig(PIMConstants.Network.CLIENT_ID, appinfraConfig: self.appinfra?.appConfig)
        let migrationClientID = PIMUtilities.getStaticConfig(PIMConstants.Network.MIGRATION_CLIENT_ID, appinfraConfig: self.appinfra?.appConfig)
        var appRedirectURI = PIMUtilities.getStaticConfig(PIMConstants.Network.REDIRECT_URI, appinfraConfig: self.appinfra?.appConfig)
        let isUserMigratedFromJR = (PIMUserManager.isUserMigratedFromJR() || isUserMigrating == true)
        if isUserMigratedFromJR == true {
            appRedirectURI = appRedirectURI.replacingOccurrences(of: clientID, with: migrationClientID)
        }
        return appRedirectURI
    }
    
    func updateDependencies(_ dependencies:PIMDependencies) {
        assert(dependencies.appInfra != nil, "AppInfra can't be nil")
        logging = dependencies.appInfra.logging.createInstance(forComponent:PIMSettingsManager.COMPONENT_ID, componentVersion:PIMSettingsManager.sharedInstance.componentVersion())
        tagging = dependencies.appInfra.tagging.createInstance(forComponent: PIMSettingsManager.COMPONENT_ID, componentVersion: PIMSettingsManager.sharedInstance.componentVersion())
        appinfra = dependencies.appInfra
        let sessionConfiguration = URLSession.shared.configuration
        URLCache.shared.removeAllCachedResponses()
        sessionConfiguration.urlCache = nil
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        restClient = dependencies.appInfra.restClient.createInstance(with: sessionConfiguration)
        restClient?.reachabilityManager.startMonitoring()
        PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMSettingManager", message: "Dependencies initialised with shared instance")
    }
    
    func isNetworkReachable() -> Bool {
        return (restClient?.reachabilityManager.isReachable ?? false)
    }
    
    func userManager(_ userManager:PIMUserManager) {
       pimUserManager = userManager
    }
    
    func pimUserManagerInstance() -> PIMUserManager {
        return pimUserManager!
    }

    func pimOIDCConfig() -> PIMOIDCConfiguration? {
        return pimOIDCConfiguration
    }

    func loggingInterface() -> AILoggingProtocol? {
        return logging
    }
    
    func taggingInterface() -> AIAppTaggingProtocol? {
        return tagging
    }
    
    func appInfraInstance() -> AIAppInfra? {
        return appinfra
    }
    
    func restClientInterface() -> AIRESTClientProtocol? {
        return restClient
    }
    
    func pimOIDCConfiguration(_ oidcConfig: PIMOIDCConfiguration){
        pimOIDCConfiguration = oidcConfig
    }
    
    func setLocale(_ inLocale: String?) {
        if let localeValue = inLocale {
            locale = localeValue.replacingOccurrences(of: "_", with: "-")
        }
    }
    
    func getLocale() -> String? {
        return locale
    }
    
    func getPIMSDURL(forKey key:String,completionHandler:((String?, Error?) -> Void)?, replacement: [AnyHashable : Any]?) {
        self.appinfra?.serviceDiscovery.getServicesWithCountryPreference([key], withCompletionHandler: { (returnedValue, inError) in
            if let serviceDiscoveryValue = returnedValue?[key]?.url {
                self.setLocale(returnedValue?[key]?.locale)
                completionHandler?(serviceDiscoveryValue,inError)
            }else {
                completionHandler?(nil,inError)
            }
        }, replacement: replacement)
    }
    
    func setPIMConsents(consents: [String]) {
        pimConsents = consents
    }
    
    func getPIMConsents() -> [String] {
        return pimConsents
    }
    
    func setPIMLaunchFLow(launchFLow: PIMLaunchFlow) {
        pimLaunchFLow = launchFLow
    }
    
    func getPIMLaunchFlow() -> PIMLaunchFlow {
        return pimLaunchFLow
    }

}

extension PIMSettingsManager{
    func componentVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    //TODO: added here right now to support exit out of PIM from anywhere. During error mapping we can move to VC if not required.
    func setPIMCompletionHandler(completionHandler:((Error?) -> Void)?) {
        self.executionHandler = completionHandler
    }
    
    func executePIMCompletionHandler(with error: Error?) {
        if ((self.executionHandler) != nil) {
            self.executionHandler!(error)
            self.executionHandler = nil
        }
    }
}
