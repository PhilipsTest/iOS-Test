//
//  LoggerDetailViewController.swift
//  AppInfraMicroApp
//
//  Created by leslie on 20/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
import PlatformInterfaces

class LoggerDetailViewController: UIViewController, UITextFieldDelegate , TableViewControlDelegate{
    
    @IBOutlet weak var detailsLabel: UIDLabel!
    @IBOutlet weak var eventIdTextField: UIDTextField!
    @IBOutlet weak var messageTextField: UIDTextField!
    @IBOutlet weak var selectFlagButton: UIDButton!
    @IBOutlet weak var cloudSwitch: UISwitch!
    
    @IBOutlet weak var threadNo: UITextField!
    @IBOutlet weak var messageNo: UITextField!
    @IBOutlet weak var msgLength: UITextField!
    
    var delegate : TableViewControlDelegate?
    var selectedFlagIndex = 0
    let logFlags = ["Error", "Warning", "Info", "Debug", "Verbose"]
    var logger:Logger? = nil
    var loggingDict:NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let log = logger {
            self.detailsLabel.text = "\(log.componentName), \(String(describing: log.componentVersion))"
            self.title = log.componentName
        }
        
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "LogDictionary", ofType: "json")!))
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            self.loggingDict = json as? NSDictionary
        } catch {
            print(error)
        }
    }
    
    @IBAction func selectLogFlag(_ sender: Any) {

        if let viewController = UIStoryboard(name: "Main", bundle : Bundle(for: type(of: self))).instantiateViewController(withIdentifier: "customTableViewController") as? CustomTableViewController {
            if let navigator = navigationController {
                viewController.dataSource = logFlags
                viewController.delegate = self
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    
    func updateControl(_ selectedOption: Int) {
        selectFlagButton.setTitle(logFlags[selectedOption], for: UIControl.State())
        selectedFlagIndex = selectedOption
    }
    
    @IBAction func logMessage(_ sender: Any) {
        self.logger?.AILogger.log(AILogLevel(rawValue: self.selectedFlagIndex)!, eventId: self.eventIdTextField.text, message: self.messageTextField.text)
    }
    
    @IBAction func logMessageAndDictionary(_ sender: Any) {
        self.logger?.AILogger.log(AILogLevel(rawValue: self.selectedFlagIndex)!, eventId: self.eventIdTextField.text, message: self.messageTextField.text, dictionary: self.loggingDict as? [AnyHashable : Any])
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func cloudLogTestPressed(_ sender: UIButton) {
        
        let noOfMsgs = Int(messageNo.text ?? "1") ?? 1
        let msgLen = Int(msgLength.text ?? "1") ?? 1
        var imsg = self.messageTextField.text ?? "a"
        imsg = imsg.count == 0 ? "a": imsg
        var msg = ""
        for _ in 1...msgLen {
            msg = msg + imsg
        }
        
        //let message =
        for i in 1...noOfMsgs {
            self.logger?.AILogger.log(AILogLevel(rawValue: self.selectedFlagIndex)!, eventId: self.eventIdTextField.text, message: "\(i):\(msg)")
        }
    }

}
