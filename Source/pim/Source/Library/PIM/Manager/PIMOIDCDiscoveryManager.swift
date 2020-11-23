/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppAuth
import AppInfra

class PIMOIDCDiscoveryManager {
    
    func downloadOIDCUrls(_ baseUrl:String) {
        let pimAuthManager = PIMAuthManager()
        PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMOIDCDiscoveryManager", message: "download service configuration called url:\(baseUrl)")
        pimAuthManager.fetchAuthWellKnowConfiguration(baseUrl) { (oidcConfiguration, error) in
            guard let oidcConfiguration = oidcConfiguration else {
                PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMOIDCDiscoveryManager", message: "service configuration not available")
                return
            }
            PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMOIDCDiscoveryManager", message: "service configuration present")
            let pimOIDCConfiguration = PIMOIDCConfiguration(oidcConfiguration)
            PIMSettingsManager.sharedInstance.pimOIDCConfiguration(pimOIDCConfiguration)
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: .configDownloadCompleted, object: nil)
        }
    }
    
}
