/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import UIKit
import PhilipsRegistration
import UAPPFramework
import ECSTestUApp

class DemoAppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setUserDataInterface(appInfra:AIAppInfra!) -> UserDataInterface!{
        let userRegistrationDependencies = URDependencies()
        userRegistrationDependencies.appInfra = appInfra
        let urInterface = URInterface(dependencies: userRegistrationDependencies, andSettings: nil)
        return urInterface.userDataInterface()
    }
    
    @IBAction func launchEcommerceTestApp(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let launchInput = ECSTestUAppLaunchInput()
        let appSettings = ECSTestUAppSettings()
        let appDependencies = ECSTestUAppDependencies()
        appDependencies.appInfra = appDelegate.appInfraHandler
        appDependencies.userDataInterface = setUserDataInterface(appInfra: appDelegate.appInfraHandler)
        let ecsMicroAppInstance = ECSTestUAppInterface(dependencies: appDependencies, andSettings: appSettings)
        let ecsDemoVC = ecsMicroAppInstance.instantiateViewController(launchInput) { (inError) in
            print("viewcontroller is nil and giving some error")
        }
        self.navigationController?.pushViewController(ecsDemoVC!, animated: true)
    }
}
