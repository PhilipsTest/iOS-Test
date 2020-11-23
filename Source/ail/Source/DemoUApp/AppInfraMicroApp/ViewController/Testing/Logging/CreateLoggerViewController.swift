//
//  CreateLoggerViewController.swift
//  AppInfraMicroApp
//
//  Created by leslie on 20/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS

class CreateLoggerViewController: UIViewController {

    @IBOutlet weak var nameTextField: UIDTextField!
    @IBOutlet weak var versionTextField: UIDTextField!
    var completionHandler: ((Logger)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func setCompletion(completionHandler: ((Logger)->Void)?) {
        self.completionHandler = completionHandler
    }
    
    @IBAction func createLogger(_ sender: Any) {
        if let name = nameTextField.text, let version = versionTextField.text {
            if name == "" {
                self.showAlert("Please fill name field")
                return
            }
            if version == "" {
                self.showAlert("Please fill version field")
                return
            }
            let aiLogger = AilShareduAppDependency.shared().uAppDependency.appInfra.logging.createInstance(forComponent: name, componentVersion: version)
            let logger = Logger(name: name, version: version, aiLogger: aiLogger!)
            completionHandler?(logger)
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.showAlert("Please fill all fields")
        }
        
    }
}
