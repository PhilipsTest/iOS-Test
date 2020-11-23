/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import ConsumerCareMicroApp

class DemoConsumerCareState: BaseState {
    
    var consumerCareHandler : ConsumerCareMicroAppInterface?
    var consumerCareViewController : UIViewController?
    var consumerCareDependencies : ConsumerCareMicroAppDependencies?
    var consumerCareLaunchInput : ConsumerCareMicroAppLaunchInput?
    var consumerCareSettings : ConsumerCareMicroAppSettings?
    
    override init() {
        super.init(stateId : AppStates.DemoConsumerCareState)
    }
    
    ///Set/Update the CoCo inputs and get the viewController to be navigated to
    override func getViewController() -> UIViewController? {
        setUpConsumerCareDemoHandler()
        setUpConsumerCareDemoLaunchInput()
        if let launchInput = consumerCareLaunchInput{
            consumerCareViewController = consumerCareHandler?.instantiateViewController(launchInput, withErrorHandler: nil)
            return consumerCareViewController
        }
        return nil
    }
    /** setUpConsumerCareDemoHandler Intialize the commlib handler
     
     */
    
   private func setUpConsumerCareDemoHandler() {
        if consumerCareHandler != nil{
            return
        }
        consumerCareDependencies = ConsumerCareMicroAppDependencies()
        consumerCareSettings = ConsumerCareMicroAppSettings()
        if let consumeCareDependency = consumerCareDependencies{
            consumeCareDependency.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
            consumerCareHandler = ConsumerCareMicroAppInterface(dependencies: consumeCareDependency, andSettings: consumerCareSettings)
        }
    }
    
    /** setUpConsumerCareDemoLaunchInput Intialize the commlib launchInput
     
     */
    private func setUpConsumerCareDemoLaunchInput() {
        if consumerCareLaunchInput != nil{
            return
        }
        consumerCareLaunchInput = ConsumerCareMicroAppLaunchInput()
    }
}


