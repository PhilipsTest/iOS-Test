/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework
import PhilipsUIKitDLS

class UserRegistrationWelcomeState : UserRegistrationState {
    
    override init() {
        super.init()
        super.stateId = AppStates.UserRegistrationWelcome
    }
    
    override func updateDataModel() {
        dataModel?.completionHandler = { error in
            if (error as NSError?)?.code == 5001{
                do{
                    if let nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistrationWelcome), forEventId: Constants.EVENT_WELCOME_REGISTRATION_CONTINUE) {
                        if let nextVC = nextState.getViewController() {
                            UserDefaults.standard.set(Constants.TRUE_TEXT, forKey: Constants.USER_LOGGEDIN_FIRST_TIME)
                            let loadDetails = ScreenToLoadModel(viewControllerLoadType: .Root, animates: false, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                            Launcher.navigateToViewController(nil, toViewController: nextVC, loadDetails: loadDetails)
                        }
                    }
                }catch{
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_FLOW_MANAGER_TAG, message: (error as! FlowManagerErrors).message())
                }
            }
            if error != nil {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_WELCOME_TAG, message: " \(Constants.LOGGING_USERLOGIN_ERROR) \(String(describing: error))")
            } else {
                do {
                    if let nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistrationWelcome), forEventId: Constants.EVENT_WELCOME_REGISTRATION_CONTINUE) {
                        if let nextVC = nextState.getViewController() {
                            UserDefaults.standard.set(Constants.TRUE_TEXT, forKey: Constants.USER_LOGGEDIN_FIRST_TIME)
                            
                            let status =  ValidateSecurityViolationsManager().checkPreConditionsForSecurityViolations()
                            UserDefaults.standard.set(status, forKey: Constants.VALIDATE_SECURITY_VIOLATION_STATUS)
                            
                            
                            // Setting up CC Live Chat URL, In order to get the home country prior to launching CC
                            (Constants.APPDELEGATE?.getFlowManager().getState(AppStates.ConsumerCare) as? ConsumerCareState)?.setChatURL()
                            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "UserRegistrationWelcomeState:updateDataModel", message: "User Logged-In after Welcome")
                            
                            let loadDetails = ScreenToLoadModel(viewControllerLoadType: .Root, animates: false, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                            Launcher.navigateToViewController(nil, toViewController: nextVC, loadDetails: loadDetails)
                            
                        }
                    }
                    
                } catch {
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_FLOW_MANAGER_TAG, message: (error as! FlowManagerErrors).message())
                    let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
                    Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: nil)
                }
                
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_WELCOME_TAG, message: Constants.LOGGING_USERLOGIN_MESSAGE)
            }
        }
        
    }
}

