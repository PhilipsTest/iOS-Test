/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import MobileEcommerce

open class MECDemoUAppInterface: NSObject, UAPPProtocol {
    
    private var appDependencies : MECDependencies?
    private var launchInputs : MECDemoUAppLaunchInput?
    private var uAppSettings: MECSettings?
    
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        self.appDependencies = dependencies as? MECDependencies
        self.uAppSettings = settings as! MECSettings?
    }
    
    public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        
        let storyBoard = UIStoryboard(name:"Main", bundle: Bundle(identifier: "org.cocoapods.MobileEcommerceDemoUApp"))
        
        let viewController = storyBoard.instantiateViewController(withIdentifier: "MobileEcommerceDemoUAppViewController") as! MobileEcommerceDemoUAppViewController
        viewController.mecLaunchInput = launchInput as? MECLaunchInput
        viewController.mecAppInfraHandler = self.appDependencies?.appInfra
        viewController.userDataInterface = self.appDependencies?.userDataInterface
        viewController.mecSettings = self.uAppSettings
        viewController.mecAppDependencies = self.appDependencies

        return viewController
    }
}
