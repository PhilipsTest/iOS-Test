/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppAuth
import AppInfra

class PIMAuthManager {
    
    private var delegate:UDIRefreshSession?
    
    private let MARKETING_EMAIL_CONSENT_SCOPE = "consumerIdentityService/user:update/consent_email_marketing"
    
    func fetchAuthWellKnowConfiguration(_ baseUrl:String, completion: @escaping (_ oidcServiceDiscovery: OIDServiceConfiguration?, _ error: Error?) -> Void) {
        PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMAuthManager", message: "fetchAuthWellKnowConfiguration called with url:\(baseUrl)")
        let serviceUrl:URL = URL(string:baseUrl)!
        OIDAuthorizationService.discoverConfiguration(forIssuer: serviceUrl) { configuration, error in
            //TODO: 7200
            guard error == nil else {
                let aError = PIMErrorBuilder.buildAuthStateError(fromError: error as NSError?)
                completion(nil,aError)
                return
            }
            
            guard let config = configuration else {
                let aError = PIMErrorBuilder.buildDiscoveryError()
                completion(nil, aError)
                return
            }
            completion(config, nil)
        }
    }
    
    func provideAuthSession(_ pimOIDCConfiguration: PIMOIDCConfiguration, parameter:[String:String]) -> OIDAuthorizationRequest {
        return self.provideOIDCAuthRequest(pimOIDCConfiguration, parameter: parameter)
    }
    
    func loginRedirectedUser(url:URL) {
        let query = OIDURLQueryComponent(url: url)
        //If previous app killed and fresh install with old redirection URI request handling
        guard let request = PIMSettingsManager.sharedInstance.provideSavedAuthRequest() else {
            PIMSettingsManager.sharedInstance.executePIMCompletionHandler(with: PIMErrorBuilder.buildRedirectionError())
            return;
        }
        
        //URL dont have required parameters. Server error.
        guard (query?.dictionaryValue != nil) else {
            PIMSettingsManager.sharedInstance.executePIMCompletionHandler(with: PIMErrorBuilder.buildRedirectionURLError())
            return;
        }
    
        let response = OIDAuthorizationResponse(request: request, parameters: query!.dictionaryValue)
        //Token request not created due to some error in request or response
        guard let tokenRequest = response.tokenExchangeRequest() else {
            PIMSettingsManager.sharedInstance.executePIMCompletionHandler(with: PIMErrorBuilder.buildPIMError(code: .PIMOIDErrorCodeOAuthAuthorizationUnsupportedResponseType, message:"PIM_Error_Msg" , domain: "com.PIM.Login.RedirectionFailed"))
            return;
        }
        //States has to be matched else this is different redirection for different request
        guard request.isRedirectURLValid(response:response) == true else {
            PIMSettingsManager.sharedInstance.executePIMCompletionHandler(with: PIMErrorBuilder.buildRedirectionURLError())
            return;
        }
        
        OIDAuthorizationService.perform(tokenRequest, originalAuthorizationResponse: response, callback: { tokenResponse,error in
            guard error == nil else {
                  PIMSettingsManager.sharedInstance.executePIMCompletionHandler(with: PIMErrorBuilder.buildAuthStateError(fromError: error as NSError?))
                  return
              }
            let authState = OIDAuthState(authorizationResponse: response, tokenResponse: tokenResponse)
            let pimUserManager = PIMSettingsManager.sharedInstance.pimUserManagerInstance()
            pimUserManager.requestUserProfile(authState, completion: { (userProfile, error) in
                guard error == nil else {
                    PIMSettingsManager.sharedInstance.executePIMCompletionHandler(with: PIMErrorBuilder.buildAuthStateError(fromError: error as NSError?))
                    return;
                }
                if userProfile != nil {
                    PIMSettingsManager.sharedInstance.executePIMCompletionHandler(with: nil)
                }
            })
        })
    }
    
