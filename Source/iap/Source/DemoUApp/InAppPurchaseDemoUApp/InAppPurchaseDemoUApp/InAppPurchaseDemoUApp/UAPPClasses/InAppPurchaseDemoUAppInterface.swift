/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import InAppPurchase

open class InAppPurchaseDemoUAppInterface: NSObject, UAPPProtocol {
    
    private var appDependencies : IAPDependencies?
    private var launchInputs : InAppPurchaseDemoUAppLaunchInput?
    private var uAppSettings: IAPSettings?
    
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        self.appDependencies = dependencies as? IAPDependencies
        self.uAppSettings = settings as! IAPSettings?
    }
    
    public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        
        let storyBoard = UIStoryboard(name:"Main", bundle: Bundle(identifier: "org.cocoapods.InAppPurchaseDemoUApp"))
        let viewController = storyBoard.instantiateViewController(withIdentifier: "InAppPurchaseDemoUAppViewController") as! InAppPurchaseDemoUAppViewController
        viewController.iapLaunchInput = launchInput as? IAPLaunchInput
        viewController.iapAppInfraHandler = self.appDependencies?.appInfra
        viewController.userDataInterface = self.appDependencies?.userDataInterface
        viewController.iapSettings = self.uAppSettings
        viewController.iapAppDependencies = self.appDependencies
        
        return viewController
    }
}
