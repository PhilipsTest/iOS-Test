/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

class IAPHttpConnectionInterface {
    fileprivate var httpConnection: HttpConnection!
    fileprivate var url: String!
    fileprivate var httpHeaders: [String: String]?
    fileprivate var bodyParameters: [String: String]?
    fileprivate var methodName: String!
    fileprivate var successCompletion: (([String: AnyObject]) -> ())!
    fileprivate var errorFailure:((NSError) -> ())!
    
    fileprivate var oldJAnrainToken:String!
    
    init(request: String,
         httpHeaders: [String: String]?,
         bodyParameters: [String: String]?,
         success: @escaping ([String: AnyObject]) -> (), failure: @escaping (NSError) -> ()){
        self.initialiseObject(request, withHTTPHeaders: httpHeaders, withBodyParameters: bodyParameters)
        self.successCompletion = success
        self.errorFailure = failure
    }
    
    init(request:String, httpHeaders: [String: String]?, bodyParameters: [String: String]?) {
        self.initialiseObject(request, withHTTPHeaders: httpHeaders, withBodyParameters: bodyParameters)
    }
    
    func setFailurHandler(_ inErrorHandler: @escaping (NSError)->()) {
        self.errorFailure = inErrorHandler
    }
    
    func setSuccessCompletion(_ inSuccessCompletion: @escaping ([String: AnyObject]) -> ()) {
        self.successCompletion = inSuccessCompletion
    }
    
    func getCompletionClosure() -> ([String: AnyObject]) -> () {
        return self.successCompletion
    }
    
    func getFailureClosure() -> (NSError)->() {
        return self.errorFailure
    }
    
    func initialiseObject(_ withURL: String, withHTTPHeaders: [String: String]?, withBodyParameters: [String: String]?) {
        var passedURLString = String(withURL)
        self.url = passedURLString.appendedLanguageURL()
        self.httpConnection = HttpConnection()
        
        if let parameters = withHTTPHeaders {
            self.httpHeaders = parameters
        }
        
        if let parameters = withBodyParameters {
            self.bodyParameters = parameters
        }
    }
    
    func setHttpConnection(_ newHttpConnection: HttpConnection) {
        self.httpConnection = newHttpConnection
    }
    
    func performGetRequest() {
        self.methodName = "GET"
        self.httpConnection.performRequestAsynchronously(self.url, method: self.methodName,
                                                         httpHeaders: self.httpHeaders,
                                                         bodyParameters: nil,
                                                         success: self.successCompletion,
                                                         failure: { (inError:NSError) -> () in
            self.handleError(inError)
        })
    }
    
    func performPutRequest() {
        self.methodName = "PUT"
        self.httpConnection.performRequestAsynchronously(self.url, method: self.methodName,
                                                         httpHeaders: self.httpHeaders,
                                                         bodyParameters:self.bodyParameters,
                                                         success: self.successCompletion,
                                                         failure: { (inError:NSError) -> () in
            self.handleError(inError)
        })
    }
    
    func performPostRequest() {
        self.methodName = "POST"
        self.httpConnection.performRequestAsynchronously(self.url,
                                                         method: self.methodName,
                                                         httpHeaders: self.httpHeaders,
                                                         bodyParameters: self.bodyParameters,
                                                         success: self.successCompletion,
                                                         failure: { (inError:NSError) -> () in
            self.handleError(inError)
        })
    }
    
    func performDeleteRequest() {
        self.methodName = "DELETE"
        self.httpConnection.performRequestAsynchronously(self.url,
                                                         method: self.methodName,
                                                         httpHeaders: self.httpHeaders,
                                                         bodyParameters: nil,
                                                         success: self.successCompletion,
                                                         failure: { (inError:NSError) -> () in
            self.handleError(inError)
        })
    }
    
