//
//  LoggerListViewController.swift
//  AppInfraMicroApp
//
//  Created by leslie on 20/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS

struct Logger {
    let componentName:String
    let componentVersion:String
    let AILogger:AILoggingProtocol
    
    init(name:String, version:String, aiLogger:AILoggingProtocol) {
        self.componentName = name
        self.componentVersion = version
        self.AILogger = aiLogger
    }
}

class LoggerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loggerTableView: UITableView!
    var loggerList:Array<Logger> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let propositionLogger = Logger(name: "Proposition logger", version: "NA", aiLogger: AilShareduAppDependency.shared().uAppDependency.appInfra.logging)
        self.loggerList.append(propositionLogger)
        self.loggerTableView.tableFooterView = UIView()
    }

    
    @IBAction func createLoggerClicked(_ sender: Any) {
        let createVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateLoggerViewController") as! CreateLoggerViewController
        createVC.setCompletion { (logger) in
            self.loggerList.append(logger)
            self.loggerTableView.reloadData()
        }
        self.navigationController?.show(createVC, sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.loggerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LoggerTableViewCell
        let logger = self.loggerList[indexPath.row];
        cell.titleLabel.text = logger.componentName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "LoggerDetailViewController") as! LoggerDetailViewController
        detailVC.logger = self.loggerList[indexPath.row];
        self.navigationController?.show(detailVC, sender: self)
        
    }
}

extension UIViewController {
    func showAlert(_ message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
