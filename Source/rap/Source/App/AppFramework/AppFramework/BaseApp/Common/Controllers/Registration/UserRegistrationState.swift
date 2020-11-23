/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import PhilipsRegistration
import UAPPFramework
import AppInfra
import PhilipsUIKitDLS

class UserRegistrationComponentModel : ComponentModel {
    
    //MARK: Variable declarations
    static let sharedInstance = UserRegistrationComponentModel()
    fileprivate override init() {}
    
    var completionHandler: ((Error?)->Void)?
}

class UserRegistrationState : BaseState,JanrainFlowDownloadDelegate, DIRegistrationConfigurationDelegate,
UserDetailsDelegate, SessionRefreshDelegate, UserRegistrationDelegate {
    
    //MARK: Variable Declarations
    
    override init() {
        super.init(stateId : AppStates.UserRegistration)
        setupURHandler()
        setupURLaunchInput()
    }
    
    fileprivate var currentConfiguration: String?
    var dataModel : UserRegistrationComponentModel? {
        get {
            return UserRegistrationComponentModel.sharedInstance
        }
        set {
            self.dataModel = newValue
        }
    }
    
    var userRegistrationInterface : URInterface?
    var userRegistrationLaunchInput : URLaunchInput?
    var userRegistrationViewController : UIViewController?
    var userRegistrationDependencies : URDependencies?
    let termsAndPrivacyHelper : TermsAndPrivacyHelperProtocol = TermsAndPrivacyHelper()
    
    var isUserLoggedIn : Bool {
        return (UserDataInterfaceInstance.sharedInstance.userDataInterface?.loggedInState().rawValue)! >= UserLoggedInState.pendingTnC.rawValue
    }
    
    var hsdpAccessToken : String? {
        return UserDataInterfaceInstance.sharedInstance.userDataInterface?.hsdpAccessToken
    }
    
    var canUserReceiveMarketingEmail : Bool? {
       
        let userDetails =  try? UserDataInterfaceInstance.sharedInstance.userDataInterface?.userDetails([UserDetailConstants.RECEIVE_MARKETING_EMAIL])
        let user = userDetails as? Dictionary<String, Bool>
        return user?[UserDetailConstants.RECEIVE_MARKETING_EMAIL]
    }
    
    var getUserName : String? {
        let userDetails =  try? UserDataInterfaceInstance.sharedInstance.userDataInterface?.userDetails([UserDetailConstants.GIVEN_NAME])
        let user = userDetails as? Dictionary<String, String>
        return user?[UserDetailConstants.GIVEN_NAME]
    }
    
    fileprivate var marketingEmail = false
    
    //MARK: BaseState method implementation
    
    override func getViewController() -> UIViewController? {
        updateDataModel()
        AppInfraSharedInstance.sharedInstance.appInfraHandler?.consentManager.fetchConsentState(forConsentDefinition: CookieConsentProvider.getCookieConsentDefination(), completion: { (consentStatus, error) in
            if consentStatus?.status == ConsentStates.active {
                let statusValue = AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.getTestValue("optin_Image", defaultContent: "Kitchen", updateType: .appStart)
                if statusValue == "Sonicare" {
                    self.userRegistrationLaunchInput?.registrationContentConfiguration.optinImage = #imageLiteral(resourceName: "Sonicare")
                    self.userRegistrationLaunchInput?.registrationContentConfiguration.optInTitleText = "Here's what You Have To Look Forward To:"
                    self.userRegistrationLaunchInput?.registrationContentConfiguration.optInQuessionaryText = "Custom Reward Coupons, Holiday Surprises, VIP Shopping Days "
                    self.userRegistrationLaunchInput?.registrationContentConfiguration.optInDetailDescription = ""
                } else {
                    self.userRegistrationLaunchInput?.registrationContentConfiguration.optinImage = #imageLiteral(resourceName: "Kitchen")
                }
            } else {
                self.userRegistrationLaunchInput?.registrationContentConfiguration.optinImage = #imageLiteral(resourceName: "Norelco")
            }
        })
        let statusValue = AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.getTestValue("ur_priority", defaultContent: "registration", updateType: .appStart)
        if statusValue == "registration" {
            userRegistrationLaunchInput?.registrationFlowConfiguration.priorityFunction = .registration
        }else{
            userRegistrationLaunchInput?.registrationFlowConfiguration.priorityFunction = .signIn
        }
        AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.tagevent(withInfo: "LaunchingRegistration", params: nil)
        userRegistrationViewController = userRegistrationInterface?.instantiateViewController(userRegistrationLaunchInput!, withErrorHandler: dataModel?.completionHandler)
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "UserRegistrationState:getViewController", message: "Launching User Registration")
        userRegistrationLaunchInput?.registrationContentConfiguration.personalConsent = URConsentProvider.fetchPersonalConsentDefinition()
        userRegistrationLaunchInput?.registrationContentConfiguration.personalConsentErrMssge = URConsentProvider.personalConsentErrorMessage()
        return userRegistrationViewController
    }
    
    //MARK: Helper methods
    
    func setupURHandler() {
        userRegistrationDependencies = URDependencies()
        userRegistrationDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        userRegistrationInterface = URInterface(dependencies: userRegistrationDependencies!, andSettings: nil)
        if type(of: self) == UserRegistrationState.self {
            // self is an instance of UserRegistrationState, but not any
            // of its subclasses (if self was an instance of a subclass of
            // UserRegistrationState, the body of this if would not execute).
            setUpDIUserUserRegistrationDelegate(self)
        }
    }
    
    func openApplication(forApp app : UIApplication, url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return DIUser.application(app, open: url as URL, options: options)
    }
    
    func setupURLaunchInput() {
        userRegistrationLaunchInput = URLaunchInput()
        userRegistrationLaunchInput?.delegate = self
        userRegistrationLaunchInput?.registrationContentConfiguration.valueForRegistrationTitle = NSAttributedString(string: Constants.USERREGISTRATION_VALUE_FOR_REGISTRATION)
        userRegistrationLaunchInput?.registrationFlowConfiguration.receiveMarketingFlow = .splitSignUp
        //Continue without login
        userRegistrationLaunchInput?.registrationFlowConfiguration.enableSkipRegistration = true
        setUpDIUserDetailsDelegate(self)
        setUpDIUserSessionRefreshDelegate(self)
    }
    
    func setPropertyForKey(_ key:String, value:AnyObject, group : String)
    {
        do {
            try  userRegistrationDependencies?.appInfra.appConfig.setPropertyForKey(key, group: group, value: value)
        } catch let error as NSError {
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "ErrorWhileSettingProperty", message: "\(error)")
        }
    }
    
    func getPropertyForKey(_ key: String, group : String) -> AnyObject? {
        
        do {
            if let keyValue = try userRegistrationDependencies?.appInfra.appConfig.getPropertyForKey(key, group: group) {
                return keyValue as AnyObject?
            } else {
                do {
                    if let keyValue = try AppInfraSharedInstance.sharedInstance.appInfraHandler?.appConfig.getPropertyForKey(key, group: group) {
                        return keyValue as AnyObject?
                    }
                } catch {
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "ErrorWhileGettingProperty", message: "\(error)")
                }
            }
        } catch {
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "ErrorWhileGettingProperty", message: "\(error)")
        }
        
        return nil
    }
    
    func setUpDIUserSessionRefreshDelegate(_ delegate : SessionRefreshDelegate) {
        DIUser.getInstance().addSessionRefreshListener(delegate)
    }
    
    func setUpDIUserDetailsDelegate(_ delegate : UserDetailsDelegate) {
        DIUser.getInstance().addDetailsListener(delegate)
    }
    
    func setUpDIUserUserRegistrationDelegate (_ delegate : UserRegistrationDelegate & JanrainFlowDownloadDelegate) {
        DIUser.getInstance().addRegistrationListener(delegate)
    }
    
    func removeDIUserDelegates <T : AnyObject> (_ delegate : T) where T : UserDetailsDelegate , T : SessionRefreshDelegate, T : UserRegistrationDelegate, T : JanrainFlowDownloadDelegate {
        DIUser.getInstance().removeSessionRefreshListener(delegate)
        DIUser.getInstance().removeDetailsListener(delegate)
        DIUser.getInstance().removeRegistrationListener(delegate)
    }
    
    func logoutFromUserRegistration() {
        
        DIUser.getInstance().logout()
    }
    
    func updateMarketingEmailStatusForUser(_ receiveEmail : Bool) {
        if let urViewController = userRegistrationViewController {
            Utilites.showActivityIndicator(using: urViewController )
        }
        marketingEmail = receiveEmail
        DIUser.getInstance().updateReciveMarketingEmail(receiveEmail)
    }
    
    func refreshAccessToken() {
        DIUser.getInstance().refreshLoginSession()
    }

    //MARK: DIRegistrationConfigurationDelegate methods
    func launchPrivacyPolicy() {
        termsAndPrivacyHelper.launchPrivacyPolicy(fromViewController: userRegistrationViewController, withTitle: nil)
    }
    
    func launchTermsAndConditions() {
        termsAndPrivacyHelper.launchTermsAndConditions(fromViewController: userRegistrationViewController)
    }
    
    func launchPersonalConsentDescription() {
        termsAndPrivacyHelper.launchPersonalConsentDescription(fromViewController: userRegistrationViewController, withTitle: nil)
    }
    
    //MARK: UserDetailsDelegate methods
    func didUpdateSuccess() {
        _ = stateCompletionHandler?.communicateFromState(self)
        Utilites.removeActivityIndicator(onCompletionExecute: nil)
        
        guard DIUser.getInstance().receiveMarketingEmails == true else {
            TaggingUtilities.trackActionWithInfo(key: Constants.TAGGING_REMARKETINGOPTOUT, params:nil)
            return
        }
        AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.tagevent(withInfo: "MarketingOptinstatusSuccess", params: nil)
        TaggingUtilities.trackActionWithInfo(key: Constants.TAGGING_REMARKETINGOPTIN, params:nil)
    }
    
    func didUpdateFailedWithError(_ error: Error) {
        if (error as NSError).code == Int(DISessionExpiredErrorCode) {
            refreshAccessToken()
        } else {
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "UserRegistrationState", message: "\(error.localizedDescription)")
            _ = stateCompletionHandler?.communicateFromState(self)
            Utilites.removeActivityIndicator(onCompletionExecute: nil)
        }
    }

    //MARK: SessionRefreshDelegate methods
    func loginSessionRefreshSucceed() {
        updateMarketingEmailStatusForUser(marketingEmail)
    }
    
    
    func loginSessionRefreshFailedWithError(_ error: Error) {
        let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
        Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TITLE, withMessage: Constants.UPDATE_USER_DATA_ERROR, buttonAction: [alertAction], usingController: nil)
        _ = stateCompletionHandler?.communicateFromState(self)
        Utilites.removeActivityIndicator(onCompletionExecute: nil)
    }
    
    func logoutDidSucceed() {
        UserDefaults.standard.set(false, forKey: Constants.ISHYBRIS_ENABLED)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.LOGOUT_SUCCESS_NOTIFICATION), object: nil)
    }
    
    func logoutFailedWithError(_ error: Error) {
        Utilites.removeActivityIndicator(onCompletionExecute: {
            UserDefaults.standard.set(false, forKey: Constants.ISHYBRIS_ENABLED)
            let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
            Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TITLE, withMessage: error.localizedDescription, buttonAction: [alertAction], usingController: nil)
        })
    }
}

extension UserRegistrationState {
        
    func getVersion() -> String {
        let dictionary = Bundle(for:URInterface.self).infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as! String
        //let build = dictionary?["CFBundleVersion"] as! String
        return "\(version)"
    }
}