    func performOAuthRequest(_ isFromError:Bool = false) {
        self.methodName = "POST"
        self.httpConnection.performRequestAsynchronously(self.url,
                                                         method: self.methodName,
                                                         httpHeaders: self.httpHeaders,
                                                         bodyParameters: self.bodyParameters,
                                                         success: self.successCompletion,
                                                         failure: { (inError:NSError) -> () in
            guard false == isFromError else { self.errorFailure(inError); return }
            self.handleError(inError)
        })
    }
    
    func getErrorDescription(_ inError:NSError, forKey:String) -> String? {
        var exceptionType:String!
        let errorOAuthException =  inError.userInfo
        if let errorInfoDict = (errorOAuthException["Error_Info_Dict"] as? [String: AnyObject]){
            if let errorArray = errorInfoDict["errors"] as? [AnyObject] {
                if let exceptionReturned = errorArray[0][forKey] as? String {
                    exceptionType = exceptionReturned
                }
            }
        }
        return exceptionType
    }
    
    // MARK: First level error handling
    func handleError(_ inError:NSError) {
        let exceptionType = self.getErrorDescription(inError,forKey: IAPConstants.IAPErrorComponents.kErrorTypeKey)
        guard exceptionType != IAPConstants.IAPJanrainTokenErrors.kInvalidAccessToken else { self.sendReOAuthRequestWithURL(); return }
        guard exceptionType != IAPConstants.IAPJanrainTokenErrors.kInvalidGrantError else { self.refreshLoginSession(); return }
        guard exceptionType != IAPConstants.IAPHybrisUnknownErrorKeys.kIllegalArgumentError else { return }
        self.errorFailure(inError)
    }
    
    fileprivate func refreshLoginSession() {
        self.oldJAnrainToken = IAPConfiguration.sharedInstance.getJanrinAccessToken()
        IAPConfiguration.sharedInstance.log(.error, eventId: "IAPHTTPInterface", message: "Trying to refresh login session")
        IAPOAuthInvalidTokenHandler.sharedInstance.scheduleLoginRefresh({
            self.retryOAuthRequest()
        }) { (inError:NSError) in
            self.errorFailure(inError)
        }
    }
    
    // MARK:
    // MARK: Re-OAuth Methods
    // MARK:
    func sendReOAuthRequestWithURL() {
        
        if let accessToken = IAPConfiguration.sharedInstance.getJanrinAccessToken(){
        let oauthManager = IAPOAuthDownloadManager(janRainAccessToken: accessToken, isFromError: true)
        IAPOAuthInvalidTokenHandler.sharedInstance.scheduleOAuthRefresh(oauthManager!, withCompletion: { (oauth: IAPOAuthInfo) in
            self.retryRequest()
        }) { (inError:NSError) -> () in
            IAPConfiguration.sharedInstance.log(.error,
                                                                       eventId: "IAPHTTPInterface", message:
                "\n\n *** Refresh OAuth download error: \(#file)->\(#function)->\(#line): \n\n *** Refresh OAuth Error Description:: \(inError)")
            self.handleReOAuthFailure(inError, withOAuthManager:oauthManager)
        }
        }
    }
    
    // MARK: Second level error handling
    fileprivate func handleReOAuthFailure(_ inError:NSError, withOAuthManager:IAPOAuthDownloadManager?) {
        //Check if internet connection error is the reason
        guard IAPConstants.IAPNoInternetError.kNoInternetCode != inError.code else { self.errorFailure(inError); return }
        
        //refresh token has expired so we need to refetch OAuth
        let httpInterface = withOAuthManager?.getInterfaceForOAuth()
        withOAuthManager?.getOAuthTokenWithInterface(httpInterface!, successCompletion: {(oauthInfo:IAPOAuthInfo) -> () in
            self.retryRequest()
        }) { (inError:NSError) in
            IAPConfiguration.sharedInstance.log(.error, eventId: "IAPHTTPInterface", message:
            "\n\n *** New OAuth and refresh Token download Error: \(#file)->\(#function)->\(#line): \n\n *** New OAuth and refresh Token Error Description:: \(inError)")
            
            // Check if internet connection error is the reason
            guard IAPConstants.IAPNoInternetError.kNoInternetCode != inError.code else { self.errorFailure(inError); return }
            // janrain token has expired
            self.refreshLoginSession()}
    }
    
