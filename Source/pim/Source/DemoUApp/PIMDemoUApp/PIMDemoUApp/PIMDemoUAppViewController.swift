//
//  PIMDemoUAppViewController.swift
//  PIMDemoUApp
//
//  Created by Philips on 4/1/19.
//  Copyright © 2019 Philips. All rights reserved.
//

import UIKit
import PIM
import AppInfra
import AdobeMobileSDK
import PhilipsUIKitDLS
import PlatformInterfaces
import PhilipsProductRegistrationUApp
import PhilipsProductRegistration
import ECSTestUApp
import InAppPurchase
import MobileEcommerceDemoUApp
import MobileEcommerce
import PhilipsRegistration

class PIMDemoUAppViewController: UIViewController {
    
    @IBOutlet weak var consentSwitch: UISwitch!
    @IBOutlet weak var marketingConsentSwitch: UISwitch!
    @IBOutlet weak var migrationSwitch: UISwitch!
    @IBOutlet weak var guestUserButton: UIDButton!
    @IBOutlet weak var udiLoginButton: UIDButton!
    @IBOutlet weak var leagcyURButton: UIDButton!
    @IBOutlet weak var migrationButton: UIDButton!
    @IBOutlet weak var launchPRButton: UIDButton!
    @IBOutlet weak var activityIndicator : UIDProgressIndicator!
    
    private var pimHandler: PIMInterface!
    private var urHandler: URInterface!
    
    /*pim dependencies*/
    var pimAppInfraHandler: AIAppInfra?
    var pimLaunchInput: PIMLaunchInput?
    var pimSettings: PIMSettings?
    var pimAppDependencies: PIMDependencies!
    var pimDataInterface: UserDataInterface?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(activityIndicator)
        self.activityIndicator.stopAnimating()
        self.title = "UDI Demo UApp"
        self.initializePIM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUIWrtRegistrationFlow()
        pimHandler.pimCompletionHandler = { error in
            self.handleMigrationBlock(error: error, isSilentMIgration: false,isRedirection: true)
        }
    }
    
    func handleURL(link:URL) {
        pimHandler?.startRedireURIHandling(url: link)
    }
    
}

// IBActions of user interface
extension PIMDemoUAppViewController {
    
    @IBAction func launchGuestUser(_ sender: Any) {
        assignDataInterface(true)
        if let guestUserVC = self.pimDataInterface?.instantiateWithGuestUser?("com.philips.platform.lumea") {
            self.navigationController?.pushViewController(guestUserVC, animated: true)
        }
    }
    
    @IBAction func launchPimLogin(_ sender: Any) {
        assignDataInterface(true)
        let pimViewController = self.pimHandler.instantiateViewController(self.pimLaunchInput!) { (inError) in
            print("error message: \(String(describing: inError))")
        }
        self.navigationController?.pushViewController(pimViewController!, animated: true);
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        activityIndicator.startAnimating()
        pimDataInterface?.addUserDataInterfaceListener(self)
        pimDataInterface?.logoutSession()
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        activityIndicator.startAnimating()
        pimDataInterface?.addUserDataInterfaceListener(self)
        pimDataInterface?.refreshSession()
    }
    
    @IBAction func migrateURUserTouchedUpIn(_ sender: Any) {
        assignDataInterface(true)
        //Over rides silent migration call back and uses the earlier call back.
        pimHandler.migrateJanrainUserToPIM(completionHandler: {
            aError in
            self.handleMigrationBlock(error: aError, isSilentMIgration: false)
        })
    }
    
    @IBAction func getUserDetails(_ sender: Any) {
        if pimDataInterface?.loggedInState() == .userLoggedIn {
            let details = try? pimDataInterface?.userDetails([UserDetailConstants.ACCESS_TOKEN,UserDetailConstants.RECEIVE_MARKETING_EMAIL,UserDetailConstants.FAMILY_NAME,UserDetailConstants.GIVEN_NAME,UserDetailConstants.EMAIL])
            let message = "User details :\nToken - \((details?[UserDetailConstants.ACCESS_TOKEN] as? String) ?? "No access token" )\n Email - \((details?[UserDetailConstants.EMAIL] as? String) ?? "NA")\n Family Name - \((details?[UserDetailConstants.FAMILY_NAME] as? String) ?? "NA")\n Given Name - \((details?[UserDetailConstants.GIVEN_NAME] as? String) ?? "NA")\n Marketing Optin - \(details?[UserDetailConstants.RECEIVE_MARKETING_EMAIL] as! Bool)"
            showAlertMessage(message)
            updateUIWrtMarketingConsent()
        } else {
            showAlertMessage("User is not logged in")
        }
    }
    
