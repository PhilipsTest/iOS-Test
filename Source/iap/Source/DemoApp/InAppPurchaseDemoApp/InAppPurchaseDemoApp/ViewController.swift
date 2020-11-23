/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import InAppPurchaseDemoUApp
import InAppPurchase
import PhilipsRegistration

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func launchIAP(_ sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let launchInput = IAPLaunchInput()
        let appSettings = IAPSettings()
        let appDependencies = IAPDependencies()
        appDependencies.appInfra = appDelegate.appInfraHandler
        appDependencies.userDataInterface = setUserDataInterface(appInfra: appDelegate.appInfraHandler)
        let iapMicroAppInstance = InAppPurchaseDemoUAppInterface(dependencies: appDependencies, andSettings: appSettings)
        let iapDemoVC = iapMicroAppInstance.instantiateViewController(launchInput!) { (inError) in
            print("viewcontroller is nil and giving some error")
        }
        self.navigationController?.pushViewController(iapDemoVC!, animated: true)
    }
    
    func setUserDataInterface(appInfra:AIAppInfra!) -> UserDataInterface!{
        let userRegistrationDependencies = URDependencies()
        userRegistrationDependencies.appInfra = appInfra
        let urInterface = URInterface(dependencies: userRegistrationDependencies, andSettings: nil)
        return urInterface.userDataInterface()
    }

}
