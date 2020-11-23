/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework
import PhilipsUIKitDLS

class UserRegistrationSettingsState: UserRegistrationState {
    
    override init() {
        super.init()
        super.stateId = AppStates.UserRegistrationSettings
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
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_SETTINGS_TAG, message: " \(Constants.LOGGING_USERLOGIN_ERROR) \(String(describing: error))")
            } else {
                do {
                    if let nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistrationSettings), forEventId: Constants.EVENT_SETTINGS_REGISTRATION_CONTINUE) {
                        if let nextVC = nextState.getViewController(){
                            (Constants.APPDELEGATE?.getFlowManager().getState(AppStates.ConsumerCare) as? ConsumerCareState)?.setChatURL()
                            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "UserRegistrationSettingsState:updateDataModel", message: "User Logged In From Settings")
                            let loadDetails = ScreenToLoadModel(viewControllerLoadType: .Root, animates: false, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                            Launcher.navigateToViewController(nil, toViewController: nextVC, loadDetails: loadDetails)
                            
                        }
                        
                    }
                } catch {
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_FLOW_MANAGER_TAG, message: (error as! FlowManagerErrors).message())
                    let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
                    Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: nil)
                }
            }
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_SETTINGS_TAG, message: Constants.LOGGING_USERLOGIN_MESSAGE)
            }
        }
    }