    func loginToOIDC(_ pimOIDCConfiguration: PIMOIDCConfiguration, viewController: UIViewController, parameter:[String:String], completion: @escaping (_ oidcState: OIDAuthState?, _ error: Error?) -> Void) {
        let request = self.provideOIDCAuthRequest(pimOIDCConfiguration, parameter: parameter)
        let pimcontroller = viewController as? PIMViewController
        pimcontroller?.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: viewController) { authState, error in
            guard error == nil else {
                let pimError = PIMErrorBuilder.buildAuthStateError(fromError: error as NSError?)
                completion(nil,pimError)
                return
            }
            if let response = authState {
                PIMSettingsManager.sharedInstance.clearAuthRequest()
                completion(response,nil)
                return;
            }
        }
        PIMSettingsManager.sharedInstance.storeAuthRequest(authFlow: request)
    }
    
    
    func refreshAccessToken(_ authState: OIDAuthState, delegate:UDIRefreshSession) {
        let inputAuthState:OIDAuthState = authState
        self.delegate = delegate
        let oldAccessToken = inputAuthState.lastTokenResponse?.accessToken
        authState.setNeedsTokenRefresh()
        authState.performAction { (accessToken, idTOken, error) in
              guard error == nil else {
                let pimError = PIMErrorBuilder.buildAuthStateError(fromError: error as NSError?)
                self.delegate?.refreshSessionStatus(authState, false, pimError)
                self.delegate = nil;
                return
              }
              if let newAccessToken = accessToken, newAccessToken != oldAccessToken {
                  // refresh api is successful
                self.delegate?.refreshSessionStatus(authState, true, nil)
              }else {
                self.delegate?.refreshSessionStatus(authState, false, nil)
              }
            self.delegate = nil;
          }
    }
    
    private func buildAndProvideRequest(token:String,config:PIMOIDCConfiguration) -> OIDAuthorizationRequest {
        let parameters = [PIMConstants.Parameters.ID_TOKEN_HINT:token,PIMConstants.Parameters.CLAIMS:PIMLoginManager(config).getCustomClaims(),"prompt":"none"]
        let request = self.provideOIDCAuthRequest(config, parameter: parameters)
        request.setValue(nil, forKey: "nonce")
        return request
    }
    
    func provideMigrationRequest(withToken token:String,completionHandler: @escaping ((OIDAuthorizationRequest?,Error?) -> Void)) {
        guard let config = PIMSettingsManager.sharedInstance.pimOIDCConfig() else {
            PIMSettingsManager.sharedInstance.getPIMSDURL(forKey: PIMConfigManager.SERVICE_ID, completionHandler:
                { urlString,error in
                    guard error == nil else {
                        let error = PIMErrorBuilder.getNoSDURLError()
                        completionHandler(nil,error)
                        return
                    }
                    guard let url = urlString else {
                        let error = PIMErrorBuilder.getNoSDURLError()
                        completionHandler(nil,error)
                        return
                    }
                    self.fetchAuthWellKnowConfiguration(url, completion: { config,error in
                        guard error == nil else {
                            completionHandler(nil,error)
                            return
                        }
                        guard let aConfig = config else {
                            let error = PIMErrorBuilder.getOIDCDownloadError()
                            completionHandler(nil,error)
                            return
                        }
                        let request = self.buildAndProvideRequest(token: token, config: PIMOIDCConfiguration(aConfig))
                        completionHandler(request,nil)
                    })
                    
            },
                replacement: nil)
            
            return
        }
        let request = self.buildAndProvideRequest(token: token, config: config)
        completionHandler(request,nil)
    }
    
    private func provideOIDCAuthRequest(_ pimOIDCConfiguration: PIMOIDCConfiguration, parameter:[String:String]) -> PIMOIDAuthorizationRequest {
        let scopesList = [OIDScopeOpenID, OIDScopeProfile, OIDScopeEmail, OIDScopePhone, OIDScopeAddress, MARKETING_EMAIL_CONSENT_SCOPE]
        let appClientID = PIMSettingsManager.sharedInstance.getClientID()
        let appRedirectURI = PIMSettingsManager.sharedInstance.getRedirectURL()
        
        let request = PIMOIDAuthorizationRequest(configuration:
                pimOIDCConfiguration.oidcConfiguration()!,
                                              clientId: appClientID,
                                              scopes: scopesList,
                                              redirectURL: URL(string: appRedirectURI)!,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: parameter)
        return request
    }
}

class PIMOIDAuthorizationRequest : OIDAuthorizationRequest {
    
    override func authorizationRequestURL() -> URL {
        let url = super.authorizationRequestURL()
        let appinfraInstance = PIMSettingsManager.sharedInstance.appInfraInstance()
       
        let clpURL = appinfraInstance?.tagging.getVisitorIDAppend?(to: url) ?? url
        return clpURL;
    }
    
    func isRedirectURLValid(response:OIDAuthorizationResponse) -> Bool {
        let requestState = self.state
        let urlState = response.state
        var returnValue = false
        
        if requestState == urlState {
            returnValue = true
        }
        return returnValue
    }
    
}


extension PIMSettingsManager {
    
    func clearAuthRequest() {
        let aKey = PIMDefaults.userSubUUIDKey + PIMConstants.Keys.AUTH_FLOW_KEY
        PIMSettingsManager.sharedInstance.appinfra?.storageProvider.removeValue(forKey: aKey)
    }
    
    func provideSavedAuthRequest() -> PIMOIDAuthorizationRequest? {
        let aKey = PIMDefaults.userSubUUIDKey + PIMConstants.Keys.AUTH_FLOW_KEY
        var authFlow:PIMOIDAuthorizationRequest?
        do {
            authFlow = try PIMSettingsManager.sharedInstance.appinfra?.storageProvider.fetchValue(forKey: aKey) as? PIMOIDAuthorizationRequest
        } catch {
             PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMAuthManager", message: "No stored OAuth request")
        }
        self.clearAuthRequest()
        return authFlow;
    }
    
    func storeAuthRequest(authFlow:PIMOIDAuthorizationRequest?) {
        
        guard let aAuthFlow = authFlow else { return; }
        do {
            let aKey = PIMDefaults.userSubUUIDKey + PIMConstants.Keys.AUTH_FLOW_KEY
            try PIMSettingsManager.sharedInstance.appinfra?.storageProvider.storeValue(forKey: aKey , value: aAuthFlow)
          } catch {
             PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMAuthManager", message: "error storing oAuth request")
        }
    }
}
