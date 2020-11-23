/* Copyright (c) Koninklijke Philips N.V., 2019
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import UAPPFramework
import ConversationalChatbot
import ConversationalChatbotDemoUApp

class DemoChatbotState: BaseState {
    
    var ccbHandler : CCBDemoUAppInterface?
    var ccbViewController : UIViewController?
    var ccbDependencies : CCBDependencies?
    var ccbLaunchInput : CCBLaunchInput?
    var ccbSettings : CCBSettings?
    
    override init() {
        super.init(stateId : AppStates.DemoChatbotState)
    }
    
    ///Set/Update the CoCo inputs and get the viewController to be navigated to
    override func getViewController() -> UIViewController? {
        guard ccbViewController == nil else {
            return ccbViewController
        }
        setUpChatbotDemoHandler()
        setUpChatbotDemoLaunchInput()
        if let launchInput = ccbLaunchInput {
            ccbViewController = ccbHandler?.instantiateViewController(launchInput, withErrorHandler: nil)
            return ccbViewController
        }
        return nil
    }
    
    private func setUpChatbotDemoHandler() {
         guard ccbHandler == nil else {
             return
         }
         ccbDependencies = CCBDependencies()
         let config = CCBConfiguration()
         config.chatbotSecretKey = "g8Ye_oNrqs4." + "n37wCTf_kd2In2X6kXNP1" + "apzryHDZ_1OGR5olkQpRM4"
        config.deviceCapability = CCBDemoDeviceChecker()
         ccbDependencies?.chatbotConfiguration = config
         ccbDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
         ccbSettings = CCBSettings()
         if let inAppDependency = ccbDependencies{
             ccbHandler = CCBDemoUAppInterface(dependencies: inAppDependency, andSettings: ccbSettings)
         }
     }
     
     private func setUpChatbotDemoLaunchInput() {
        guard ccbLaunchInput == nil else { return }
         ccbLaunchInput = CCBLaunchInput()
     }
    
}

class CCBDemoDeviceChecker : NSObject, CCBDeviceCapabilityInterface {
    let isDeviceConnectedToApp:Bool = true
    
    func isDeviceConnected(deviceID: String) -> Bool {
        return isDeviceConnectedToApp;
    }
}


