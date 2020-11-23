/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UAPPFramework
import MyAccount
import PlatformInterfaces
import PhilipsRegistration
import PhilipsUIKitDLS
import ConsentWidgets
import AppInfra

class MyAccountState: BaseState,MYADelegate, JanrainFlowDownloadDelegate, ConsentWidgetCenterPrivacyProtocol {
    
    var myaInterface: MYAInterface?
    var usrInterface : UserRegistrationState?
    var myAccountViewController : UIViewController?
    var myAlaunchInput: MYALaunchInput?
    var myaFactory: MyaFactory?
    convenience override init() {
        self.init(myaFactory: MyaFactory())
    }
    
    init(myaFactory: MyaFactory) {
        super.init(stateId: AppStates.MyAccount)
        myaInterface = myaFactory.createMyaInterface()
    }
    
    override func getViewController() -> UIViewController? {
        var cacheStatus = "NotUpdated"
        if  AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.getCacheStatus() == AIABTestCacheStatus.experiencesUpdated {
            cacheStatus = "Updated"
        }
        myAlaunchInput = MYALaunchInput()
        myAlaunchInput?.delegate = self
        usrInterface = (Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistration)) as? UserRegistrationState
        myAlaunchInput?.userDataProvider = usrInterface?.userRegistrationInterface?.userDataInterface()
        myAlaunchInput?.settingMenuList = ["MYA_Country"]
        myAlaunchInput?.profileMenuList = ["MYA_My_details","User Optin","ABTestCacheStatus = \(cacheStatus)"]
        if let launchInput = myAlaunchInput {
            myAccountViewController = myaInterface?.instantiateViewController(launchInput, withErrorHandler: nil)
            return myAccountViewController
        }
        return nil
    }
    
    
    func settingsMenuItemSelected(onItem item: String) -> Bool {
        if item == "MYA_Privacy_Settings" {
            if let internet = AppInfraSharedInstance.sharedInstance.appInfraHandler?.restClient.isInternetReachable(), internet {
                do {
                    let nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.MyAccount), forEventId: "PrivacySettings" )
                    if nextState != nil {
                        if let loadVC = nextState?.getViewController() {
                            Launcher.navigateToViewController(myAccountViewController, toViewController: loadVC, loadDetails: ScreenToLoadModel(viewControllerLoadType: .Push, animates: true, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil))
                        }
                    }
                    return true
                } catch {
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "MyAccount" , message: "Unable to load Privacy_Settings")
                    return true
                }
            } else {
                Utilites.showDLSAlert(withTitle: "You are offline", withMessage: "Your internet connection does not seem to be working. Please check and try again", buttonAction: [UIDAction(title: "OK", style: .primary, handler: nil)], usingController: myAccountViewController )
                return  true
            }
        }
        return false
    }
    
    func profileMenuItemSelected(onItem item: String) -> Bool {
        if item ==  "MYA_My_details"{
            do {
                let nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.MyAccount), forEventId: "MyDetails" )
                if nextState != nil {
                    if let loadVC = nextState?.getViewController() {
                        Launcher.navigateToViewController(myAccountViewController, toViewController: loadVC, loadDetails: ScreenToLoadModel(viewControllerLoadType: .Push, animates: true, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil))
                    }
                }
                return true
            } catch {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "MyAccount" , message: "Unable to load My_Details")
                return true
            }
        } else if (item == "User Optin") {
            do {
                let nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.MyAccount), forEventId: "UserOptin" )
                if nextState != nil {
                    if let loadVC = nextState?.getViewController() {
                        Launcher.navigateToViewController(myAccountViewController, toViewController: loadVC, loadDetails: ScreenToLoadModel(viewControllerLoadType: .Push, animates: true, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil))
                    }
                }
                return true
            } catch {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "UserOptin" , message: "Unable to load UserOptin")
                return true
            }
        }
        return false
    }
    
    func logoutClicked() {
        if let myAccountVC = myAccountViewController {
            Utilites.showActivityIndicator(using: myAccountVC)
            deregisterPushnotificationToken()
        }
    }
    
    
    func deregisterPushnotificationToken(){
        logoutFromMyAccount()
    }

    //MARK: User Registration Delegates
    @objc func logoutDidSucceed() {
        NotificationCenter.default.removeObserver(self)
        Utilites.removeActivityIndicator(onCompletionExecute: {
            let menu = BAHamburgerMenuData(menuID: "Home", screenTitle: "RA_HomeScreen_Title", icon: "Home")
            (self.myAccountViewController?.sideBarViewController() as? HamburgerMenuViewController)?.showHamburgerMenu(menu: menu)
            self.myAccountViewController = nil
            AppInfraSharedInstance.sharedInstance.appInfraHandler?.restClient.clearCacheResponse()
        })
    }
        
    func logoutFromMyAccount(){
        if let userRegistrationState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistration){
            NotificationCenter.default.addObserver(self, selector: #selector(logoutDidSucceed), name: NSNotification.Name(rawValue: Constants.LOGOUT_SUCCESS_NOTIFICATION), object: nil)
            (userRegistrationState as? UserRegistrationState)?.logoutFromUserRegistration()
        }
    }

    //MARK: Concent Widget delegate
    func userClickedOnPrivacyURL() {
        TermsAndPrivacyHelper().launchPrivacyPolicy(fromViewController: myAccountViewController, withTitle: Constants.PRIVACY_POLICY_TEXT)
    }
}