    @IBAction func refetchUserDetails(_ sender: Any) {
        guard pimDataInterface?.loggedInState() == .userLoggedIn else {
            showAlertMessage("User is not logged in")
            return
        }
        activityIndicator.startAnimating()
        pimDataInterface?.addUserDataInterfaceListener(self)
        pimDataInterface?.refetchUserDetails()
    }
    
    @IBAction func checkUDIToken(_ sender: Any) {
        guard pimDataInterface?.loggedInState() == .userLoggedIn else {
            showAlertMessage("User is not logged in")
            return
        }
        let isUDIToken: Bool = (pimDataInterface?.isOIDCToken())!
        isUDIToken ? showAlertMessage("User is logged in via UDI") : showAlertMessage("User is logged in via UR")
    }
    
    @IBAction func invalidateUDIToken(_ sender: Any) {
        self.activityIndicator.startAnimating()
        let tokenRevokeURL = URL(string: "https://stg.accounts.philips.com/c2a48310-9715-3beb-895e-000000000000/login/token/revoke")
        var urlRequest:URLRequest = URLRequest(url: tokenRevokeURL!)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = ["content-type":"application/x-www-form-urlencoded", "Authorization":"No auth"]
        urlRequest.httpBody = revokeTokenBodyContent()
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if (error == nil) {
                    let receivedData = String(decoding: data!, as: UTF8.self)
                    self.showAlertMessage("Message: \(receivedData)")
                }else {
                    self.showAlertMessage(error!.localizedDescription)
                }
            }
        }.resume()
    }
    
    @IBAction func launchProductRegistration(_ sender: Any) {
        let prDemoDependencies = PPRInterfaceDependency()
        prDemoDependencies.appInfra = pimAppDependencies.appInfra
        prDemoDependencies.userDataInterface = pimDataInterface
        let prDemoInterface = PPRDemoFrameworkInterface(dependencies: prDemoDependencies, andSettings: nil)
        let launchInput = PPRDemoFrameworkLaunchInput()
        let viewController: UIViewController? = prDemoInterface.instantiateViewController(launchInput, withErrorHandler: {(_ error: Error?) -> Void in
            // TODO: to handle completion handler
            guard let aError = error else {
                return;
            }
            self.showAlertMessage(aError.localizedDescription)
        })
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    @IBAction func launchEcommerceTestApp(_ sender: Any) {
        let launchInput = ECSTestUAppLaunchInput()
        let appSettings = ECSTestUAppSettings()
        let appDependencies = ECSTestUAppDependencies()
        appDependencies.appInfra = pimAppDependencies.appInfra
        appDependencies.userDataInterface = pimDataInterface
        let ecsMicroAppInstance = ECSTestUAppInterface(dependencies: appDependencies, andSettings: appSettings)
        let ecsDemoVC = ecsMicroAppInstance.instantiateViewController(launchInput) { (inError) in
            print("viewcontroller is nil and giving some error")
        }
        self.navigationController?.pushViewController(ecsDemoVC!, animated: true)
    }
    
    @IBAction func launchMECDemoUApp(_ sender: Any) {
        let mecSettings = MECSettings()
        let mecDependencies = MECDependencies()
        mecDependencies.appInfra = pimAppDependencies.appInfra
        mecDependencies.userDataInterface = pimDataInterface
        let mecMicroAppInstance = MECDemoUAppInterface(dependencies: mecDependencies, andSettings: mecSettings)
        let mecLaunchInput = MECLaunchInput()
        let viewController = mecMicroAppInstance.instantiateViewController(mecLaunchInput) { (error) in
            print("MEC viewcontroller is nil and giving some error")
        }
        guard let mecUAppViewController = viewController else { return }
        self.navigationController?.pushViewController(mecUAppViewController, animated: true)
    }
    
    @IBAction func launchInAppPurchase(_ sender: Any) {
        let iapFlowInput = IAPFlowInput(inCTNList: [])
        let iapLaunchInput = IAPLaunchInput()
        let iapSettings = IAPSettings()
        let iapDependencies = IAPDependencies()
        iapDependencies.appInfra = pimAppDependencies.appInfra
        iapDependencies.userDataInterface = pimDataInterface
        
        iapLaunchInput?.setIAPFlow(.iapCategorizedCatalogueView, withSettings: iapFlowInput)
        let iapInterface: IAPInterface = IAPInterface(dependencies: iapDependencies, andSettings: iapSettings)
        
        let productCatalogueVC: UIViewController? = iapInterface.instantiateViewController(iapLaunchInput!) { (inError) in
            // TODO: error handling is not done as its a proof of concept to show IAP is compatible with PIM.
        }
        
        if let viewController = productCatalogueVC {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func updateMarketingOptinConsent(_ sender: Any) {
        if pimDataInterface?.loggedInState() == .userLoggedIn {
            let isMarketingConsentOn = self.marketingConsentSwitch.isOn
            pimDataInterface?.addUserDataInterfaceListener(self)
            pimDataInterface?.updateReceiveMarketingEmail(isMarketingConsentOn)
        } else {
            showAlertMessage("User is not logged in")
        }
    }
    
    @IBAction func launchURLogin(_ sender: Any) {
        assignDataInterface(false)
        let urLaunchInput = URLaunchInput()
        let urViewController = urHandler.instantiateViewController(urLaunchInput, withErrorHandler: { (_) in })
        if let urVC = urViewController {
            self.navigationController?.pushViewController(urVC, animated: true)
        }
    }
    
    @IBAction func analyticsConsentValueChanged(_ sender: UISwitch) {
        guard sender.isOn else {
            pimAppDependencies.appInfra.tagging.setPrivacyConsent(.optOut)
            return
        }
        pimAppDependencies.appInfra.tagging.setPrivacyConsent(.optIn)
    }
    
    @IBAction func enableMigrationValueChanged(_ sender: UISwitch) {
        guard sender.isOn else {
            updateUIWrtRegistrationFlow()
            return
        }
        updateUIWrtMigrationFlow()
    }
}

//Private methods
extension PIMDemoUAppViewController {
    
    private func initializePIM() {
        if(pimHandler != nil) {
            pimHandler = nil
            pimDataInterface = nil
        }
        pimHandler = PIMInterface(dependencies: pimAppDependencies, andSettings: pimSettings)
        pimHandler.userDataInterface().isOIDCToken() ? assignDataInterface(true) : assignDataInterface(false)
        // if logged in no migration.
        // this provides call back if silent migration is happening at the current time.
        if pimDataInterface?.loggedInState() != .userLoggedIn {
            pimHandler.migrateJanrainUserToPIM(completionHandler: {
                error in
                //Blocking janrain not logged in error as it can be frequent to stop annoying.
                if error?.code != 1001 {
                    self.handleMigrationBlock(error: error, isSilentMIgration: true)
                }
            })
        }
    }
    
    private func handleMigrationBlock(error:Error?,isSilentMIgration:Bool,isRedirection:Bool = false) {
        var message = ""
        let statusOf = (true == isRedirection) ? "redirection" : "Migration" ;
        if error == nil {
            
            let userDetails =  try? self.pimDataInterface?.userDetails([UserDetailConstants.GIVEN_NAME, UserDetailConstants.EMAIL])
            message = "User \(statusOf) success \(String(describing: userDetails?[UserDetailConstants.GIVEN_NAME])) and \(String(describing: userDetails?[UserDetailConstants.EMAIL]))"
        } else {
            message = error?.localizedDescription ?? "\(statusOf) error"
        }
        
        if isSilentMIgration == true {
            message = "Silent migration status :" + message
        }
        let alert = UIDAlertController(title: "Message", message: message)
        let okAction = UIDAction(title: "Ok", style: .primary)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlertMessage(_ inputMessage: String) {
        let alert = UIDAlertController(title: "Message", message: inputMessage)
        let okAction = UIDAction(title: "Ok", style: .primary)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func revokeTokenBodyContent() -> Data {
        let details = try? pimDataInterface?.userDetails([UserDetailConstants.ACCESS_TOKEN])
        let accessToken = details?[UserDetailConstants.ACCESS_TOKEN]
        let postData = NSMutableData(data: "client_id=94e28300-565d-4110-8919-42dc4f817393".data(using: String.Encoding.utf8)!)
        postData.append("&token_type_hint=access_token".data(using: String.Encoding.utf8)!)
        postData.append("&token=\(accessToken)".data(using: String.Encoding.utf8)!)
        return postData as Data
    }
    
    private func removeRegisteredListener() {
        activityIndicator.stopAnimating()
        pimDataInterface?.removeUserDataInterfaceListener(self)
    }
    
    private func isURFlowSupported() -> Bool {
        let countryCode = pimAppDependencies.appInfra.serviceDiscovery.getHomeCountry()
         return (countryCode == "CN" || countryCode == "RU")
    }
    
    private func updateUIWrtRegistrationFlow() {
        let isLegacyURSupported = isURFlowSupported()
        udiLoginButton.isEnabled = !isLegacyURSupported
        migrationButton.isEnabled = !isLegacyURSupported
        leagcyURButton.isEnabled = isLegacyURSupported
    }
    
    private func updateUIWrtMigrationFlow() {
        udiLoginButton.isEnabled = true
        migrationButton.isEnabled = true
        leagcyURButton.isEnabled = true
    }
    
    private func assignDataInterface(_ isUDIDataInterface: Bool) {
        pimDataInterface = nil
        guard isUDIDataInterface else {
            let userRegistrationDependencies = URDependencies()
            userRegistrationDependencies.appInfra = pimAppDependencies.appInfra
            urHandler = URInterface(dependencies: userRegistrationDependencies, andSettings: nil)
            pimDataInterface = urHandler.userDataInterface()
            return
        }
        pimDataInterface = pimHandler.userDataInterface()
    }
    
    private func updateUIWrtMarketingConsent() {
        let userDetails =  try? self.pimDataInterface?.userDetails([UserDetailConstants.RECEIVE_MARKETING_EMAIL])
        if let isMarketingConsent = userDetails?[UserDetailConstants.RECEIVE_MARKETING_EMAIL] as? Bool {
           marketingConsentSwitch.setOn(isMarketingConsent, animated: false)
        }
    }
}

// UserdataInterface delegate callbacks
extension PIMDemoUAppViewController: UserDataDelegate {
    
    func logoutSessionSuccess() {
        removeRegisteredListener()
        showAlertMessage("Logout session successful")
    }
    
    func logoutSessionFailed(_ error: Error) {
        removeRegisteredListener()
        showAlertMessage("Logout session failed with error: \(error.localizedDescription)")
    }
    
    func refreshSessionSuccess() {
        removeRegisteredListener()
        showAlertMessage("Refresh session successful")
    }
    
    func refreshSessionFailed(_ error: Error) {
        removeRegisteredListener()
        showAlertMessage("Refresh session failed with error: \(error.localizedDescription)")
    }
    
    func forcedLogout() {
        removeRegisteredListener()
    }
    
    func refetchUserDetailsSuccess() {
        removeRegisteredListener()
        updateUIWrtMarketingConsent()
        showAlertMessage("Refetch user details successful")
    }
    
    func refetchUserDetailsFailed(_ error: Error) {
        removeRegisteredListener()
        showAlertMessage("Refetch user details failed with error: \(error.localizedDescription)")
    }
    
    func updateUserDetailsSuccess() {
        removeRegisteredListener()
        updateUIWrtMarketingConsent()
        showAlertMessage("Update user details successful")
    }
    
    func updateUserDetailsFailed(_ error: Error) {
        removeRegisteredListener()
        updateUIWrtMarketingConsent()
        showAlertMessage("Update user details failed with error: \(error.localizedDescription)")
    }
}
