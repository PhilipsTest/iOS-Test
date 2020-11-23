/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppInfra
import AppAuth

class PIMMigrator : NSObject {
    
    private var completionHandler:((NSError?,PIMUserProfileResponse?) -> ()?)?
    
    override init() {
        super.init()
    }
    
    func migrateUserToPIM(token:String,completionHandler: @escaping (NSError?,PIMUserProfileResponse?) -> ()) {
        
        self.completionHandler = completionHandler
        
        guard let restClientInterface =
            PIMSettingsManager.sharedInstance.restClientInterface() else {
                completionHandler(PIMErrorBuilder.getNoSDURLError(),nil);
                return
        }
        
        PIMSettingsManager.sharedInstance.getPIMSDURL(forKey: PIMConstants.ServiceIDs.JANRAIN_USER_MIGRATION , completionHandler: { (urlString, inError) in
            guard inError == nil else {
                let error = PIMErrorBuilder.getNoSDURLError()
                completionHandler(error, nil)
                return
            }
            guard let urlReceived = urlString else {
                let error = PIMErrorBuilder.getNoSDURLError()
                completionHandler(error,nil)
                return
            }
            let request = PIMMigrationRequest(withAccessToken: token, url: urlReceived)
            let restclient = PIMRestClient(restClientInterface)
            
            restclient.invokeRequest(request, completionHandler: {
                responese,aObject,error in
                guard let httpResponse = responese, httpResponse.isKind(of: HTTPURLResponse.self) else {
                    completionHandler(PIMErrorBuilder.getNoSDURLError(),nil);
                    return
                }
                
                guard (httpResponse as! HTTPURLResponse).statusCode == 200 else {
                    PIMUtilities.logMessage(.debug, eventId: "PIMMIgrator", message: "Migrator status code is not 200 \(String(describing: error?.localizedDescription))")
                    completionHandler(PIMErrorBuilder.buidNetworkError(httpCode: (httpResponse as! HTTPURLResponse).statusCode),nil);
                    return
                }
                
                guard let tokenString = (((aObject as! NSDictionary)["data"]) as! NSDictionary)["identityAssertion"]  else {
                    PIMUtilities.logMessage(.debug, eventId: "PIMMigrator", message: "Token string was not able to fetch from the response. \(String(describing: error?.localizedDescription))")
                    let error = PIMErrorBuilder.buildPIMMigrationError()
                    completionHandler(error,nil);
                    return
                }
                self.handleMigrationAuthorization(withToken: tokenString as! String, restClient: restclient)
            })
        }, replacement: nil)
        
    }
    
    private func handleMigrationAuthorization(withToken token:String, restClient: PIMRestClient) {
        
        PIMAuthManager().provideMigrationRequest(withToken: token, completionHandler: { authRequest, error in
            guard let url = authRequest?.authorizationRequestURL() else {
                let error = PIMErrorBuilder.buildPIMMigrationError()
                self.completionHandler?(error,nil)
                return
            }
            let request = PIMMigrationAuthRequest(url: url)
            restClient.invokeRedirectRequest(request, completionHandler: {
                responese,aObject,error in
                
                guard error == nil else {
                    let code = ((responese as? HTTPURLResponse)?.statusCode ?? PIMMappedError.PIMOIDErrorCodeOAuthRegistrationInvalidRedirectURI.rawValue)
                    let error = PIMErrorBuilder.buidNetworkError(httpCode:code)
                    self.completionHandler?(error,nil)
                    return
                }
                
                guard let urlString = (responese as! HTTPURLResponse).allHeaderFields["Location"] else {
                    let error = PIMErrorBuilder.buildPIMMigrationError()
                    self.completionHandler?(error,nil)
                    return
                }
                let authURL = urlString as! String
                self.performTokenRequest(withAppAuthCode:authURL, authRequest: authRequest!)
            } )
        })
    }
    
    private func performTokenRequest(withAppAuthCode:String,authRequest:OIDAuthorizationRequest) {
        guard let appAuthCode = self.getAppAuthCode(responseURL: withAppAuthCode) else {
            let error = PIMErrorBuilder.buildPIMMigrationError()
            self.completionHandler?(error,nil)
            return
        }
        let authReponse = OIDAuthorizationResponse(request: authRequest, parameters:["code":appAuthCode])
        let tokenRequest = authReponse.tokenExchangeRequest()
        OIDAuthorizationService.perform(tokenRequest!,callback: {
            tokenResponse, error in
            guard error == nil else {
                let code = ((error as NSError?)?.code ?? PIMMappedError.PIMMigrationFailedError.rawValue)
                self.completionHandler?(PIMErrorBuilder.buidNetworkError(httpCode:code),nil);
                return
            }
            
            guard let aTokenResponse = tokenResponse else {
                self.completionHandler?(PIMErrorBuilder.buildPIMMigrationError(),nil);
                return
            }
            self.fetchUserProfile(tokenResponse: aTokenResponse, authResponse: authReponse)
        })
    }
    
    private func fetchUserProfile(tokenResponse:OIDTokenResponse, authResponse:OIDAuthorizationResponse) {
        let appAuth = OIDAuthState(authorizationResponse: authResponse, tokenResponse: tokenResponse)
        let userManager = PIMSettingsManager.sharedInstance.pimUserManagerInstance()
        userManager.requestUserProfile(appAuth, completion: {
            userResponse,error in
            guard error == nil else {
                let code = ((error as NSError?)?.code ?? PIMMappedError.PIMMigrationFailedError.rawValue)
                self.completionHandler?(PIMErrorBuilder.buidNetworkError(httpCode:code),nil);
                return
            }
            
            guard let aUserResponse = userResponse else {
                self.completionHandler?(PIMErrorBuilder.buildPIMMigrationError(),nil);
                return
            }
            
            self.completionHandler?(nil,aUserResponse)
        })
    }
    
    private func getAppAuthCode(responseURL:String) -> NSString? {
        var codeString:NSString?
        let codeRange = (responseURL as NSString).range(of: "code")
        if ((codeRange.location == NSNotFound) || (codeRange.length == 0)) {
            return codeString
        }
        let aCodeString = (responseURL as NSString).substring(from: (codeRange.location + codeRange.length + 1)) as NSString
        let stateRange = aCodeString.range(of: "state")
        if ((stateRange.location == NSNotFound) || (stateRange.length == 0)) {
            return codeString
        }
        codeString = aCodeString.substring(to: stateRange.location - 1) as NSString?
        return codeString
    }
    
}
