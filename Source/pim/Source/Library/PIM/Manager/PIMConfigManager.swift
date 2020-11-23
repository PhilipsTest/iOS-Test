/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppInfra
import PlatformInterfaces

class PIMConfigManager {
    static let SERVICE_ID = "userreg.janrainoidc.issuer"
    private var pimAuthManager: PIMAuthManager?
    
    init(_ serviceDiscovery: AIServiceDiscoveryProtocol, _ userManager: PIMUserManager) {
        PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMConfigManager", message: "PIMConfigManager init called")
        guard userManager.getUserLoggedInState() == UserLoggedInState.userNotLoggedIn else {
            //TODO: is it really required to do at this step. we canhandle the same in PIMInterface also
            return
        }
        self.downloadSDServiceUrl(serviceDiscovery, PIMConfigManager.SERVICE_ID)
    }
    
    func downloadSDServiceUrl(_ serviceDiscInterface: AIServiceDiscoveryProtocol?, _ serviceID: String){
        PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMConfigManager", message: "Download service url called")
        serviceDiscInterface?.getServicesWithCountryPreference([serviceID], withCompletionHandler: { (serviceDict, error) in
            if let serviceUrl = serviceDict?[PIMConfigManager.SERVICE_ID]?.url {
                PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMConfigManager", message: "service url present:\(serviceUrl)")
                PIMSettingsManager.sharedInstance.setLocale(serviceDict?[PIMConfigManager.SERVICE_ID]?.locale)
                let pimOIDCDiscovery = PIMOIDCDiscoveryManager()
                pimOIDCDiscovery.downloadOIDCUrls(serviceUrl)
                return
            }
            PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMConfigManager", message: "service url not present")
        }, replacement: nil)
    }
}
