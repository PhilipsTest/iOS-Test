/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AppInfra
import PhilipsUIKitDLS


enum RegistrationEnvironment: String {
    case Test = "Test"
    case Development = "Development"
    case Production = "Production"
    case Staging = "Staging"
    case Acceptance = "Acceptance"
}

enum PropertyAccessor : Int {
    case set = 0
    case get
}

/** UserRegEnvSettingsViewController is to select Registration Environment among Test or Eval or Dev or Production or Staging*/
class UserRegEnvSettingsViewController: UIDTableViewController {
    
    //MARK: Variable Declarations
    var tableViewItems = [RegistrationEnvironment]()
    var currentEnvironment: RegistrationEnvironment?
    var selectedIndexPath: IndexPath?
    var userRegistrationState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistration) as? UserRegistrationState
    
    //MARK: Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        createtableView()
        getUserRegistrationEnvironment()
        //AppInfra logging
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "UserRegEnvSettingsViewController:viewDidLoad", message: "Launching Debug screen to change application environment state")    }
    
    func getUserRegistrationEnvironment() {
        if let environmentDetails = Utilites.handlePropertyForKey(userRegistrationState!, typeOfAccessor: .get, key: Constants.APPINFRA_APPIDENTITY_STATE, group: Constants.APPINFRA_TEXT, value: nil) {
            currentEnvironment = RegistrationEnvironment(rawValue: environmentDetails as! String)
        } else {
            currentEnvironment = RegistrationEnvironment.Development
        }
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "UserRegEnvSettingsViewController:getUserRegistrationEnvironment", message: "Changed application environment state to \(String(describing: currentEnvironment))")
    }
    
    /** Creating table view contents to load */
    func  createtableView()  {
        
        tableViewItems = [RegistrationEnvironment.Test, RegistrationEnvironment.Development, RegistrationEnvironment.Staging]
    }
    
    @objc func logoutDidSucceed() {
        
            Utilites.showDLSAlert(withTitle: Constants.USERREGISTRATION_ENVIRONMENT_ALERT_TITLE , withMessage: Constants.USERREGISTRATION_ENVIRONMENT_ALERT_MESSAGE , buttonAction: [UIDAction(title: Constants.OK_TEXT!, style: .primary)], usingController: self)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.LOGOUT_SUCCESS_NOTIFICATION), object: nil)
    }
    
    
    // MARK: Table view data source
    /** Table view Datasource method */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    /** Table view Datasource method */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewItems.count
    }
    
    /** Table view Datasource method */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.USERREGISTRATION_ENVIRONENT_SETTING_CELL_ID, for: indexPath as IndexPath)
        
        let cellTitle = tableViewItems[indexPath.row]
        // Configure the cell...
        cell.textLabel!.text = cellTitle.rawValue
        cell.accessoryType = UITableViewCell.AccessoryType.none
        cell.backgroundColor = .clear
        if currentEnvironment?.rawValue == cellTitle.rawValue {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            selectedIndexPath = indexPath
        }
        return cell
    }
    
    /** Table view Delegate method */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            let selectedCell = tableView.cellForRow(at: indexPath)
            let selectedEnvironment = tableViewItems[indexPath.row]
            
        selectedCell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
            if selectedIndexPath != nil {
                let previousSelectedCell = tableView.cellForRow(at: selectedIndexPath! as IndexPath)
                if currentEnvironment?.rawValue != selectedEnvironment.rawValue {
                    previousSelectedCell?.accessoryType = UITableViewCell.AccessoryType.none
                    //Logout on Environment change
                    userRegistrationState?.logoutFromUserRegistration()
                    NotificationCenter.default.addObserver(self, selector: #selector(logoutDidSucceed), name: NSNotification.Name(rawValue: Constants.LOGOUT_SUCCESS_NOTIFICATION), object: nil)
                    //Set property
                    _ = Utilites.handlePropertyForKey(userRegistrationState!, typeOfAccessor: .set, key: Constants.APPINFRA_APPIDENTITY_STATE, group: Constants.APPINFRA_TEXT, value: selectedEnvironment.rawValue as AnyObject?)
                    currentEnvironment = selectedEnvironment
                }
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "UserRegEnvSettingsViewController", message: "Selected application environment state : \(String(describing: currentEnvironment))")
            }
            selectedIndexPath = indexPath
        }
}

