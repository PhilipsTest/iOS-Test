/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
//import PhilipsRegistration

internal class IAPOAuthDownloadManager {

    fileprivate var reOAuthurl:String?
    fileprivate var janRainAccessToken:String!
    fileprivate var oAuthgrantType:String!
    fileprivate var reOAuthgrantType:String!
    fileprivate var isFromAPIError:Bool!

    convenience init?(janRainAccessToken:String, isFromError:Bool = false){
        guard janRainAccessToken.length>0 else {return nil}
        self.init()
        self.isFromAPIError = isFromError
        self.janRainAccessToken = janRainAccessToken
        self.reOAuthgrantType = IAPConstants.IAPOAuthParameterKeys.kReOAuthGrantType
        let userDataInterface = IAPConfiguration.sharedInstance.sharedUDInterface
        if let uAppDataInterface = userDataInterface {
            self.oAuthgrantType = uAppDataInterface.isOIDCToken() ? IAPConstants.IAPOAuthParameterKeys.kOAuthGrantTypeOIDC : IAPConstants.IAPOAuthParameterKeys.kOAuthGrantTypeJanrain
        }
    }
    
    func getJanRainAccessToken()->String {
        return self.janRainAccessToken
    }
    
    func getOAuthGrantType()->String {
        return self.oAuthgrantType
    }
    
    func getReOAuthGrantType()->String {
        return self.reOAuthgrantType
    }

    func getBaseURL()->String {
        return String(format: "%@/authorizationserver/oauth/token",
                      arguments: [IAPOAuthConfigurationData.getBaseURL()])
    }
    
    func getReOAuthUrl()->String {
        self.reOAuthurl = String(format:"%@/authorizationserver/oauth/token",
            arguments: [IAPOAuthConfigurationData.getBaseURL()])
        return self.reOAuthurl!
    }
    
    func getOAuthTokenWithInterface(_ interface: IAPHttpConnectionInterface, successCompletion:@escaping (IAPOAuthInfo)->(), errorFailure:@escaping (NSError)->()) {
        interface.setSuccessCompletion({ (data: [String: AnyObject]) -> () in
            let oauthModel = IAPOAuthInfo(inDictionary: data)
            IAPConfiguration.sharedInstance.setOauth(oauthModel)
            successCompletion(oauthModel)
        })
        interface.setFailurHandler({(error:NSError) -> () in errorFailure(error)})
        interface.performOAuthRequest(self.isFromAPIError)
    }
    
    func getInterfaceForOAuth(_ withReAuth:Bool = false) -> IAPHttpConnectionInterface {
        var urlString = ""
        let parameterDictionary = self.authorisationParameterForOAuth()
        let bodyParameterDictionary = self.constructOauthBodyParameter(reAuth: withReAuth)
        
        if withReAuth {
            urlString = self.constructReOAuthUrl()
        } else {
            urlString = self.constructedOAuthURL()
        }

        let httpConnectionInterface = IAPHttpConnectionInterface(request: urlString, httpHeaders: parameterDictionary, bodyParameters: bodyParameterDictionary)
        return httpConnectionInterface
    }
    
    func constructedOAuthURL()->String {
        return String(format: self.getBaseURL(), arguments: [self.getJanRainAccessToken(),self.getOAuthGrantType()])
    }
    
    func constructReOAuthUrl()-> String {
        return String(format: self.getReOAuthUrl(), arguments: [self.getJanRainAccessToken(),self.getReOAuthGrantType()])
    }
    
    func authorisationParameterForOAuth()-> [String: String] {
        let loginHeaderParam = IAPConfiguration.sharedInstance.sharedAppInfra.appIdentity.getAppState() == .PRODUCTION ? IAPConstants.IAPOAuthParameterKeys.kLoginStringKeyProduction : IAPConstants.IAPOAuthParameterKeys.kLoginStringKeyAcceptance
        let apiLoginString = NSString(format: loginHeaderParam as NSString);
        let apiLoginData: Data = apiLoginString.data(using: String.Encoding.utf8.rawValue)!;
        let base64ApiLoginString = apiLoginData.base64EncodedString(options: []);
        let stringValue = IAPConstants.IAPOAuthParameterKeys.kBasicKey + base64ApiLoginString
        return Dictionary(dictionaryLiteral: (IAPConstants.IAPOAuthParameterKeys.kAuthorisationKey,stringValue))
    }
    
    func constructOauthBodyParameter(reAuth:Bool) -> [String: String] {
        let appState = IAPConfiguration.sharedInstance.sharedAppInfra.appIdentity.getAppState()
        var bodyParameter: [String: String] = ["client_id": "inApp_client",
                                               "grant_type": self.oAuthgrantType]
        bodyParameter["client_secret"] = appState == .PRODUCTION ? "prod_inapp_54321" : "acc_inapp_12345"
        
        if reAuth {
            bodyParameter["refresh_token"] = IAPOAuthInfo.oAuthInfo().refreshToken
        } else {
            bodyParameter[self.oAuthgrantType] = self.getJanRainAccessToken()
        }
        
        return bodyParameter
    }
    
}
