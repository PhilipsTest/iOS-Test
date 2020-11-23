/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UIKit
import AppInfra
import PhilipsUIKitDLS
import ConversationalChatbot

class CCBDemoUAppViewController: UIViewController {
    
    var ccbInterface: CCBInterface!
    var ccbLaunchInput: CCBLaunchInput!
    var ccbSettings: CCBSettings!
    var ccbDependencies: CCBDependencies!
    var ccbAppinfraHandler: AIAppInfra!
    var leftIconImage:UIImage?
    
    @IBOutlet weak var deviceSwitch: UISwitch!
    @IBOutlet weak var presentModalChatScreen: UISwitch!
    @IBOutlet weak var imageButton: UIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeChatbot()
    }
    
    func initializeChatbot() {
        let deviceChecker = CCBDemoDeviceConnectionChecker()
        deviceChecker.isDeviceConnectedToApp = self.deviceSwitch.isOn
        ccbDependencies.chatbotConfiguration?.deviceCapability = deviceChecker
        ccbLaunchInput.leftChatIcon = self.leftIconImage
        ccbInterface = CCBInterface(dependencies: ccbDependencies, andSettings: ccbSettings)
    }
    
}

extension CCBDemoUAppViewController {
    
    @IBAction func launchChatbotUI(_ sender: UIDButton) {
        self.initializeChatbot()
        let chatbotViewController = ccbInterface.instantiateViewController(ccbLaunchInput) { (inError) in
            print("Unable to launch Chatbot UI with error \(inError?.localizedDescription ?? "")")
        }
        guard let chatbotVC = chatbotViewController else { return }
        if self.presentModalChatScreen.isOn == true {
            self.present(chatbotVC, animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(chatbotVC, animated: true)
        }
    }
    
    @IBAction func launchDirectlineAPI(_ sender: UIDButton) {
        self.initializeChatbot()
        self.performSegue(withIdentifier: "ShowDirectLineAPISegue", sender: nil)
    }
    
    @IBAction func changeLeftIconImage(_ sender: UIDButton) {
           let iconAlert = UIAlertController(title: "Left Chat Icon",
                                                 message: "Please select chat Icon",
                                                 preferredStyle: .actionSheet)
            let icons = ["GroupIcon","OperatorIcon","PhilipsIcon","WelcomeIcon"]
            for anIcon in icons {
                let countryAction = UIAlertAction(title: anIcon, style: .default) { (_: UIAlertAction) in
                    var anImage = UIImage(named: anIcon)
                    if anImage == nil {
                        self.leftIconImage = UIImage(named: anIcon, in: Bundle(for: type(of: self)), compatibleWith: nil)
                    }
                    self.imageButton.setTitle(anIcon, for: .normal)
                }
                iconAlert.addAction(countryAction)
            }
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
            {
                if let currentPopoverpresentioncontroller = iconAlert.popoverPresentationController{
    //                currentPopoverpresentioncontroller.sourceView = optionButton
    //                currentPopoverpresentioncontroller.sourceRect = optionButton.bounds;
                    currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up;
                }
            }
            self.present(iconAlert, animated: true, completion: nil)
        }

        
//    @IBAction func resetInterface(_ sender: UIDButton) {
//
//    }
}

class CCBDemoDeviceConnectionChecker : NSObject, CCBDeviceCapabilityInterface {
    var isDeviceConnectedToApp:Bool = true
    
    func isDeviceConnected(deviceID: String) -> Bool {
        return isDeviceConnectedToApp;
    }
}
