/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import UIKit
import PhilipsUIKitDLS

class HamburgerLeftBarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var hamburgerMenu = [BAHamburgerMenuData]()
    @IBOutlet weak var menuListTableView: UITableView!
    var userRegistrationState: UserRegistrationState?
    @IBOutlet weak var logoutButton: UIDButton!
    @IBOutlet weak var selectedEnvironmentLbl: UIDLabel!
    @IBOutlet weak var userName: UIDLabel!
    var hamburgerMenuDelegate : HamburgerMenuDelegate?
    var presenter : BasePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willAnimateRotation(to toInterfaceOrientation:      UIInterfaceOrientation, duration: TimeInterval)
    {
        self.menuListTableView.reloadData()
    }
    
    func getSelectedEnvironment()->String?{
        do
        {
            if let environment = try AppInfraSharedInstance.sharedInstance.appInfraHandler?.appConfig.getPropertyForKey(Constants.APPINFRA_APPIDENTITY_STATE, group: Constants.APPINFRA_TEXT) as? String{
                return environment
            }
        }catch{
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "ErrorWhileGettingProperty", message: "\(error)")
        }
        return RegistrationEnvironment.Development.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hamburgerMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        if let menuImage = hamburgerMenu[indexPath.row].icon{
            cell.imageView?.image = UIImage(named:menuImage)
        }
        if let menuTitle = hamburgerMenu[indexPath.row].screenTitle{
            cell.textLabel?.text =  Utilites.aFLocalizedString(menuTitle)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMenu = hamburgerMenu[indexPath.row]
        hamburgerMenuDelegate?.didSelectHamburgerMenu(selectedStateData: selectedMenu)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return tableView.frame.height/CGFloat(hamburgerMenu.count)
    }
    
    @IBAction func userProfileTapped(_ sender: Any) {
        if let selectedIndexPath = self.menuListTableView.indexPathForSelectedRow {
            self.menuListTableView.deselectRow(at: selectedIndexPath, animated: false)
        }
        let moveToMyAccount  = BAHamburgerMenuData(menuID: "MyAccount", screenTitle: "MyAccount", icon: nil)
        hamburgerMenuDelegate?.didSelectHamburgerMenu(selectedStateData:moveToMyAccount)
        
    }
    
    
}

// This extention handle the Login Logout Functionality which was previously there in Setting Screen
extension HamburgerLeftBarViewController{
    
    @objc func logoutDidSucceed() {
        let moveToHomeMenu =  hamburgerMenu.filter{ $0.menuID == "Home" }
        if let moveToHomeMenuData = moveToHomeMenu.first{
            hamburgerMenuDelegate?.didSelectHamburgerMenu(selectedStateData:moveToHomeMenuData)
        }
        userName.text = Constants.HAMBURGER_LOGIN_STATUS
    }
    
    /** Action that needs to happen on any response from alertview options */
    func userClickedOnLogout() {
        NotificationCenter.default.addObserver(self, selector: #selector(logoutDidSucceed), name: NSNotification.Name(rawValue: Constants.LOGOUT_SUCCESS_NOTIFICATION), object: nil)
        Utilites.showActivityIndicator(using: self)
    }
    
}


