/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import PhilipsProductRegistration
import PhilipsProductRegistrationUApp


class DemoProductRegistrationState: BaseState {
    var productRegistrationHandler : PPRDemoFrameworkInterface?
    var productRegistrationViewController : UIViewController?
    var productRegistrationDependencies : PPRInterfaceDependency?
    var productRegistrationLaunchInput : PPRDemoFrameworkLaunchInput?
    
    
    
    
    override init() {
        super.init(stateId : AppStates.DemoProductRegistrationState)
    }
    
    ///Set/Update the CoCo inputs and get the viewController to be navigated to
    override func getViewController() -> UIViewController? {
        setUpProductRegistrationDemoHandler()
        setUpProductRegistrationDemoLaunchInput()
        if let launchInput = productRegistrationLaunchInput{
               productRegistrationViewController = productRegistrationHandler?.instantiateViewController(launchInput, withErrorHandler: nil)
            return productRegistrationViewController
        }
        return nil
    }
    
    private func setUpProductRegistrationDemoHandler() {
        guard productRegistrationHandler == nil else{
            return
        
        }
        productRegistrationDependencies = PPRInterfaceDependency()
        productRegistrationDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        productRegistrationDependencies?.userDataInterface = UserDataInterfaceInstance.sharedInstance.userDataInterface
        if let dependency = productRegistrationDependencies{
         productRegistrationHandler = PPRDemoFrameworkInterface(dependencies:dependency, andSettings: nil)
        }
    }
    
    private func setUpProductRegistrationDemoLaunchInput() {
        guard productRegistrationLaunchInput == nil else{
            return
        }
        productRegistrationLaunchInput = PPRDemoFrameworkLaunchInput()
    }

}