    func retryRequest() {
        self.httpHeaders = IAPOAuthInfo.httpHeadersParameterDictForOCCRequest()
        self.httpConnection.performRequestAsynchronously(self.url,
                                                         method: self.methodName,
                                                         httpHeaders: self.httpHeaders,
                                                         bodyParameters: self.bodyParameters,
                                                         success: { (inDict: [String: AnyObject]) in
                self.successCompletion(inDict)
                IAPOAuthInvalidTokenHandler.sharedInstance.resetRefeshing(nil)
                IAPOAuthInvalidTokenHandler.sharedInstance.resetLoginRefreshing(nil)
            }, failure: { (inError: NSError) in
                IAPConfiguration.sharedInstance.log(.error, eventId: "IAPHTTPInterface", message:
                "\n\n *** Retry request error: \(#file)->\(#function)->\(#line): \n\n *** Retry request Error Description:: \(inError)")
                self.errorFailure(inError)
                IAPOAuthInvalidTokenHandler.sharedInstance.resetRefeshing(inError)
                IAPOAuthInvalidTokenHandler.sharedInstance.resetLoginRefreshing(inError)
            })
    }
    
    // MARK:
    // MARK: Invalid Janrain Token Methods
    // MARK:
    func retryOAuthRequest() {
        if let accessToken = IAPConfiguration.sharedInstance.getJanrinAccessToken(){
        let oauthManager = IAPOAuthDownloadManager(janRainAccessToken: accessToken)
        let httpInterface = oauthManager?.getInterfaceForOAuth()
        guard false == self.url.contains(IAPConstants.IAPOauthURLKeys.kJanrainTokenStartKey) else {
            oauthManager?.getOAuthTokenWithInterface(httpInterface!,successCompletion: { (inOauth: IAPOAuthInfo) in
                IAPOAuthInvalidTokenHandler.sharedInstance.resetRefeshing(nil)
                let oauthDictionary: [String: AnyObject] =
                    [IAPConstants.IAPOAuthAccessTokenKeys.kAccessTokenKey: inOauth.accessToken as AnyObject,
                    IAPConstants.IAPOAuthAccessTokenKeys.kRefreshTokenKey: inOauth.refreshToken as AnyObject,
                    IAPConstants.IAPOAuthAccessTokenKeys.kTokenTypeKey: inOauth.tokenType as AnyObject]
                self.successCompletion(oauthDictionary)
                IAPOAuthInvalidTokenHandler.sharedInstance.resetLoginRefreshing(nil)
            }) {(inError: NSError) in
                IAPConfiguration.sharedInstance.log(.error, eventId: "IAPHTTPInterface", message:
                "\n\n *** Getting First OAuth error after login refresh: \(#file)->\(#function)->\(#line): \n\n *** Getting First OAuth error after login refresh Error Description:: \(inError)")
                self.errorFailure(inError)
                IAPOAuthInvalidTokenHandler.sharedInstance.resetRefeshing(inError)
                IAPOAuthInvalidTokenHandler.sharedInstance.resetLoginRefreshing(inError)
            }
            return
        }
        oauthManager?.getOAuthTokenWithInterface(httpInterface!, successCompletion: {(inOauth:IAPOAuthInfo) in
            self.retryRequest()
            }) { (inError:NSError) in
                IAPConfiguration.sharedInstance.log(.error, eventId: "IAPHTTPInterface", message:
                "\n\n *** Getting New OAuth error after login refresh: \(#file)->\(#function)->\(#line): \n\n *** Getting New OAuth error after login refresh Error Description:: \(inError)")
                self.errorFailure(inError)
                IAPOAuthInvalidTokenHandler.sharedInstance.resetRefeshing(inError)
                IAPOAuthInvalidTokenHandler.sharedInstance.resetLoginRefreshing(inError)
            }
        }
    }
}
