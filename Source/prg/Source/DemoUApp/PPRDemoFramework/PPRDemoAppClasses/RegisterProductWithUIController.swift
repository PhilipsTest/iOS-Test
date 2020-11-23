//
//  RegisterProductWithUIController.swift
//  DemoProductRegistrationClient
//
//  Created by DV Ravikumar on 10/06/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import UIKit
import Foundation
import PhilipsUIKitDLS
import PhilipsPRXClient
import PhilipsProductRegistration
import UAPPFramework

class RegisterProductWithUIController: UIViewController, UIActionSheetDelegate, PPRUserInterfaceDelegate, UITextFieldDelegate {
    
    @IBOutlet var serailNumberField: UIDTextField!
    @IBOutlet var ctnField: UIDTextField!
    @IBOutlet var nameField: UIDTextField!
    @IBOutlet var launchOptionLabel: UIDLabel!
    @IBOutlet var registerButton: UIDButton!
    @IBOutlet weak var animateExitSwitch: UISwitch!
    @IBOutlet weak var presentPRSwitch: UISwitch!
    @IBOutlet weak var mandateRLSwitch: UISwitch!
    @IBOutlet weak var registerButtonText: UITextField!
    
    var isSendEmail: Bool = true
    
    var launchOption: PPRUILaunchOption = PPRUILaunchOption.WelcomeScreen
    var presentableNavigation: UINavigationController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product registration"
        self.launchOptionLabel.text =  "LaunchOption: " + "App setup flow"
        self.presentPRSwitch.isOn = false
        self.mandateRLSwitch.isOn = false
        self.registerButtonText.isHidden = true
        self.registerButtonText.text = "Register"
    }
    
    @IBAction func changeConfiguration(_ sender: AnyObject) {
        
        let buttionTitles = ["App setup flow","User initiation flow"]
        let actionSheet = UIAlertController(title: "Launch option", message: "", preferredStyle: UIAlertController.Style.alert)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { _ in
        }))
        
        actionSheet.addAction(UIAlertAction(title: buttionTitles[0],
                                            style: UIAlertAction.Style.default,
                                            handler: {(_: UIAlertAction!) in
                                                self.launchOption = PPRUILaunchOption.WelcomeScreen
                                                self.launchOptionLabel.text =  "LaunchOption: " + buttionTitles[0]
        }))
        
        actionSheet.addAction(UIAlertAction(title: buttionTitles[1],
                                            style: UIAlertAction.Style.default,
                                            handler: {(_: UIAlertAction!) in
                                                self.launchOption = PPRUILaunchOption.ProductRegistrationScreen
                                                self.launchOptionLabel.text =  "LaunchOption: " + buttionTitles[1]
        }))
        
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func mandateRegisterAction(_ sender: UISwitch) {
        self.registerButtonText.isHidden = !sender.isOn
    }
    
    @IBAction func sendEmail(_ sender: UIDSwitch) {
        self.isSendEmail = sender.isOn
    }
    
    @IBAction func launchUIAction(_ sender: UIButton) {
        
        let contentConfig = PPRContentConfiguration()
        contentConfig.benefitText = "• Extend your warranty by xx months"
        //contentConfig.extendWarrantyText = "Your warranty period has been extended until next year."
        // contentConfig.emailText = "An email with extended warranty contract  has been sent out to your email address."
        contentConfig.mandatoryProductRegistration = self.mandateRLSwitch.isOn
        if self.mandateRLSwitch.isOn {
            contentConfig.mandatoryRegisterButtonText = self.registerButtonText.text
        }
        
        let configuration = PPRConfiguration()
        // Launch Option
        configuration.launchOption = self.launchOption
        
        // Content configuraion
        configuration.contentConfiguration = contentConfig
        
        let productInfo : PPRProduct = PPRProduct(ctn: self.ctnField.text!, sector: B2C, catalog: CONSUMER)
        productInfo.serialNumber = self.serailNumberField.text
        productInfo.friendlyName = self.nameField.text
        productInfo.sendEmail = self.isSendEmail
        
        let launchInput: PPRLaunchInput = PPRLaunchInput()
        launchInput.productInfo = [productInfo]
        launchInput.launchConfiguration = configuration
        //Register delegates for back and continue button
        launchInput.userInterfacedelegate = nil
        launchInput.launchConfiguration!.userInterfaceConfiguration.productPromotionImage = UIImage(named:"pr_config1")
        //launchInput.launchConfiguration!.userInterfaceConfiguration.descriptionTextFontColor = UIColor.white
        launchInput.launchConfiguration!.animateExit = animateExitSwitch.isOn

        let dependency = PPRInterfaceDependency()
        //Client app needs to alloc for AIAppInfra
        dependency.appInfra = PPRDemoFrameworkInterfaceWrapper.sharedInstance.interfaceDependencies?.appInfra
        dependency.userDataInterface = PPRDemoFrameworkInterfaceWrapper.sharedInstance.interfaceDependencies?.userDataInterface
        //Initialize the component interface with dependency and settings
        let productRegistrationInterface = PPRInterface(dependencies: dependency, andSettings: nil)
        
        let completionHandler: (Error?) -> Swift.Void = { ( error) in
            self.dismissNavigationController()
            // this is where the completion handler code goes
            if let prError = error as NSError? {
                if(prError.code == PPRError.USER_NOT_LOGGED_IN.rawValue) {
                    //Show an alert in case user is not logged in
                    let alertView: UIAlertController = UIAlertController(title: "Not Logged", message: "User needs to looged in first to use this feature", preferredStyle: UIAlertController.Style.alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                    return
                }
            }
        }
        
        let viewController = productRegistrationInterface.instantiateViewController(launchInput, withErrorHandler: completionHandler)
        if viewController != nil {
            if presentPRSwitch.isOn {
                presentableNavigation = UINavigationController(rootViewController: viewController!)
                addCloseButtonTo(presentableNavigation!)
                navigationController?.present(presentableNavigation!, animated: true)
            } else {
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
        }
    }
    
    func addCloseButtonTo(_ navigationController: UINavigationController) {
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissNavigationController))
        navigationController.navigationBar.topItem?.leftBarButtonItem = closeButton
    }
    
    @objc func dismissNavigationController() {
        if presentableNavigation != nil && presentPRSwitch.isOn {
            presentableNavigation!.dismiss(animated: animateExitSwitch.isOn) {
                self.presentableNavigation = nil
            }
        }
    }
    
    func productRegistrationBack(userProduct: PPRUserWithProducts?, products: [PPRRegisteredProduct]) {
        print("Back pressed")
    }
    
    func productRegistrationContinue(userProduct: PPRUserWithProducts?, products: [PPRRegisteredProduct]) {
        print("Continue pressed")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.ctnField
        {
            let oldStr = self.ctnField.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0
            {
                self.registerButton.isEnabled = false
            }
            else
            {
                self.registerButton.isEnabled = true
            }
        }
        return true
    }
}
