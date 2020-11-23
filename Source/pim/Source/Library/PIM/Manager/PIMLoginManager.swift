/*
 * Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppAuth
import AdobeMobileSDK
import AppInfra

class PIMLoginManager {
    
    private var serviceConfig:PIMOIDCConfiguration
    
    init(_ serviceConfiguration:PIMOIDCConfiguration) {
        serviceConfig = serviceConfiguration
    }
    
    func oidcLogin(_ viewController: UIViewController, completion:@escaping (_ error: Error?) -> Void) {
        let pimUserManager = PIMSettingsManager.sharedInstance.pimUserManagerInstance()
        let authManager = PIMAuthManager()
        let loginParameters = createAdditionalParameterForLogin()
        authManager.loginToOIDC(serviceConfig, viewController: viewController, parameter: loginParameters, completion: { (authState, error) in
            if let authState = authState, error == nil {
                pimUserManager.requestUserProfile(authState, completion: { (userProfile, error) in
                    if error != nil{
                        completion(error)
                        return
                    }
                    completion(nil)
                })
                return
            }
            completion(error)
        })
    }
    
}

extension PIMLoginManager {
    
    func createAdditionalParameterForLogin() -> [String: String] {
        let locale = PIMSettingsManager.sharedInstance.getLocale() ?? ""
        let taggingRSID = PIMUtilities.getStaticConfig(PIMConstants.Network.TAGGING_RSID, appinfraConfig: PIMSettingsManager.sharedInstance.appInfraInstance()!.appConfig)
        
        var parameters: [String: String] = [PIMConstants.AuthorizationKeys.ANALYTICS_REPORT_SUITE: taggingRSID,
                                            PIMConstants.AuthorizationKeys.CONSENTS: getAuthorizationConsents(),
                                            PIMConstants.AuthorizationKeys.UI_LOCALE: locale,
                                            PIMConstants.AuthorizationKeys.CLAIMS: getCustomClaims()]
        let udiLaunchFlow = PIMSettingsManager.sharedInstance.getPIMLaunchFlow().rawValue
        if (udiLaunchFlow != PIMLaunchFlow.noPrompt.rawValue) {
            parameters[PIMConstants.AuthorizationKeys.PROMPT] = udiLaunchFlow
        }
        
        return parameters
    }
    
    func getCustomClaims() -> String {
        let customClaimsInput = [PIMConstants.UserCustomClaims.UUID, PIMConstants.UserCustomClaims.SOCIAL_PROFILES, PIMConstants.UserCustomClaims.RECEIVE_MARKETING_EMAIL, PIMConstants.UserCustomClaims.RECEIVE_MARKETING_EMAIL_TIMESTAMP]
        var claimDict = Dictionary<String,String?>()
        
        for claim in customClaimsInput {
            claimDict.updateValue(nil, forKey: claim)
        }
        var formattedClaimDict = Dictionary<String,[String:String?]>()
        formattedClaimDict.updateValue(claimDict, forKey: PIMConstants.AuthorizationKeys.USER_INFO)
        let jsonString = formattedClaimDict.jsonStringRepresentaiton
        return jsonString ?? " "
    }
    
    func getAuthorizationConsents() -> String {
        var pimConsents = PIMSettingsManager.sharedInstance.getPIMConsents()
        let appinfraInstance = PIMSettingsManager.sharedInstance.appInfraInstance()
        let consent = appinfraInstance?.tagging.getPrivacyConsent()
        if (consent == .optIn) {
            pimConsents.append(PIMConstants.AuthorizationKeys.ANALYTICS)
        }
        let commaSeparatedConsents = pimConsents.isEmpty ? "" : pimConsents.joined(separator: ",")
        
        return commaSeparatedConsents
    }
    
}
