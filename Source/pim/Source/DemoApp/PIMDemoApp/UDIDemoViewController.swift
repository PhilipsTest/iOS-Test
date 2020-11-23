//
//  ViewController.swift
//  PIMDemoApp
//
//  Created by Chittaranjan Sahu on 2/27/19.
//  Copyright © 2019 Philips. All rights reserved.
//

import UIKit
import PIM
import PIMDemoUApp
import UAPPFramework
import PhilipsUIKitDLS
import PlatformInterfaces

class UDIDemoViewController: UIViewController {
    
    @IBOutlet weak var countrySelectionButton: UIDButton!
    @IBOutlet weak var launchOptionButton: UIDButton!
    
    var microappInstance:PIMDemoUAppInterface!
    var appDependencies: PIMDependencies!
    var launchInput: PIMLaunchInput!
    var udiFlowSelected: PIMLaunchFlow = PIMLaunchFlow.noPrompt
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UDI Demo App"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let countrySelected = getSelectedCountry()
        countrySelectionButton.setTitle(countrySelected, for: .normal)
    }
    
    @IBAction func launchDemoUAppClicked(_ sender: Any) {
        createPIMMicroAppInstance()
        let pimDemoVC = microappInstance?.instantiateViewController(self.launchInput!) { (inError) in
            print("viewcontroller is nil and giving some error")
        }
        self.navigationController?.pushViewController(pimDemoVC!, animated: true)
    }
    
    @IBAction func countryActionClicked(_ sender: Any) {
        countrySelectionButton = sender as? UIDButton
        let countryListDict:[String:String]? = getSupportedCountries()
        guard let countryNames =  countryListDict?.keys.sorted() else {
            return
        }
        let countryAlert = UIAlertController(title: "Countries",
                                             message: "Please select country!!!",
                                             preferredStyle: .actionSheet)
        for country in countryNames {
            let countryAction = UIAlertAction(title: country, style: .default) { [weak self] (_: UIAlertAction) in
                DispatchQueue.main.async {
                    self?.view.isUserInteractionEnabled = false
                    let countryCode = countryListDict![country]
                    self?.serviceDiscoveryDownloadComeplete(country: countryCode!, countryName: country)
                }
            }
            countryAlert.addAction(countryAction)
        }
        showOptionSheet(optionButton: countrySelectionButton, alertController: countryAlert)
    }
    
    @IBAction func launchFlowClicked(_ sender: Any) {
        launchOptionButton = sender as? UIDButton
        let launchOptionsAlert = UIAlertController(title: "UDI Launch Options",
        message: "Please select UDI flow !!!",
        preferredStyle: .actionSheet)
        let launchOptionsList = [PIMLaunchFlow.login, PIMLaunchFlow.create, PIMLaunchFlow.noPrompt]
        for launchOption in launchOptionsList {
            let launchAction = UIAlertAction(title: launchOption.rawValue, style: .default) { [weak self] (_: UIAlertAction) in
                DispatchQueue.main.async {
                    self?.udiFlowSelected = launchOption
                    self?.launchOptionButton.setTitle("UDI Launch Flow - \(launchOption.rawValue)", for: .normal)
                }
            }
            launchOptionsAlert.addAction(launchAction)
        }
        showOptionSheet(optionButton: launchOptionButton, alertController: launchOptionsAlert)
    }
}

// Country selection methods
extension UDIDemoViewController {
    
    func createPIMMicroAppInstance() {
        self.launchInput = PIMLaunchInput(consents: [PIMConsent.ABTestingConsent]) ?? PIMLaunchInput()
        self.launchInput.pimLaunchFlow = self.udiFlowSelected
        let appSettings = PIMSettings()
        appDependencies = PIMDependencies()
        appDependencies.appInfra = appDelegate.appInfraHandler
        let pimMicroAppInstance = PIMDemoUAppInterface(dependencies: appDependencies, andSettings: appSettings)
        microappInstance = pimMicroAppInstance
    }
    
    func handleRedirectURI(url: URL) {
        var delayTime = 0.0
        //Initialise and launch to PIMdemo app.
        if microappInstance == nil {
            delayTime = 5.0
            self.launchDemoUAppClicked(self.countrySelectionButton as Any)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            self.microappInstance?.handleRedirectURIInMicroapp(url: url)
        }
    }
    
    func showOptionSheet(optionButton: UIDButton, alertController: UIAlertController) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            if let currentPopoverpresentioncontroller = alertController.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = optionButton
                currentPopoverpresentioncontroller.sourceRect = optionButton.bounds;
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up;
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getSupportedCountries() -> Dictionary<String, String>? {
        var countriesDict: Dictionary<String, String>?
        let demoUAppBundle = Bundle(for: UDIDemoViewController.self)
        if let path = demoUAppBundle.path(forResource: "SupportedCountryList", ofType: "plist") {
            countriesDict = NSDictionary(contentsOfFile: path) as? [String: String]
        }
        return countriesDict
    }
    
    func getSelectedCountry() -> String? {
        guard let countryCode = appDelegate.appInfraHandler?.serviceDiscovery.getHomeCountry() else {
            return nil;
        }
        let countryListDict:[String:String]? = getSupportedCountries()
        
        return countryListDict?.getDictionaryKeyFromValue(forValue: countryCode).first ?? nil
    }
    
    func serviceDiscoveryDownloadComeplete(country:String,countryName:String) {
        self.appDelegate.appInfraHandler?.serviceDiscovery.setHomeCountry(country)
        self.appDelegate.appInfraHandler?.serviceDiscovery.getServicesWithCountryPreference(["userreg.janrain.api","userreg.janrainoidc.userprofile","userreg.janrainoidc.migration"], withCompletionHandler: { service, error in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                guard error == nil else {
                    self.showAlertMessage("Error changing country")
                    return;
                }
                self.countrySelectionButton.setTitle(countryName, for: .normal)
            }
        }, replacement: nil);
    }
    
    func showAlertMessage(_ inputMessage: String) {
        let alert = UIDAlertController(title: "Message", message: inputMessage)
        let okAction = UIDAction(title: "Ok", style: .primary)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension Dictionary where Value: Equatable {
    func getDictionaryKeyFromValue(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}

