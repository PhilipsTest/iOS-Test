/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework

open class ECSTestUAppInterface: NSObject, UAPPProtocol {
    
    private var appDependencies : ECSTestUAppDependencies?
    private var launchInputs : ECSTestUAppLaunchInput?
    private var uAppSettings: ECSTestUAppSettings?
    
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        self.appDependencies = dependencies as? ECSTestUAppDependencies
        self.uAppSettings = settings as? ECSTestUAppSettings
        ECSTestDemoConfiguration.sharedInstance.sharedAppInfra = dependencies.appInfra
        ECSTestDemoConfiguration.sharedInstance.userDataInterface = appDependencies?.userDataInterface
        ECSTestDemoUtility.parseDisplayPlist()
    }
    
    public func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        
        let storyBoard = UIStoryboard(name: "ECSTestMicroservices", bundle: Bundle(for: type(of: self)))
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ECSTestMicroservicesGroupViewController") as? ECSTestMicroservicesGroupViewController
        return viewController
    }
}
