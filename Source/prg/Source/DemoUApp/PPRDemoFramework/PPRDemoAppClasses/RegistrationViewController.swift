//
//  RegistrationViewController.swift
//  DemoProductRegistrationClient
//
//  Created by DV Ravikumar on 02/02/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
import PhilipsPRXClient
import PhilipsRegistration
import AppInfra
import PhilipsProductRegistration
import UAPPFramework

class RegistrationViewController: UIViewController, UIAlertViewDelegate, UIActionSheetDelegate, UserRegistrationDelegate, JanrainFlowDownloadDelegate, SessionRefreshDelegate {
    
    @IBOutlet var configLabel: UIDLabel!
    @IBOutlet var registrationButton: UIDButton!
    @IBOutlet var productRegistrationButton: UIDButton!
    @IBOutlet var productListButton: UIDButton!
    @IBOutlet weak var logOutButton: UIDProgressButton!
    
    var UserRegistrationInterface : URInterface?
    var UserRegistrationLaunchInput : URLaunchInput?
    
    var pprInterface:PPRInterface?
    
    var currentConfiguration: AIAIAppState?
    var appInfraHandler : AIAppInfra?
    var userDataInterface: UserDataInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dependency: PPRInterfaceDependency = PPRDemoFrameworkInterfaceWrapper.sharedInstance.interfaceDependencies!

        appInfraHandler = dependency.appInfra
        userDataInterface = dependency.userDataInterface

        self.setupURHandler()
        
        //Initialize the component interface with dependency and settings
        self.pprInterface = PPRInterface(dependencies: dependency, andSettings: nil)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layoutIfNeeded()
    }
    
    
    @IBAction func userRegistrationAction(_ sender: AnyObject) {
       
        self.setupURLaunchInput()
        let viewController = UserRegistrationInterface?.instantiateViewController(UserRegistrationLaunchInput!, withErrorHandler: { (error) in
            print("User Registration Launching Error")
        })
        
        if let viewController = viewController{
            self.navigationController?.pushViewController(viewController, animated: true)
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
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = appInfraHandler
        UserRegistrationInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
    }

    
    func setupURLaunchInput() {
        UserRegistrationLaunchInput = URLaunchInput()
        UserRegistrationLaunchInput?.registrationFlowConfiguration.priorityFunction = .registration
        UserRegistrationLaunchInput?.registrationContentConfiguration.personalConsent = URConsentProvider.fetchPersonalConsentDefinition()
        UserRegistrationLaunchInput?.registrationContentConfiguration.personalConsentErrMssge = URConsentProvider.personalConsentErrorMessage()
    }

    @IBAction func showCounterFietPage(_ sender: Any) {
        self.pprInterface?.launchCounterFeitPage()
    }
    
    @IBAction func productRegistrationAction(_ sender: AnyObject) {
        
        
    }

    
    @IBAction func changeConfiguration(_ sender: AnyObject) {
        #if DEBUG
            let buttionTitles = ["Test","Eval","Staging","Production"]
        #else
            let buttionTitles = ["Test","Eval","Staging"]
        #endif
        let actionSheet = UIAlertController(title: "Change Configuration", message: "", preferredStyle: UIAlertController.Style.alert)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
        }))
        
        for title in buttionTitles {
            actionSheet.addAction(UIAlertAction(title: title,
                                                style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                DIUser.getInstance().logout()
                                            let alertView: UIAlertController = UIAlertController(title: "Change configuration", message: "Configuration can only be changed at launch time. You need to relaunch the app to change it.", preferredStyle: UIAlertController.Style.alert)
                                            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alertView, animated: true, completion: nil)

            }))
        }
        self.present(actionSheet, animated: true)
    }
    
    
//MARK: User registration
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func changeThemePressed(_ sender: AnyObject) {
        
        let themeSettingViewController: UINavigationController? = (storyboard?.instantiateViewController(withIdentifier: "ThemeSettingNavigationViewController") as? UINavigationController?)!
        navigationController?.present(themeSettingViewController!, animated: true, completion: {() -> Void in
        })
    }

    
    @IBAction func logOutUser(_ sender: UIDProgressButton) {
        logOutButton.isActivityIndicatorVisible = true
        logOutButton.progressTitle = "Logging out"
        DIUser.getInstance().addRegistrationListener(self)
        DIUser.getInstance().logout()
    }
    
    
    func logoutDidSucceed() {
        let alertLogoutSuccess = UIDAlertController(title: "Logout Success", icon: nil, message: "You are logged out successfully")
        let action = UIDAction(title: "OK", style: .primary, handler: nil)
        alertLogoutSuccess.addAction(action)
        present(alertLogoutSuccess, animated: true, completion: nil)
        logOutButton.isActivityIndicatorVisible = false
    }
    
    
    func logoutFailedWithError(_ error: Error) {
        let alertLogoutFailed = UIDAlertController(title: "OK", icon: nil, message: error.localizedDescription)
        let action = UIDAction(title: "OK", style: .primary, handler: nil)
        alertLogoutFailed.addAction(action)
        present(alertLogoutFailed, animated: true, completion: nil)
        logOutButton.isActivityIndicatorVisible = false
    }
}
