/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import PhilipsRegistrationMicroApp

class DemoUserRegistrationState: BaseState {
    
    var userRegistrationHandler : DemoUAppInterface?
    var demoUserRegistrationViewController : UIViewController?
    var userRegistrationDependencies : DemoUAppDependencies?
    var userRegistrationLaunchInput : DemoUAppLaunchInput?
    
    override init() {
        super.init(stateId : AppStates.DemoUserRegistrationState)
    }
    
    ///Set/Update the CoCo inputs and get the viewController to be navigated to
    override func getViewController() -> UIViewController? {
        setUpUserRegistrationDemoHandler()
        setUpUserRegistrationDemoLaunchInput()
        if let launchInput = userRegistrationLaunchInput {
            demoUserRegistrationViewController = userRegistrationHandler?.instantiateViewController(launchInput, withErrorHandler: nil)
            return demoUserRegistrationViewController
        }
        return nil
    }
    
    private func setUpUserRegistrationDemoHandler() {
        guard userRegistrationHandler == nil else {
            return
        }
        userRegistrationDependencies = DemoUAppDependencies()
        userRegistrationDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        if let dependency = userRegistrationDependencies{
            userRegistrationHandler = DemoUAppInterface(dependencies: dependency, andSettings: nil)
            
        }
        
    }
    
   private func setUpUserRegistrationDemoLaunchInput() {
        guard userRegistrationLaunchInput == nil else {
            return
        }
        userRegistrationLaunchInput = DemoUAppLaunchInput()
    }
    
}


