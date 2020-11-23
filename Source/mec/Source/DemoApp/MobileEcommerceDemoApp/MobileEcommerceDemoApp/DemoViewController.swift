/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import UIKit
import MobileEcommerceDemoUApp
import PhilipsRegistration
import UAPPFramework
import MobileEcommerce

class DemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func setUserDataInterface(appInfra:AIAppInfra!) -> UserDataInterface!{
        let userRegistrationDependencies = URDependencies()
        userRegistrationDependencies.appInfra = appInfra
        let urInterface = URInterface(dependencies: userRegistrationDependencies, andSettings: nil)
        return urInterface.userDataInterface()
    }
    
    @IBAction func launchMobileEcommerce(_ sender: Any) {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let appSettings = MECSettings()
        let appDependencies = MECDependencies()
        appDependencies.appInfra = appDelegate.appInfraHandler
        appDependencies.userDataInterface = setUserDataInterface(appInfra: appDelegate.appInfraHandler)
        let mecMicroAppInstance = MECDemoUAppInterface(dependencies: appDependencies, andSettings: appSettings)
        let launchInput = MECLaunchInput()
        let viewController = mecMicroAppInstance.instantiateViewController(launchInput) { (error) in
            print("viewcontroller is nil and giving some error")
        }
        guard let inViewController = viewController else { return }
        self.navigationController?.pushViewController(inViewController, animated: true)
    }
}

