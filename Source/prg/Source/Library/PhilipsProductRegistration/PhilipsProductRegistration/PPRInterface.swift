//
//  PPRInterface.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 18/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import Foundation
import UAPPFramework
import PlatformInterfaces
import SafariServices
import AuthenticationServices

/// This public class is entry point for Product Registration. All required properties need to be initialized at the time of launch.
/// - Since: 1.0.0
@objc public class PPRInterface: NSObject, UAPPProtocol {
    
    private var safariSession:AuthenticationServices?
    
    /// Documenting UAPPProtocol
    ///
    /// - Parameters:
    ///   - launchInput: Instance of UAPPLaunchInput class for setting the parameters needed for launch of UAPP
    ///   - completionHandler: Block for handling error
    /// - Returns: Returns an instance of UApp's UIViewController which will be used for launching the UApp
    /// - Since: 1.0.0
    @objc public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        
        let launchInput = launchInput as! PPRLaunchInput
        
        //If user is not logged in, return nil
        guard let userDataInterface = PPRInterfaceInput.sharedInstance.appDependency.userDataInterface else {
            let err = NSError(domain: NSURLErrorDomain, code: PPRError.USER_DATA_INTERFACE_NIL.rawValue, userInfo: nil)
            completionHandler?(err)
          return nil
        }
        
        if userDataInterface.loggedInState().rawValue <= UserLoggedInState.pendingVerification.rawValue {
            let err = NSError(domain: NSURLErrorDomain, code: PPRError.USER_NOT_LOGGED_IN.rawValue, userInfo: nil)
            completionHandler?(err)
            return nil
        }
        
        if launchInput.productInfo == nil || launchInput.launchConfiguration == nil {
            let err = NSError(domain: NSURLErrorDomain, code: PPRError.INPUT_VALIDATION_FAILED.rawValue, userInfo: nil)
            completionHandler?(err)
            return nil
        }
        
        let viewController = PPRProductRegistrationUIHelper.instantiateUI(products: launchInput.productInfo!, configuration: launchInput.launchConfiguration!, delegate: launchInput.userInterfacedelegate)
        PPRInterfaceInput.sharedInstance.pprCompletionHandler = completionHandler
        return viewController
    }

    /// Called when Product Registration module is invoked.
    ///
    /// - Parameters:
    ///   - dependencies: Object of UAppDependencies class for injecting Dependencies needed by UApp
    ///   - settings: Object of UAPPSettings class for injecting one time initialisation parameters needed for UAPP initialisation
    /// - Since: 1.0.0
    @objc required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        if let inDependencies = dependencies as? PPRInterfaceDependency {
            _ = PPRInterfaceInput.setup(inDependencies)
            let interfaceInput: PPRInterfaceInput = PPRInterfaceInput.sharedInstance
            interfaceInput.appDependency = inDependencies
            interfaceInput.appSettings = settings
        }
    }
    
    @objc public func launchCounterFeitPage() {
        self.safariSession = SafariExtensionFactory.provideAuthenticationService()
        let urlString = PPRURLConstants.COUNTERFIET_URL
        let url = URL(string: urlString)
        self.safariSession?.initiateSession(url: url!, callBackURL: urlString, completionHandler: { url, error in
            
        })
        self.safariSession?.startSession()
    }
}




