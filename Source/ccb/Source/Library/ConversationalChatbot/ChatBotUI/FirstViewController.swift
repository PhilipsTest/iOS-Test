/* Copyright (c) Koninklijke Philips N.V., 2017
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/
/** © Koninklijke Philips N.V., 2016. All rights reserved. */


import UIKit
import ConversationalChatbotDev
import AppInfra
import PhilipsUIKitDLS

class FirstViewController: UIViewController {

    var ccbInterface: CCBInterface!
    var ccbLaunchInput: CCBLaunchInput!
    var ccbSettings: CCBSettings!
    var ccbDependencies: CCBDependencies!
    var ccbAppinfraHandler: AIAppInfra!
    var leftIconImage:UIImage?
    
    @IBOutlet weak var deviceSwitch: UISwitch!
    @IBOutlet weak var imageButton: UIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let themeButton = UIBarButtonItem(title: "Theme", style: .plain, target: self, action: #selector(themeButtonPressed))
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(themeButtonPressed))
        self.navigationItem.rightBarButtonItem = themeButton;
    }
    
    func initializeChatbot() {
        let deviceChecker = DeviceConnectionChecker()
        self.ccbSettings = CCBSettings()
        self.ccbDependencies = CCBDependencies()
        self.ccbLaunchInput = CCBLaunchInput()
        self.ccbLaunchInput.leftChatIcon = self.leftIconImage
        let config = CCBConfiguration()
        config.chatbotSecretKey = "g8Ye_oNrqs4." + "n37wCTf_kd2In2X6kXNP1" + "apzryHDZ_1OGR5olkQpRM4"
        config.deviceCapability = deviceChecker
        self.ccbDependencies.chatbotConfiguration = config
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        self.ccbDependencies.appInfra = appDelegate.appInfraHandler
        ccbInterface = CCBInterface(dependencies: ccbDependencies, andSettings: ccbSettings)
    }
    
    
    @IBAction func launchChatbotUI(_ sender: UIDButton) {
        self.initializeChatbot()
        let chatbotViewController = ccbInterface.instantiateViewController(ccbLaunchInput) { (inError) in
            print("Unable to launch Chatbot UI with error \(inError?.localizedDescription ?? "")")
        }
        guard let chatbotVC = chatbotViewController else { return }
        self.navigationController?.pushViewController(chatbotVC, animated: true)
    }
    
    @IBAction func launchDirectlineAPI(_ sender: UIDButton) {
        self.initializeChatbot()
        self.performSegue(withIdentifier: "DirectLineAPISegue", sender: nil)
    }
    
    @IBAction func changeLeftIconImage(_ sender: UIDButton) {
        let iconAlert = UIAlertController(title: "Left Chat Icon",
                                             message: "Please select chat Icon",
                                             preferredStyle: .actionSheet)
        let icons = ["GroupIcon","OperatorIcon","PhilipsIcon","WelcomeIcon"]
        for anIcon in icons {
            let countryAction = UIAlertAction(title: anIcon, style: .default) { [weak self] (_: UIAlertAction) in
                DispatchQueue.main.async {
                    self?.leftIconImage = UIImage(named: anIcon)
                    self?.imageButton.setTitle(anIcon, for: .normal)
                }
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

    
    
    @objc func themeButtonPressed (sender:UIButton) {
            if let initialViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ThemeSettingViewController")) {
                self.navigationController?.pushViewController(initialViewController, animated: false)
            }
    }

}

class DeviceConnectionChecker : NSObject, CCBDeviceCapabilityInterface {
    var isDeviceConnectedToApp:Bool = true
    
    func isDeviceConnected(deviceID: String) -> Bool {
        return isDeviceConnectedToApp;
    }
}


