/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class ValidateSecurityViolationsManager{
    
    var isUserLoggedinFirstTime : String?
    var status : String?
    
    /** */
    func checkPreConditionsForSecurityViolations()->String{
        // Check for Security Violations
        
        let passcodeStatus = Utilites.checkForDevicePasscodeStatus()
        let checkJailBreak = Utilites.checkForDeviceJailbreakStatus()
        isUserLoggedinFirstTime = UserDefaults.standard.value(forKey: Constants.USER_LOGGEDIN_FIRST_TIME) as? String
        
        if((checkJailBreak == Constants.FALSE_TEXT || passcodeStatus == true) && (isUserLoggedinFirstTime == Constants.FALSE_TEXT)){
            status = Constants.NO_VIOLATION_TEXT
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "Default case", message: Constants.NO_VIOLATION_TEXT)
        }else{
            status = checkForSecurityViolation(jailbreakStatus: checkJailBreak!, passcodeStatus: passcodeStatus!)
        }
        return status!
    }
    
    /** */
    func checkForSecurityViolation(jailbreakStatus : String , passcodeStatus : Bool)->String{
        
        if((passcodeStatus == false) && (jailbreakStatus == Constants.FALSE_TEXT) && (UserDefaults.standard.value(forKey: Constants.DONT_SHOW_MESSAGE_FOR_PASSCODE) as? Bool != true)){
            UserDefaults.standard.set(Constants.FALSE_TEXT, forKey: Constants.USER_LOGGEDIN_FIRST_TIME)
            return SecurityIdentifier.PASSCODE_TEXT.rawValue
        }
        if ((jailbreakStatus == Constants.TRUE_TEXT) && (passcodeStatus == true) && (UserDefaults.standard.value(forKey: Constants.DONT_SHOW_MESSAGE_FOR_JAILBREAK) as? Bool != true)){
            UserDefaults.standard.set(Constants.FALSE_TEXT, forKey: Constants.USER_LOGGEDIN_FIRST_TIME)
            return SecurityIdentifier.JAILBREAK_TEXT.rawValue
            
        }
        if ((jailbreakStatus == Constants.TRUE_TEXT) && (passcodeStatus == false) && (UserDefaults.standard.value(forKey: Constants.DONT_SHOW_MESSAGE_FOR_PASSCODE_AND_JAILBREAK) as? Bool != true)){
            UserDefaults.standard.set(Constants.FALSE_TEXT, forKey: Constants.USER_LOGGEDIN_FIRST_TIME)
            return SecurityIdentifier.PASSCODE_AND_JAILBREAK_TEXT.rawValue;
        }
        
        return Constants.NO_VIOLATION_TEXT
    }

}
