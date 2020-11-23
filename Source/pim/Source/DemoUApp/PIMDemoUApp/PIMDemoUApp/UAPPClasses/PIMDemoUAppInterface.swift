//
//  PIMDemoUAppInterface.swift
//  PIMDemoUApp
//
//  Created by Chittaranjan Sahu on 2/27/19.
//Copyright © 2019 Philips. All rights reserved.
//

import UIKit
import UAPPFramework
import PIM

open class PIMDemoUAppInterface: NSObject, UAPPProtocol {
    private var appDependencies : PIMDependencies!
    var viewController:PIMDemoUAppViewController!
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        appDependencies = dependencies as? PIMDependencies
    }
    
    public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        
        let podBundle = Bundle(for: PIMDemoUAppInterface.self)
        let storyBoard = UIStoryboard(name:"Main", bundle:podBundle)
        viewController = storyBoard.instantiateViewController(withIdentifier: "PIMDemoUAppViewController") as? PIMDemoUAppViewController
        viewController?.pimAppDependencies = appDependencies
        viewController?.pimAppInfraHandler = appDependencies.appInfra
        viewController?.pimLaunchInput = launchInput as? PIMLaunchInput
        
        return viewController
    }
    
    public func handleRedirectURIInMicroapp(url:URL) {
        viewController.handleURL(link: url)
    }
}
