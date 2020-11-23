//
//  RegisteredProductListViewController.swift
//  DemoProductRegistrationClient
//
//  Created by Sumit Prasad on 14/04/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import Foundation
import PhilipsUIKitDLS
import PhilipsProductRegistration
import PhilipsRegistration

class RegisteredProductListViewController: UIDTableViewController{
    fileprivate lazy var productList = {
        return [PPRRegisteredProduct]()
    }()
    fileprivate var selectedProduct: PPRRegisteredProduct?
    var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadActivityIndicatiorView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()
        let registerProductHandler =  PPRProductRegistrationHelper()
        let userWithProducts = registerProductHandler.getSignedInUserWithProudcts()
        userWithProducts!.getRegisteredProducts({ (response) -> Void in
            self.activityIndicator.stopAnimating()
            let listResponse = response as? PPRProductListResponse
            if let list = listResponse?.data {
                self.productList = list
                self.tableView.reloadData()
            }
        }, failure: { (error) in
            self.activityIndicator.stopAnimating()
        })
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ProductList"
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cellIdentifier = "ListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ListTableViewCell
        let product = self.productList[indexPath.row]
        cell.lblCTN?.text = "CTN: "+product.ctn
        cell.lblStatus?.text = "Status: "+self.getStringForState(product.state)
        if let serialNumber = product.serialNumber {
            cell.lblSerialNumber?.text = "SerialNumber: "+serialNumber
        } else {
            cell.lblSerialNumber?.text = "SerialNumber: "
        }
        
        if let error = product.error {
            cell.lblError?.text = "Error: "+error.domain
        } else {
            cell.lblError?.text = "Error: "
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.productList[indexPath.row]
        self.selectedProduct = product
        performSegue(withIdentifier: "registration view controller", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "registration view controller") {
            let detailVC = segue.destination as! RegisterProductTableViewController
            detailVC.product = self.selectedProduct
        }
    }
    
    fileprivate func getStringForState(_ state: State) -> String {
        switch state {
        case .FAILED:
            return "FAILED"
        case .REGISTERED:
            return "REGISTERED"
        default: return "PENDING"
        }
    }
    
    fileprivate func loadActivityIndicatiorView() {
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint.init(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint.init(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.activityIndicator = activityIndicator
    }
}
