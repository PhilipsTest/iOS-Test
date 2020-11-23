//
//  DemoLanguageViewController.swift
//  DemoAppInfra
//
//  Created by Hashim MH on 14/03/17.
//  Copyright © 2017 philips. All rights reserved.
//

import UIKit
import AppInfra
import Foundation
import PhilipsUIKitDLS

class DemoLanguageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var refreshStatusLabel: UIDLabel!
    @IBOutlet weak var activateStatusLabel: UIDLabel!
    @IBOutlet weak var localeLabel: UIDLabel!
    @IBOutlet weak var welcomeLabel: UIDLabel!
    @IBOutlet weak var keytextField: UIDTextField!
    @IBOutlet weak var stringTextView: UIDTextView!
    
    var languagePack:AILanguagePackProtocol? // = AppDelegate.sharedAppDelegate().appInfra.languagePack
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        languagePack = AilShareduAppDependency.shared().uAppDependency.appInfra.languagePack
    }
    
    
    @IBAction func refreshPressed(_ sender: UIDButton) {
        self.refreshStatusLabel.text = "Please wait while refreshing . . ."
        languagePack!.refresh { (result, error) in
            
            var message = ""
            if let error = error {
                message = error.localizedDescription
            }
            else{
                message = self.languagePack!.description
            }
            
            DispatchQueue.main.async(execute: { [unowned self] in
                let alert = UIAlertController(title: self.refreshStatusString(result), message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.refreshStatusLabel.text = self.refreshStatusString(result)
            })
        }
    }
    
    
    @IBAction func activatePressed(_ sender: UIDButton) {
        languagePack!.activate { (result, error) in
            
            var message = ""
            if let error = error {
                message = error.localizedDescription
            }
            else{
                message = self.activateStatusString(result)
            }
            
            DispatchQueue.main.async(execute: { [unowned self] in
                let alert = UIAlertController(title: self.activateStatusString(result), message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.refreshStatusLabel.text = self.activateStatusString(result)
                self.updateUI();
            })
            
        }
    }
    
    func updateUI()  {
        if let locale = languagePack?.localizedString(forKey: "locale"){
           localeLabel.text = locale
        }
        else{
            localeLabel.text = ""
        }
        
        if let welcome_Text = languagePack?.localizedString(forKey: "welcome_Text"){
            welcomeLabel.text = welcome_Text
        }
        else{
            welcomeLabel.text = ""
        }
    }
    
    @IBAction func localizedStringPressed(_ sender: UIDButton) {
        if let key = keytextField.text{
            stringTextView.text = languagePack?.localizedString(forKey: key);
        }
    }
    
    
    func refreshStatusString(_ status:AILPRefreshStatus) -> String{
        var statusString = ""
        switch status {
        case .noRefreshRequired :
            statusString = "NoRefreshRequired"
        case .refreshedFromServer :
            statusString = "RefreshedFromServer"
        case .refreshFailed:
            statusString = "RefreshFailed"
        }
        return statusString
    }
    func activateStatusString(_ status:AILPActivateStatus) -> String{
        var statusString = ""
        switch status {
        case .updateActivated:
            statusString = "updateActivated"
        case .noUpdateStored :
            statusString = "noUpdateStored"
        case .failed :
            statusString = "failed"
        }
        return statusString
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
