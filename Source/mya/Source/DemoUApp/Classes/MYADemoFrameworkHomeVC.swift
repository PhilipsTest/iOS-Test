//
//  MYADemoFrameworkHomeVC
//  DemoApp
//
//  Created by Hashim MH on 09/10/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import MyAccount
import UAPPFramework
import AppInfra
import PhilipsUIKitDLS
import PhilipsRegistration
import ConsentWidgets
import PlatformInterfaces

class MYADemoFrameworkHomeVC: UIViewController,MYADelegate,UserRegistrationDelegate,JanrainFlowDownloadDelegate {
    
    @IBOutlet weak var logoutButton: UIDButton!
    public var appinfra:AIAppInfra!
    lazy var urLaunchInput = URLaunchInput()
    var urInterface : URInterface?
    var myaNav :UINavigationController?
    var myaPushed = false
    
    func addCrossButtonToNavigationBar(viewController:UIViewController) -> UINavigationController  {
        let nc = UINavigationController.init(rootViewController: viewController)
        nc.navigationBar.backgroundColor = UIColor(red: 45.0/255.0, green: 135.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        nc.navigationBar.barTintColor = UIColor(red: 45.0/255.0, green: 135.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        let btnDone = UIBarButtonItem(title: "✕", style: .done, target: self, action: #selector(dismissNav))
        nc.topViewController?.navigationItem.leftBarButtonItem = btnDone
        return nc
    }
   @objc func dismissNav() {
        self.dismiss(animated: true, completion: nil)
    }

    func displayUserNotLoggedInAlert(){
        let alert  = UIAlertController.init(title: "User is not logged in", message: "Please sign in to continue ", preferredStyle: .alert)
        let loginAction = UIAlertAction.init(title: "Login", style: .default, handler: { (action) in
            DispatchQueue.main.async{
                self.userRegistrationAction(UIDButton())
            }
        })
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(loginAction)
        alert.addAction(cancelAction)
        DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo"
        
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        self.navigationItem.setRightBarButtonItems([settingsButton], animated: false)
        
        self.setupURHandler()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLoginButtonTitle()
    }
    
    //MARK:methods
    
   @objc func showSettings() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Settings") as? MYADemoFrameworkSettingsVC {
            self.navigationController?.show(vc, sender: self)
        }
    }
    
    func setLoginButtonTitle(){
        if DIUser.getInstance().userLoggedInState.rawValue == UserLoggedInState.userLoggedIn.rawValue{
            logoutButton.setTitle("Log out", for: .normal)
        }
        else{
            logoutButton.setTitle("Log in", for: .normal)
        }
    }
    
    @IBAction func launchPressed(_ sender: UIDButton) {
        let myaDependencies = MYADependencies()
        myaDependencies.appInfra = appinfra
        let myaInterface = MYAInterface(dependencies: myaDependencies, andSettings: MYASettings())
        let launchInput = MYALaunchInput()
        launchInput.delegate = self
        launchInput.profileMenuList = ["About"]
        launchInput.settingMenuList = ["MYA_Country","Settings item1","Settings item2"]
        launchInput.userDataProvider = urInterface?.userDataInterface()
        
        let vc  = myaInterface.instantiateViewController(launchInput) { (error) in
            self.displayUserNotLoggedInAlert()
        }
        
        if let vc = vc {
            if sender.tag  == 0{
                myaPushed = false
                myaNav = addCrossButtonToNavigationBar(viewController: vc)
                guard let nc = myaNav else{
                    return
                }
                present(nc, animated: true, completion: nil)
              }
            else {
                myaPushed = true
                self.navigationController?.pushViewController(vc, animated: true);
            }
        }
    }
    
    
    
    @IBAction func userRegistrationAction(_ sender: AnyObject) {
        urLaunchInput.registrationFlowConfiguration.priorityFunction = .registration
        
        let viewController = urInterface?.instantiateViewController(urLaunchInput, withErrorHandler: { (error) in
            print("User Registration Launching Error")
        })
        
        if let viewController = viewController{
            if DIUser.getInstance().userLoggedInState.rawValue == UserLoggedInState.userLoggedIn.rawValue {
                let alert  = UIAlertController.init(title: "Logged In", message: "You are already logged in do you want to refresh the session", preferredStyle: .alert)
                
                let refreshAction = UIAlertAction.init(title: "Refresh", style: .default, handler: { (action) in
                    DIUser.getInstance().refreshLoginSession()
                })
                
                let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
                
                let logOutAction = UIAlertAction.init(title: "Log Out", style: .destructive, handler: { (action) in
                    DIUser.getInstance().logout()
                })
                
                alert.addAction(refreshAction)
                alert.addAction(cancelAction)
                alert.addAction(logOutAction)
                
                present(alert, animated: true, completion: nil)
                
            }
            else{
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        }
        else{
            let alert  = UIAlertController.init(title: "Logged In", message: "You are already logged in do you want to refresh the session", preferredStyle: .alert)
            
            let refreshAction = UIAlertAction.init(title: "Refresh", style: .default, handler: { (action) in
                DIUser.getInstance().refreshLoginSession()
            })
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            
            let logOutAction = UIAlertAction.init(title: "Log Out", style: .destructive, handler: { (action) in
                DIUser.getInstance().logout()
                
            })
            
            alert.addAction(refreshAction)
            alert.addAction(cancelAction)
            alert.addAction(logOutAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupURHandler() {
        let urDependencies = URDependencies()
        urDependencies.appInfra = appinfra
        urInterface = URInterface(dependencies: urDependencies, andSettings: nil)
        DIUser.getInstance().addRegistrationListener(self)
    }
    
    func logoutDidSucceed() {
        setLoginButtonTitle()
        if self.presentedViewController == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func logoutFailedWithError(_ error: Error) {
        setLoginButtonTitle()
        let alertVC = UIDAlertController()
        alertVC.title = "Logout failed!"
        alertVC.message = error.localizedDescription
        alertVC.addAction(UIDAction(title:"MYA_Cancel", style: .secondary))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
        if self.presentedViewController == nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    func profileMenuItemSelected(onItem item: String) -> Bool {
        if item == "About" {
            if let about = storyboard?.instantiateViewController(withIdentifier: "About") as? AboutViewController {
                pushOrPop(about)
            }
            return true
        } else if (item == "MYA_My_details") {
            urLaunchInput.registrationFlowConfiguration.loggedInScreen = .myDetails
            if let urViewController = urInterface?.instantiateViewController(urLaunchInput, withErrorHandler: { (error) in print("User Registration Launching Error")}) {
                if DIUser.getInstance().userLoggedInState.rawValue == UserLoggedInState.userLoggedIn.rawValue {
                    if let  nav = navigationController, myaPushed == true {
                        nav.pushViewController(urViewController, animated: true)
                    }
                    else if let presentedNav = myaNav {
                        presentedNav.pushViewController(urViewController, animated: true)
                    }
                }
            }
            return true
        }
        return false
    }
    
    
    func settingsMenuItemSelected(onItem item: String) -> Bool {
        if item == "MYA_Privacy_Settings"{
            
            guard appinfra.restClient.isInternetReachable() else {
                showErrorDialog(errorTitle:  "You are offline", errorMessage: "Your internet connection does not seem to be working. Please check and try again", actionText:  "Ok")
                return true
            }
            
            
            if let consent = getConsentIntialViewController() {
                pushOrPop(consent)
            }
        }
        return false
    }
    
    func getConsentIntialViewController() -> UIViewController?{
        let dependency = ConsentWidgetsDependencies()
        dependency.appInfra = appinfra
        
        guard let cloudConsent = self.appinfra?.cloudLogging.getCloudLoggingConsentIdentifier()else{
            return nil
        }

        let clickstreamConsentDefinition = ConsentDefinition(types: [appinfra.tagging.getClickStreamConsentIdentifier(),cloudConsent], text: "I allow Philips to store my tagging data", helpText: "This consent is for adobe tagging!", version: 1 , locale: "en-US")
        let marketingConsentDefinition = URConsentProvider.fetchMarketingConsentDefinition(appinfra.internationalization.getBCP47UILocale())
        
        let consentWidgetInterface = ConsentWidgetsInterface(dependencies: dependency, andSettings: nil)
        let launchInput: ConsentWidgetsLaunchInput = ConsentWidgetsLaunchInput(consentDefinitions: [clickstreamConsentDefinition, marketingConsentDefinition], privacyDelegate: self)
        let completionHandler: (Error?) -> Swift.Void = { ( error) in }
        let viewController = consentWidgetInterface.instantiateViewController(launchInput, withErrorHandler: completionHandler)
        return viewController
    }
    
    private func showErrorDialog(errorTitle: String, errorMessage: String, actionText: String) {
        DispatchQueue.main.async {
            let alert = UIDAlertController(title: errorTitle, message: errorMessage)
            let action = UIDAction(title: actionText, style: .primary, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    
    func logoutClicked() {
        DIUser.getInstance().logout()
    }
}

extension MYADemoFrameworkHomeVC: ConsentWidgetCenterPrivacyProtocol {
    func userClickedOnPrivacyURL() {
        let storyboard = UIStoryboard(name: "MYADemoUApp", bundle: Bundle(for: MYADemoFrameworkHomeVC.self))
        guard let viewControllerToDisplay = storyboard.instantiateViewController(withIdentifier: "PrivacyNoticeVC") as? ConsentsPrivacyNoticeWebViewController else {
            return
        }
        viewControllerToDisplay.appInfraInstance = self.appinfra
        let navigationController = UINavigationController(rootViewController: viewControllerToDisplay)
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension MYADemoFrameworkHomeVC {
    
    func pushOrPop(_ viewController:UIViewController){
        if let  nav = navigationController, myaPushed == true {
            nav.pushViewController(viewController, animated: true)
        }
        else if let presentedNav = myaNav {
            presentedNav.pushViewController(viewController, animated: true)
        }
    }
    
}

extension String {
    var localized: String {
        let bundle = Bundle(for: MYADemoFrameworkHomeVC.self)
        return NSLocalizedString(self, tableName: "Localizable", bundle: bundle, value: "key not found", comment: "")
    }
}
