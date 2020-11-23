/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import InAppPurchaseDemoUApp
import InAppPurchase

class DemoInAppPurchaseState: BaseState {
    
    
    var inAppPurchaseHandler : InAppPurchaseDemoUAppInterface?
    var inAppPurchaseViewController : UIViewController?
    var inAppPurchaseDependencies : IAPDependencies?
    var inAppPurchaseLaunchInput : IAPLaunchInput?
    var inAppPurchaseSettings : IAPSettings?
    
    override init() {
        super.init(stateId : AppStates.DemoInAppState)
    }
    
    ///Set/Update the CoCo inputs and get the viewController to be navigated to
    override func getViewController() -> UIViewController? {
        setUpInAppPurchaseDemoHandler()
        setUpInAppPurchaseDemoLaunchInput()
        if let launchInput = inAppPurchaseLaunchInput{
            inAppPurchaseViewController = inAppPurchaseHandler?.instantiateViewController(launchInput, withErrorHandler: nil)
            
            return inAppPurchaseViewController
        }
        return nil
    }
    
   private func setUpInAppPurchaseDemoHandler() {
        guard inAppPurchaseHandler == nil else {
            return
        }
        inAppPurchaseDependencies = IAPDependencies()
        inAppPurchaseDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        inAppPurchaseDependencies?.userDataInterface = UserDataInterfaceInstance.sharedInstance.userDataInterface
        inAppPurchaseSettings = IAPSettings()
        if let inAppDependency = inAppPurchaseDependencies{
            inAppPurchaseHandler = InAppPurchaseDemoUAppInterface(dependencies: inAppDependency, andSettings: inAppPurchaseSettings)
        }
    }
    
    private func setUpInAppPurchaseDemoLaunchInput() {
        if inAppPurchaseLaunchInput != nil{
            return
        }
        inAppPurchaseLaunchInput = IAPLaunchInput()
    }
    
}

