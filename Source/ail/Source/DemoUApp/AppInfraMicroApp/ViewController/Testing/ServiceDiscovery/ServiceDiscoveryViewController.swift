//
//  ServiceDiscoveryViewController.swift
//  DemoAppInfra
//
//  Created by leslie on 13/12/16.
//  Copyright © 2016 philips. All rights reserved.
//

import UIKit
import AppInfra
import PhilipsUIKitDLS

class ServiceDiscoveryViewController: UIViewController, UITextFieldDelegate, TableViewControlDelegate {
    
    @IBOutlet weak var serviceIDTextField: UIDTextField!
    @IBOutlet weak var countryCodeTextField: UIDTextField!
    @IBOutlet weak var activityView: UIDView!
    @IBOutlet weak var selectButton: UIDButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate : TableViewControlDelegate?
    let methodNames = ["getHomeCountry", "getHomeCountry-synchronous", "getServicesWithLanguagePreference&replacement", "getServicesWithCountryPreference&replacement"];
    var selectedMethodIndex = 0
    var serviceDiscovery:AIServiceDiscoveryProtocol!{
        get {
            return AilShareduAppDependency.shared().uAppDependency.appInfra.serviceDiscovery
            }
        }

    var replacementValues:Dictionary<String,String>?
    let replaceErrorMessage = "Please provide values for replacement, you can edit the SDReplacementValues file in the project"
    let noServiceURLError = "No URL found for the service ID entered"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton.setTitle(methodNames[selectedMethodIndex], for: UIControl.State())
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "SDReplacementValues", ofType: "json")!))
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            replacementValues = json as? Dictionary
        } catch {
            print(error)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleCountryChange(notification:)),
            name: NSNotification.Name.AILServiceDiscoveryHomeCountryChanged,
            object: nil)
        
        self.hideActivityIndicator()
    }
    
    @IBAction func selectMethodButtonTapped(_ sender: Any) {
        if let viewController = UIStoryboard(name: "Main", bundle : Bundle(for: type(of: self))).instantiateViewController(withIdentifier: "customTableViewController") as? CustomTableViewController {
            if let navigator = navigationController {
                viewController.dataSource = methodNames
                viewController.delegate = self
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    func updateControl(_ selectedOption: Int) {
        selectButton.setTitle(methodNames[selectedOption], for: UIControl.State())
        selectedMethodIndex = selectedOption
    }
    
    @IBAction func invokeButtonTapped(_ sender: AnyObject) {
        if validateUI() {
        // test internet check method call , this can be deleted
            logInternetReachability()
            let serviceIDs = serviceIDTextField.text?.components(separatedBy: ",")
            switch selectedMethodIndex {
            case 0:
                showActivityIndicator()
                serviceDiscovery?.getHomeCountry({ (countryCode, sourceType, error) in
                    DispatchQueue.main.async {
                        if (error == nil) {
                            if let code = countryCode, let type = sourceType {
                                self.showAlertWithMessage("Country Code:\(code) Source Type:\(type)")
                            }
                        }
                        else {
                            self.showAlertWithMessage((error?.localizedDescription)!)
                        }
                        self.hideActivityIndicator()
                    }
                })
            case 1:
                let country = serviceDiscovery?.getHomeCountry();
                if let country = country {
                    self.showAlertWithMessage("country : \(country)")
                }
                else {
                    self.showAlertWithMessage("null");
                }
            case 2:
                if let replacement = replacementValues {
                    showActivityIndicator()
                    serviceDiscovery?.getServicesWithLanguagePreference(serviceIDs, withCompletionHandler: { (services, error) in
                        self.handleServices(services, error: error as NSError?)
                        }, replacement: replacement)
                }
                else {
                    showAlertWithMessage(replaceErrorMessage)
                }
            case 3:
                if let replacement = replacementValues {
                    showActivityIndicator()
                    serviceDiscovery?.getServicesWithCountryPreference(serviceIDs, withCompletionHandler: { (services, error) in
                        self.handleServices(services, error: error as NSError?)
                        }, replacement: replacement)
                }
                else {
                    showAlertWithMessage(replaceErrorMessage)
                }
            default: break
                
            }
        }
    }

    @IBAction func setHomeCountryTapped(_ sender: AnyObject) {
        if countryCodeTextField.text == nil || countryCodeTextField.text == "" {
            showAlertWithMessage("Please enter Country Code")
            return
        }
        serviceDiscovery?.setHomeCountry(countryCodeTextField.text)
    }
    
    func validateUI() -> Bool {
        if selectedMethodIndex != 0 && selectedMethodIndex != 1  {
            if serviceIDTextField.text == nil || serviceIDTextField.text == "" {
                showAlertWithMessage("Please enter service ID")
                return false
            }
        }
        return true
    }
    
    func logInternetReachability() {
        var reachability: AIRESTClientReachabilityStatus
           reachability = AilShareduAppDependency.shared().uAppDependency.appInfra.restClient.getNetworkReachabilityStatus()
        switch reachability {
        case AIRESTClientReachabilityStatus.notReachable:
            print("________AIRESTClientReachabilityStatusNotReachable________")
        case AIRESTClientReachabilityStatus.reachableViaWWAN:
            print("________AIRESTClientReachabilityStatusReachableViaWWAN________")
        case AIRESTClientReachabilityStatus.reachableViaWiFi:
            print("________AIRESTClientReachabilityStatusReachableViaWiFi________")
        
        }
        
    }
    
    
    func showAlertWithMessage(_ message:String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        self.activityView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    func handle(_ serviceURL:String?, error:NSError?) {
        DispatchQueue.main.async {
            if (error == nil) {
                
                if let serviceURL = serviceURL{
                  self.showAlertWithMessage(serviceURL)
                }
                else{
                   self.showAlertWithMessage(self.noServiceURLError)
                }
            
            }
            else {
                self.showAlertWithMessage(error!.localizedDescription)
            }
            self.hideActivityIndicator()
        }
    }
    
    func handleServices(_ services:[String : AISDService]?, error:NSError?) {
        DispatchQueue.main.async {
            if (error == nil) {
                if let services = services {
                    self.showAlertWithMessage(services.description)
                }
                else {
                    self.showAlertWithMessage(self.noServiceURLError)
                }
            }
            else {
                self.showAlertWithMessage(error!.localizedDescription)
            }
            self.hideActivityIndicator()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func handleCountryChange(notification:NSNotification) {
        if let info = notification.userInfo as? Dictionary<String,String> {
            if let country = info["ail.servicediscovery.homeCountry"] {
                AilShareduAppDependency.shared().uAppDependency.appInfra.logging.log(.info, eventId: "Service Discovery", message: "home country changed to \(country)")
            }
        }
        
    }
}
