/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import ECSTestUApp

class TestEcommerceState: BaseState {

    var ecsTestHandler : ECSTestUAppInterface?
    var ecsTestViewController : UIViewController?
    var ecsTestDependencies : ECSTestUAppDependencies?
    var ecsTestLaunchInput : ECSTestUAppLaunchInput?
    var ecsTestSettings : ECSTestUAppSettings?
    
    override init() {
        super.init(stateId : AppStates.TestEcommerceState)
    }
    
    ///Set/Update the CoCo inputs and get the viewController to be navigated to
    override func getViewController() -> UIViewController? {
        setUpECSTestDemoHandler()
        setUpECSTestDemoLaunchInput()
        if let launchInput = ecsTestLaunchInput {
            ecsTestViewController = ecsTestHandler?.instantiateViewController(launchInput, withErrorHandler: nil)
            
            return ecsTestViewController
        }
        return nil
    }
    
    private func setUpECSTestDemoHandler() {
        guard ecsTestHandler == nil else {
            return
        }
        ecsTestDependencies = ECSTestUAppDependencies()
        ecsTestDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        ecsTestDependencies?.userDataInterface = UserDataInterfaceInstance.sharedInstance.userDataInterface
        ecsTestSettings = ECSTestUAppSettings()
        if let ecsTestDependency = ecsTestDependencies {
            ecsTestHandler = ECSTestUAppInterface(dependencies: ecsTestDependency, andSettings: ecsTestSettings)
        }
    }
    
    private func setUpECSTestDemoLaunchInput() {
        if ecsTestLaunchInput != nil{
            return
        }
        ecsTestLaunchInput = ECSTestUAppLaunchInput()
    }
    
}
