/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import UIKit
import MobileEcommerceDemoUApp
import MobileEcommerce
import UAPPFramework
class DemoMobileEcommerceState: BaseState {

    var mecHandler : MECDemoUAppInterface?
    var mecViewController : UIViewController?
    var mecDependencies : MECDependencies?
    var mecLaunchInput : MECLaunchInput?
    var mecSettings : MECSettings?
    
    override init() {
        super.init(stateId : AppStates.DemoMobileEcommerce)
    }
    
    ///Set/Update the CoCo inputs and get the viewController to be navigated to
    override func getViewController() -> UIViewController? {
        guard mecViewController == nil else {
            return mecViewController
        }
        setUpInAppPurchaseDemoHandler()
        setUpInAppPurchaseDemoLaunchInput()
        if let launchInput = mecLaunchInput {
            mecViewController = mecHandler?.instantiateViewController(launchInput, withErrorHandler: nil)
            return mecViewController
        }
        return nil
    }
    
    private func setUpInAppPurchaseDemoHandler() {
         guard mecHandler == nil else {
             return
         }
         mecDependencies = MECDependencies()
         mecDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
         mecDependencies?.userDataInterface = UserDataInterfaceInstance.sharedInstance.userDataInterface
         mecSettings = MECSettings()
         if let inAppDependency = mecDependencies{
             mecHandler = MECDemoUAppInterface(dependencies: inAppDependency, andSettings: mecSettings)
         }
     }
     
     private func setUpInAppPurchaseDemoLaunchInput() {
         if mecLaunchInput != nil{
             return
         }
         mecLaunchInput = MECLaunchInput()
     }
    
}
