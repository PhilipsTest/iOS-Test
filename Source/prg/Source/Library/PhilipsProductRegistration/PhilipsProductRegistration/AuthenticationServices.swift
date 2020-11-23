//
//  AuthenticationServices.swift
//  PhilipsProductRegistration
//
//  Created by Shravan Kumar on 28/01/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import Foundation
import PlatformInterfaces
import SafariServices
import AuthenticationServices

class SafariExtensionFactory {
    
    static func provideAuthenticationService() -> AuthenticationServices {
        var authentication: AuthenticationServices!
        if #available(iOS 12.0, *) {
            authentication = ASWebAuthenticationWrapper()
        } else {
            authentication = SFWebAuthenticationWrapper()
        }
        return authentication
    }
}

//Protocol for authentication services
protocol AuthenticationServices {
    
    var safariSession:Any? { get }
    var userCancelError:NSError! { get }
    
    func initiateSession(url:URL,callBackURL:String,completionHandler:@escaping ((URL?,Error?) -> ()))
    func startSession()
    func cancelSession()
}

class SFWebAuthenticationWrapper: NSObject, AuthenticationServices {
    var safariSession: Any?
    var userCancelError:NSError!
    
    func initiateSession(url: URL, callBackURL: String, completionHandler: @escaping ((URL?, Error?) -> ())) {
        self.userCancelError = NSError(domain: "com.apple.SafariServices.Authentication", code: 1, userInfo: nil)
        self.safariSession = SFAuthenticationSession(url: url, callbackURLScheme: callBackURL, completionHandler: completionHandler)
    }
    
    func startSession() {
        (self.safariSession as! SFAuthenticationSession).start()
    }
    
    func cancelSession() {
        (self.safariSession as! SFAuthenticationSession).cancel()
    }
        
}


@available(iOS 12.0, *)
class ASWebAuthenticationWrapper: NSObject, AuthenticationServices, ASWebAuthenticationPresentationContextProviding {
    
    var safariSession: Any?
    var userCancelError:NSError!
    
    func initiateSession(url: URL, callBackURL: String, completionHandler: @escaping ((URL?, Error?) -> ())) {
        self.userCancelError = NSError(domain: "com.apple.AuthenticationServices.WebAuthenticationSession", code: 1, userInfo: nil)
        self.safariSession = ASWebAuthenticationSession(url: url, callbackURLScheme:callBackURL , completionHandler: completionHandler)
        if #available(iOS 13.0, *) {
            (self.safariSession as! ASWebAuthenticationSession).presentationContextProvider = self
            (self.safariSession as! ASWebAuthenticationSession).prefersEphemeralWebBrowserSession = false
        }
    }
    
    func startSession() {
        (self.safariSession as! ASWebAuthenticationSession).start()
    }
    
    func cancelSession() {
        (self.safariSession as! ASWebAuthenticationSession).cancel()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return (UIApplication.shared.delegate?.window ?? ASPresentationAnchor()) ?? ASPresentationAnchor()
    }
    
}
