//
//  RegistrationViewController.swift
//  DemoProductRegistrationClient
//
//  Created by DV Ravikumar on 02/02/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKit
import PhilipsPRXClient
import PhilipsRegistration
import AppInfra
import PhilipsProductRegistration
import UAPPFramework

class RegistrationViewController: UIViewController,UIAlertViewDelegate,UIActionSheetDelegate {
    
    @IBOutlet var configLabel: PUILabel!
    @IBOutlet var registrationButton: PUIButton!
    @IBOutlet var productRegistrationButton: PUIButton!
    @IBOutlet var productListButton: PUIButton!
    
    var UserRegistrationInterface : URInterface?
    var UserRegistrationLaunchInput : URLaunchInput?
    
    var currentConfiguration: DIRegistrationEnvironment?
    var appInfraHandler : AIAppInfra?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         Initiate product registration
         **/
        
        let dependency: UAPPDependencies = UAPPDependencies()
        //Client app needs to alloc for AIAppInfra
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        dependency.appInfra = appdelegate.appInfra
        self.appInfraHandler = appdelegate.appInfra
        
        //Intialize UR dependecies
        //Do not initialize PR interface before setting up UR interface
        self.setupURHandler()
        
        //Initialize the component interface with dependency and settings
        _ = PPRInterface(dependencies: dependency, andSettings: nil)
        
        let configuration = UserDefaults.standard.object(forKey: "currentConfiguration") as? NSNumber
        if configuration != nil {
            self.setEnvironment((configuration?.intValue)!)
        }
        else {
            //Set default enviroment as staging
            self.setEnvironment(3)
        }
    }

    @IBAction func userRegistrationAction(_ sender: AnyObject) {
       
        self.setupURLaunchInput()
        let viewController = UserRegistrationInterface?.instantiateViewController(UserRegistrationLaunchInput!, withErrorHandler: { (error) in
            print("User Registration Launching Error")
        })
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func setupURHandler() {
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = appInfraHandler
        UserRegistrationInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
    }
    
    func setupURLaunchInput() {
        UserRegistrationLaunchInput = URLaunchInput()
        UserRegistrationLaunchInput?.registrationFlowConfiguration.priorityFunction = .registration
    }
    
    @IBAction func productRegistrationAction(_ sender: AnyObject) {
        
        
    }
    
    @IBAction func changeConfiguration(_ sender: AnyObject) {
        #if DEBUG
            let buttionTitles = ["Test","Eval","Staging","Production"]
        #else
            let buttionTitles = ["Test","Eval","Staging"]
        #endif
        
        let actionSheet: UIActionSheet = UIActionSheet(title: "Change Configuration", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil,otherButtonTitles:"Dev")
        for title in buttionTitles {
            actionSheet.addButton(withTitle: title)
        }
        actionSheet.show(in: self.view)
    }
    //MARK: User registration
    
    func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int){
         print("buttonIndex:::\(buttonIndex)")
        if buttonIndex != 0 {
            DIUser.getInstance().logout()

            self.setEnvironment(buttonIndex - 1)
            
            let alertView: UIAlertController = UIAlertController(title: "Change configuration", message: "Configuration can only be changed at launch time. You need to relaunch the app to change it.", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }
    }

    func  setEnvironment (_ index: Int)  {
        var selectedEnv: String?
        switch index {
        case 0:
            UserDefaults.standard.set(NSNumber(value: 0 as UInt32), forKey: "currentConfiguration")
            selectedEnv = "Development"
        case 1:
            UserDefaults.standard.set(NSNumber(value: 1 as UInt32), forKey: "currentConfiguration")
            selectedEnv = "Test"
        case 2:
            UserDefaults.standard.set(NSNumber(value: 2 as UInt32), forKey: "currentConfiguration")
            selectedEnv = "Acceptance"
        case 3:
            UserDefaults.standard.set(NSNumber(value: 3 as UInt32), forKey: "currentConfiguration")
            selectedEnv = "Staging"
        case 4:
            UserDefaults.standard.set(NSNumber(value: 4 as UInt32), forKey: "currentConfiguration")
            selectedEnv = "Production"
        default:
            UserDefaults.standard.set(NSNumber(value: 3 as UInt32), forKey: "currentConfiguration")
            selectedEnv = "Staging"
        }
        
        do{
            try self.appInfraHandler!.appConfig.setPropertyForKey("appidentity.state", group: "appinfra", value: selectedEnv)
        }
        catch _ as NSError{
            
        }
        self.configLabel.text = "Current configuration: "+selectedEnv!
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
