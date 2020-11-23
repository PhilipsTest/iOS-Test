/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import SafariServices
import PhilipsUIKitDLS
import AuthenticationServices

class PIMProfileViewController: UIViewController {
    
    private var authSession:AuthenticationServices!
    @IBOutlet weak var progressIndicator: UIDProgressIndicator!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAccountURL()
        self.title = "PIM_MyDetails_TitleTxt".localiseString(args: [])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:
    //MARK: Private methods.
    
    private func loadAuthenticationView(url:URL) {
        let redirectURI = PIMSettingsManager.sharedInstance.getRedirectURL()
        progressIndicator.startAnimating()
        
        //Auth session
        self.authSession = AuthenticationServiceFactory.provideAuthenticationService()
        authSession.initiateSession(url: url, callBackURL: redirectURI, completionHandler: { url, error in
            self.handleWebInstanceCompletionHandler(url: url, error: error)
        })
        self.authSession.startSession()
    }
    
    private func handleWebInstanceCompletionHandler(url:URL?,error:Error?) {
         self.progressIndicator.stopAnimating()
        let cancelError = self.authSession.userCancelError
        guard let aError = error, (aError as NSError).code == cancelError?.code , (aError as NSError).domain == cancelError?.domain else {
             return
         }
         self.navigationController?.popViewController(animated: true)
    }
    
    private func fetchAccountURL() {
        let settingsManager = PIMSettingsManager.sharedInstance
        settingsManager.getPIMSDURL(forKey: PIMConstants.ServiceIDs.JANRAIN_USER_PROFILE, completionHandler: {
          urlString, error in
            guard error == nil else {
                PIMUtilities.showErrorAlertController(error: error, presentationView: self)
                return
            }
            
            guard var aString = urlString else {
                PIMUtilities.showErrorAlertController(error: PIMErrorBuilder.getNoSDURLError(), presentationView: self)
                return
            }
            let locale = settingsManager.getLocale() ?? ""
            aString = aString.replacingOccurrences(of: "%id%", with: settingsManager.getClientID())
            aString = aString.replacingOccurrences(of: "%locale%", with: locale)
            
            guard let aURL = URL(string: aString) else {
                PIMUtilities.showErrorAlertController(error: PIMErrorBuilder.getNoSDURLError(), presentationView: self)
                return
            }
            
            self.loadAuthenticationView(url: aURL)
            
        } , replacement: nil)
    }
    
}


class AuthenticationServiceFactory {
    
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
    
    var authSession:Any? { get }
    var userCancelError:NSError! { get }
    
    func initiateSession(url:URL,callBackURL:String,completionHandler:@escaping ((URL?,Error?) -> ()))
    func startSession()
    func cancelSession()
}

class SFWebAuthenticationWrapper: NSObject, AuthenticationServices {
    var authSession: Any?
    var userCancelError:NSError!
    
    func initiateSession(url: URL, callBackURL: String, completionHandler: @escaping ((URL?, Error?) -> ())) {
        self.userCancelError = NSError(domain: "com.apple.SafariServices.Authentication", code: 1, userInfo: nil)
        self.authSession = SFAuthenticationSession(url: url, callbackURLScheme: callBackURL, completionHandler: completionHandler)
    }
    
    func startSession() {
        (self.authSession as! SFAuthenticationSession).start()
    }
    
    func cancelSession() {
        (self.authSession as! SFAuthenticationSession).cancel()
    }
        
}


@available(iOS 12.0, *)
class ASWebAuthenticationWrapper: NSObject, AuthenticationServices, ASWebAuthenticationPresentationContextProviding {
    
    var authSession: Any?
    var userCancelError:NSError!
    
    func initiateSession(url: URL, callBackURL: String, completionHandler: @escaping ((URL?, Error?) -> ())) {
        self.userCancelError = NSError(domain: "com.apple.AuthenticationServices.WebAuthenticationSession", code: 1, userInfo: nil)
        self.authSession = ASWebAuthenticationSession(url: url, callbackURLScheme:callBackURL , completionHandler: completionHandler)
        if #available(iOS 13.0, *) {
            (self.authSession as! ASWebAuthenticationSession).presentationContextProvider = self
            (self.authSession as! ASWebAuthenticationSession).prefersEphemeralWebBrowserSession = false
        }
    }
    
    func startSession() {
        (self.authSession as! ASWebAuthenticationSession).start()
    }
    
    func cancelSession() {
        (self.authSession as! ASWebAuthenticationSession).cancel()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return (UIApplication.shared.delegate?.window ?? ASPresentationAnchor()) ?? ASPresentationAnchor()
    }
    
}

