/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import ConversationalChatbot
import ConversationalChatbotDemoUApp

class CCBDemoAppViewController: UIViewController {
    
    @IBOutlet weak var button: UIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chatbot"
    }
    
    @IBAction func launchChatbotDemoUApp(_ sender: UIDButton) {
        let ccbDemoUAppInterface = initializeCCBDemoUApp()
        let ccbDemoUAppLaunchInput = CCBLaunchInput()
        let ccbDemoUAppVC = ccbDemoUAppInterface.instantiateViewController(ccbDemoUAppLaunchInput) { (inError) in
            print("Chatbot demouapp viewcontroller is giving some error")
        }
        guard let inViewController = ccbDemoUAppVC else { return }
        self.navigationController?.pushViewController(inViewController, animated: true)
    }
    
    
    func initializeCCBDemoUApp() -> CCBDemoUAppInterface {
        let settings = CCBSettings()
        let dependencies = CCBDependencies()
        let config = CCBConfiguration()
        config.chatbotSecretKey = "g8Ye_oNrqs4." + "n37wCTf_kd2In2X6kXNP1" + "apzryHDZ_1OGR5olkQpRM4"
        config.deviceCapability = CCBDemoDeviceChecker()
        dependencies.chatbotConfiguration = config
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        dependencies.appInfra = appDelegate.appInfraHandler
        let interface = CCBDemoUAppInterface(dependencies: dependencies, andSettings: settings)
        
        return interface
    }
    
}

class CCBDemoDeviceChecker : NSObject, CCBDeviceCapabilityInterface {
    var isDeviceConnectedToApp:Bool = true
    
    func isDeviceConnected(deviceID: String) -> Bool {
        return isDeviceConnectedToApp;
    }
}
