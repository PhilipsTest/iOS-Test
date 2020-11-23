//
//  ViewController.swift
//  DemoApp
//
//  Created by leslie on 13/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import ConsentWidgets
import PhilipsRegistration
import MYADemoUApp
import PhilipsUIKitDLS

class ViewController: UIViewController {
    
    var URLaunched = false
    @IBOutlet weak var HSDPSwitch: UIDSwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My account demo"
        let btnDone = UIBarButtonItem(image: UIImage(named: "ThemeSettingIcon"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(themePressed))
        self.navigationItem.rightBarButtonItem = btnDone
        self.navigationController?.navigationBar.barTintColor =  UIDThemeManager.sharedInstance.defaultTheme?.navigationPrimaryBackground
        
        let value = getPropertyForKey(HSDPConfiguration_Secret)
        if value != nil {
            HSDPSwitch.isOn = true
        }
        else {
            HSDPSwitch.isOn = false
        }
    }
    
    @objc func themePressed() {
        let themeSettingViewController: UINavigationController? = (storyboard?.instantiateViewController(withIdentifier: "ThemeSettingNavigationViewController") as? UINavigationController?)!
        navigationController?.present(themeSettingViewController!, animated: true, completion: {() -> Void in
        })
        
    }
    
    @IBAction func configureHSDP(_ sender: UIDSwitch) {
        if URLaunched == false {
            if sender.isOn {
                setUpHSDPConfiguration()
            }
            else {
                removeHSDPConfiguration()
            }
        }
        else {
            let alertVC = UIDAlertController(title: "Error", message: "Registration is already initialised. For changing the HSDP configuration you need to relaunch the application")
            alertVC.addAction(UIDAction(title: "OK", style: .primary, handler: { (action) in
                exit(0)
            }))
            present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func launchFramework(_ sender: Any) {
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let demoDependencies = MYADemoFrameworkDependencies()
        demoDependencies.appInfra = appdelegate.appInfra
        let demoInterface = MYADemoFrameworkInterface(dependencies: demoDependencies, andSettings: nil)
        let viewController: UIViewController? = demoInterface.instantiateViewController(MYADemoFrameworkLaunchInput(), withErrorHandler: {(_ error: Error?) -> Void in
            print("Update UI")
        })
        URLaunched = true
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func setUpHSDPConfiguration() {
        self.setPropertyForKey(HSDPConfiguration_ApplicationName, value: ["CN": "Sonicare", "default": "uGrow"])
        self.setPropertyForKey(HSDPConfiguration_Shared, value: ["CN": "758f5467-bb78-45d2-a58a-557c963c30c1", "default": "e95f5e71-c3c0-4b52-8b12-ec297d8ae960"])
        self.setPropertyForKey(HSDPConfiguration_Secret, value: ["CN": "981b4f75-9da5-4939-96e5-3e4e18dd6cb6", "default": "EB7D2C2358E4772070334CD868AA6A802164875D6BEE858D13226234350B156AC8C4917885B5552106DC7F9583CA52CB662110516F8AB02215D51778DE1EF1F3"])
        self.setPropertyForKey(HSDPConfiguration_BaseURL, value: ["CN": "https://user-registration-assembly-staging.cn1.philips-healthsuite.com.cn", "default": "https://user-registration-assembly-staging.eu-west.philips-healthsuite.com"])
    }
    
    func setPropertyForKey(_ key: String, value: Any?) {
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        try? appdelegate.appInfra.appConfig.setPropertyForKey(key, group: "UserRegistration", value: value)
    }
    
    func getPropertyForKey(_ key: String) ->Any? {
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        return try? appdelegate.appInfra.appConfig.getPropertyForKey(key, group: "UserRegistration")
    }
    
    func removeHSDPConfiguration() {
        self.setPropertyForKey(HSDPConfiguration_ApplicationName, value: nil)
        self.setPropertyForKey(HSDPConfiguration_Shared, value: nil)
        self.setPropertyForKey(HSDPConfiguration_Secret, value: nil)
        self.setPropertyForKey(HSDPConfiguration_BaseURL, value: nil)
    }
}
