//
//  RegisterProductTableViewController.swift
//  DemoProductRegistrationClient
//
//  Created by DV Ravikumar on 02/02/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
import PhilipsProductRegistration
import PhilipsRegistration
import PhilipsPRXClient

class RegisterProductTableViewController: UITableViewController,PPRRegisterProductDelegate {
    
    @IBOutlet var ctn: UIDTextField!
    @IBOutlet var serialNumber: UIDTextField!
    @IBOutlet var dateOfPurchaseDatePicker: UIDatePicker!
    @IBOutlet weak var sendEmailSwitch: UISwitch!
    @IBOutlet var productRegisterButton: UIDButton!
    
    var activityIndicator: UIActivityIndicatorView!
    fileprivate var productList: [PPRRegisteredProduct]?
    var product: PPRRegisteredProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadActivityIndicatiorView()
                
        self.dateOfPurchaseDatePicker.maximumDate = PPRDemoFrameworkInterfaceWrapper.sharedInstance.interfaceDependencies?.appInfra!.time.getUTCTime()

        if let product = self.product {
            self.loadProductDetails(product)
        }
    }
    
    func loadProductDetails(_ product: PPRRegisteredProduct) {
        self.ctn.text = product.ctn
        self.serialNumber.text = product.serialNumber
        if let purchaseDate = product.purchaseDate {
            self.dateOfPurchaseDatePicker.date = purchaseDate
        }
        
        self.sendEmailSwitch.isOn = product.sendEmail
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerProductAction(_ sender: AnyObject) {
        
        self.startIndicator()
        self.hideRegisterButton(true)
        let ctn: String = self.ctn.text!
        
        let productInfo : PPRProduct = PPRProduct(ctn: ctn, sector: B2C, catalog: CONSUMER)
        productInfo.purchaseDate = self.dateOfPurchaseDatePicker.date
        productInfo.serialNumber = self.serialNumber.text
        productInfo.sendEmail = sendEmailSwitch.isOn
        let registerProductHandler:PPRProductRegistrationHelper =  PPRProductRegistrationHelper()
        registerProductHandler.delegate = self
      
        let userWithProducts = PPRInterfaceInput.sharedInstance.userWithProduct

        userWithProducts.registerProduct(productInfo)
    }
    
        
    func registrationProductCompletedSuccessfully(_ product: PPRRegisteredProduct){
        self.stopIndicator()
        self.hideRegisterButton(false)
        OperationQueue.main.addOperation({ () -> Void in
            self.showAlert(With: "Success", message: String(product.description))
        })
    }
    
    func registrationProductFailed(_ withError: NSError){
        self.stopIndicator()
        self.hideRegisterButton(false)
        OperationQueue.main.addOperation({ () -> Void in
            self.showAlert(With: "Error", message: withError.localizedDescription)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func loadActivityIndicatiorView() {
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint.init(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint.init(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.activityIndicator = activityIndicator
    }
    
    fileprivate func startIndicator(){
        activityIndicator.startAnimating()
    }
    
    fileprivate func stopIndicator(){
        OperationQueue.main.addOperation({ () -> Void in
            self.activityIndicator.stopAnimating()
        })
    }
    
    fileprivate func hideRegisterButton(_ hide:Bool) {
        OperationQueue.main.addOperation({ () -> Void in
            self.productRegisterButton.isHidden = hide
        })
    }
    
    fileprivate func showAlert(With title:String, message:String) {
        let alert = UIDAlertController(title: title, message: message)
        let action = UIDAction(title: "OK", style: .primary, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func productRegistrationDidSucced(userProduct: PPRUserWithProducts, product: PPRRegisteredProduct) {
        self.registrationProductCompletedSuccessfully(product)
    }
    
    func productRegistrationDidFail(userProduct: PPRUserWithProducts, product: PPRRegisteredProduct) {
        self.registrationProductFailed(product.error!)
    }
}
