//
//  ViewController.swift
//  PPROneRoofDemo
//
//  Created by Abhishek on 21/03/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit
import PhilipsProductRegistrationUApp
import UAPPFramework
import AppInfra
import PhilipsProductRegistration
import PhilipsPRXClient
import PhilipsRegistration

class ViewController: UIViewController {

    var prDemoDependencies: PPRInterfaceDependency?
    var prDemoInterface: PPRDemoFrameworkInterface?
    var prDemoLaunchInput: PPRDemoFrameworkLaunchInput?
    var launchOption: PPRUILaunchOption = PPRUILaunchOption.WelcomeScreen

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

        self.prDemoDependencies = PPRInterfaceDependency()
        self.prDemoDependencies?.appInfra = appdelegate.appInfra
        self.prDemoDependencies?.userDataInterface = setUserDataInterface(appInfra: appdelegate.appInfra)
        self.prDemoInterface = PPRDemoFrameworkInterface(dependencies: self.prDemoDependencies!, andSettings: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUserDataInterface(appInfra:AIAppInfra!) -> UserDataInterface!{
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = appInfra
        let urInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
        return urInterface.userDataInterface()
    }

    @IBAction func launchProductRegistrationDemo(_ sender: AnyObject) {
        let launchInput = PPRDemoFrameworkLaunchInput()

        let viewController: UIViewController? = self.prDemoInterface?.instantiateViewController(launchInput, withErrorHandler: {(_ error: Error?) -> Void in
            print("Update UI")
        })

        self.navigationController?.pushViewController(viewController!, animated: true)
    }
}

