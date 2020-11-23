/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

class PopAlertViewController: UIViewController {

    @IBOutlet weak var alertMessageText: UILabel!
    var message:String?
    var isPasscodeAndJailbreakViolation : String?
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertMessageText?.text = message
        popUpView.layer.cornerRadius = 5.0
        popUpView.layer.shadowColor = UIColor.black.cgColor
        popUpView.layer.shadowRadius = 10.0
    }
    
    @IBAction func onClosePopUp(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func showAlertStatuSwitchChanged(_ sender: Any) {
        let toggleSwitch = (sender as? UIDSwitch)?.isOn
        
        if  let value = toggleSwitch, value {
            switch isPasscodeAndJailbreakViolation! {
            case SecurityIdentifier.PASSCODE_TEXT.rawValue:
                UserDefaults.standard.set(value, forKey: Constants.DONT_SHOW_MESSAGE_FOR_PASSCODE)
                UserDefaults.standard.set(Constants.NO_VIOLATION_TEXT, forKey: Constants.VALIDATE_SECURITY_VIOLATION_STATUS)
                
            case SecurityIdentifier.JAILBREAK_TEXT.rawValue:
                UserDefaults.standard.set(value, forKey: Constants.DONT_SHOW_MESSAGE_FOR_JAILBREAK)
                UserDefaults.standard.set(Constants.NO_VIOLATION_TEXT, forKey: Constants.VALIDATE_SECURITY_VIOLATION_STATUS)
                
            case SecurityIdentifier.PASSCODE_AND_JAILBREAK_TEXT.rawValue:
                UserDefaults.standard.set(value, forKey: Constants.DONT_SHOW_MESSAGE_FOR_PASSCODE_AND_JAILBREAK)
                UserDefaults.standard.set(Constants.NO_VIOLATION_TEXT, forKey: Constants.VALIDATE_SECURITY_VIOLATION_STATUS)
                
            default:
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "Default case", message: Constants.NO_VIOLATION_TEXT)
            }
        } else {
                switch isPasscodeAndJailbreakViolation! {
                case SecurityIdentifier.PASSCODE_TEXT.rawValue:
                    UserDefaults.standard.set(toggleSwitch, forKey: Constants.DONT_SHOW_MESSAGE_FOR_PASSCODE)
                    UserDefaults.standard.set(isPasscodeAndJailbreakViolation!, forKey: Constants.VALIDATE_SECURITY_VIOLATION_STATUS)
                    
                case SecurityIdentifier.JAILBREAK_TEXT.rawValue:
                    UserDefaults.standard.set(toggleSwitch, forKey: Constants.DONT_SHOW_MESSAGE_FOR_JAILBREAK)
                    UserDefaults.standard.set(isPasscodeAndJailbreakViolation!, forKey: Constants.VALIDATE_SECURITY_VIOLATION_STATUS)
                    
                case SecurityIdentifier.PASSCODE_AND_JAILBREAK_TEXT.rawValue:
                    UserDefaults.standard.set(toggleSwitch, forKey: Constants.DONT_SHOW_MESSAGE_FOR_PASSCODE_AND_JAILBREAK)
                    UserDefaults.standard.set(isPasscodeAndJailbreakViolation!, forKey: Constants.VALIDATE_SECURITY_VIOLATION_STATUS)
                    
                default:
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "Default case", message: "check you user defaults invalid data is present plz check")
            }
        }
    }
}
