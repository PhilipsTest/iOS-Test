//
//  AppUpdateViewController.swift
//  DemoAppInfra
//
//  Created by Hashim MH on 18/05/17.
//  Copyright © 2017 philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS

class AppUpdateViewController: UIViewController {
    let appUpdate = AilShareduAppDependency.shared().uAppDependency.appInfra.appUpdate!
    
    @IBOutlet weak var textView: UIDTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        textView?.text = ""
        self.appUpdate.refresh { (status, error) in
            
            if error != nil {
                self.textView?.text = error?.localizedDescription
            }
            else{
                self.textView?.text = "Refreshed Succesfully \n"
                self.updateValues()
            }
        }
    }
    
    @IBAction func fetchPressed(_ sender: Any) {
        self.textView?.text = "Fetching from local file \n"
        updateValues()
    }
    
    func updateValues(){
    
        self.textView?.text = (self.textView?.text)! + "isDeprecated : \(appUpdate.isDeprecated()) \n"
        self.textView?.text = (self.textView?.text)! + "isToBeDeprecated : \(appUpdate.isToBeDeprecated()) \n"
        self.textView?.text = (self.textView?.text)! + "isUpdateAvailable : \(appUpdate.isUpdateAvailable()) \n"
        
        if let depMsg = appUpdate.getDeprecateMessage(){
                self.textView?.text = (self.textView?.text)! + "getDeprecateMessage : \(String(describing:depMsg)) \n"
        }
        else{
            self.textView?.text = (self.textView?.text)! + "getDeprecateMessage : null \n"
        }
        
        if let toBedepMsg = appUpdate.getToBeDeprecatedMessage() {
            self.textView?.text = (self.textView?.text)! + "getToBeDeprecatedMessage : \(String(describing: toBedepMsg)) \n"
            
        }
        else{
            self.textView?.text = (self.textView?.text)! + "getToBeDeprecatedMessage : null \n"
            
        }

        if let updateMsg =  appUpdate.getUpdateMessage() {
            self.textView?.text = (self.textView?.text)! + "getUpdateMessage : \(String(describing: updateMsg)) \n"
        }
        else{
            self.textView?.text = (self.textView?.text)! + "getUpdateMessage : null \n"
            
        }
        
        if let minVersionMsg =  appUpdate.getMinimumVersion(){
            self.textView?.text = (self.textView?.text)! + "MinVersion : \(String(describing: minVersionMsg)) \n"
            }
            else{
                self.textView?.text = (self.textView?.text)! + "MinVersion : null \n"
                
        }

        if let osVersionMsg = appUpdate.getMinimumOsVersion() {
            self.textView?.text = (self.textView?.text)! + "getMinimumOsVersion : \(String(describing: osVersionMsg)) \n"
            }
            else{
                self.textView?.text = (self.textView?.text)! + "getMinimumOsVersion : null \n"
        }
        
        if let minimumOSMessage = appUpdate.getMinimumOsMessage() {
            self.textView?.text = (self.textView?.text)! + "getMinimumOsMessage : \(String(describing: minimumOSMessage)) \n"
        }
        else {
            self.textView?.text = (self.textView?.text)! + "getMinimumOsMessage : null \n"
        }

        DispatchQueue.main.async(execute: {() -> Void in
               self.checkForUpdates()
        })
     
    }
    
    
    func checkForUpdates(){
      
        var message = ""
        if appUpdate.isDeprecated(){
            if let msg = appUpdate.getDeprecateMessage() { message = msg }
        }
        else if appUpdate.isToBeDeprecated(){
            if let msg = appUpdate.getToBeDeprecatedMessage() { message = msg }
            
        }
        else if appUpdate.isUpdateAvailable(){
            if let msg = appUpdate.getUpdateMessage() { message = msg }
        }
        
        if !message.isEmpty {
            let alert = UIAlertController(title: "AppUpdate", message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
}
