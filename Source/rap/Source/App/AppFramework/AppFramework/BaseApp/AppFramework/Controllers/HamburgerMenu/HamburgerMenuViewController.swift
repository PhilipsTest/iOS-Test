/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

struct BAHamburgerMenuData {
    var menuID : String?
    var screenTitle: String?
    var icon : String?
}
public enum SecurityIdentifier :String{
    case PASSCODE_TEXT = "Passcode"
    case JAILBREAK_TEXT = "Jailbreak"
    case PASSCODE_AND_JAILBREAK_TEXT = "PasscodeAndJailbreak"
}

/**Hamburger menu Controller*/
class HamburgerMenuViewController: UIDSideBarViewController, HamburgerMenuDelegate {
    //MARK: Variable Declarations
    var hamburgerMenuList = [BAHamburgerMenuData]()
    var presenter : BasePresenter?
    var menuListViewController : HamburgerLeftBarViewController?
    var middleController: UIViewController?
    var overlayViewController: OverlayViewController?
    var overlayView: UIView?
    //MARK: Default methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HamburgerMenuPresenter(_viewController: self)
        configureUI()
        let homeMenuData =  hamburgerMenuList.filter{ $0.menuID == "Home" }
        showHamburgerMenu(menu: homeMenuData.first)
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "HamburgerMenuViewController:viewDidLoad" , message: Constants.LOGGING_HAMBURGERMENU_LAUNCH)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let usrState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistration) as? UserRegistrationState
        usrState?.userRegistrationViewController = nil
        if let status = (UserDefaults.standard.value(forKey: Constants.VALIDATE_SECURITY_VIOLATION_STATUS) as? String), (usrState?.isUserLoggedIn)! {
            self.presentPopUpBasedOnViolations(statusOfViolation: status)
        }
    }
    
    /** On tap of hamburger icon, show the hamburger*/
    @objc func menuTapped(){
        menuListViewController?.userRegistrationState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistration) as? UserRegistrationState
        // Requirement to not show if the environment is staging
        if menuListViewController?.getSelectedEnvironment() != RegistrationEnvironment.Staging.rawValue{
        menuListViewController?.selectedEnvironmentLbl.text = menuListViewController?.getSelectedEnvironment()
        }else{
            menuListViewController?.selectedEnvironmentLbl.text = ""
        }
        if (menuListViewController?.userRegistrationState?.isUserLoggedIn == true) {
            if let registeredUserName = menuListViewController?.userRegistrationState?.getUserName{
                menuListViewController?.userName.text = "Hello, \(registeredUserName)"
            }
        } else {
            menuListViewController?.userName.text = "Hello User. Please Login"
        }
        showSideBar(.left)
    }
    
    func showHamburgerMenu(menu:BAHamburgerMenuData?){
        if let menuID = menu?.menuID{
            middleController = presenter?.onEvent(menuID)
            if let middleView = middleController {
                let navigationController = UINavigationController(rootViewController:middleView)
                addMenuIcon(navigationController: navigationController)
                presentOverlayViewController(forMenu: menuID)
                setViewControllers(left: menuListViewController, middle: navigationController, right: nil)
            }else{
                setDefaultViewController()
            }
            
        }else{
            setDefaultViewController()
        }
    }
    func setDefaultViewController(){
        if Utilites.getDefaultViewController() != nil{
        }
    }
    func presentOverlayViewController(forMenu menuID:String){
        switch menuID {
        case Constants.SHOPPING_STORYBOARD_NAME:
            showOverLay(withIdentifier: Overlays.SHOP)
            break
        case Constants.HELP_STORYBOARD_NAME:
            showOverLay(withIdentifier: Overlays.SUPPORT)
            break
        default:
            break
        }
    }
    
    //MARK: Helper methods
    /** Load Hamburger menu data reading contents from plist */
    func configureUI() {
        hamburgerMenuList.removeAll()
        let hamburgerMenuData = Utilites.readDataFromFile(Constants.HAMBURGER_MENU_SCREEN_KEY) as? [[String:String]]
        if let menuDataNew = hamburgerMenuData {
            for menu in menuDataNew {
                let hamburgerMenuId = menu[Constants.MENU_ID_KEY]
                let screenTitleDisplay = menu[Constants.Screen_Title]
                let hamburgerIcon = menu[Constants.IMAGE_KEY]
                let hamburgerData = BAHamburgerMenuData(menuID: hamburgerMenuId, screenTitle: screenTitleDisplay,icon:hamburgerIcon)
                hamburgerMenuList.append(hamburgerData)
            }
        }
        
        menuListViewController = UIStoryboard(name: Constants.HAMBURGER_MENU_SCREEN_KEY, bundle: nil).instantiateViewController(withIdentifier: Constants.HAMBURGER_LEFT_MENU_STORYBOARD_ID) as? HamburgerLeftBarViewController
        menuListViewController?.hamburgerMenuDelegate = self
        menuListViewController?.hamburgerMenu = hamburgerMenuList
        
    }
    
    /** Adding nav bar button item on to navigation bar passed and add action for click*/
    func addMenuIcon(navigationController:UINavigationController) {
        let iconSize = CGSize(width: UIDIconSize, height: UIDIconSize)
        var buttonImage = UIImage(named: Constants.HAMBURGER_ICON_IMAGE)
        buttonImage = buttonImage?.resizeImage(size: iconSize)?.withRenderingMode(.alwaysTemplate)
        let menuIconItem = UIBarButtonItem(image: buttonImage,
                                           style: .plain,
                                           target: self,
                                           action: #selector(menuTapped))
        
        // Setting the Theme Bar button
        let themeSettingBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.THEME_SETTING_ICON),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(themeButtonPressed))
        
        let navigationItem = navigationController.topViewController?.navigationItem
        navigationItem?.leftBarButtonItem = menuIconItem
        navigationItem?.rightBarButtonItem =  themeSettingBarButtonItem
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(nil, for: .normal, barMetrics: .default)
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(nil, for: .normal, barMetrics: .compact)
        
    }
    
    @objc func themeButtonPressed (sender:UIButton) {
        if let initialViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ThemeSettingViewController")) {
            let themeSettingViewController: UIViewController = initialViewController
            middleController?.navigationController?.pushViewController(themeSettingViewController, animated: false)
            
        }
    }
    
    func didSelectHamburgerMenu(selectedStateData: BAHamburgerMenuData) {
        hideSideBar(.left)
        showHamburgerMenu(menu: selectedStateData)
    }
    
    func presentPopUpBasedOnViolations(statusOfViolation : String){
        switch statusOfViolation {
        case SecurityIdentifier.PASSCODE_TEXT.rawValue:
            self.showAlertView(message: Constants.PASSCODE_VIOLATION_TEXT_MESSAGE, condition: SecurityIdentifier.PASSCODE_TEXT.rawValue,textSize: Constants.TEXT_SIZE_13 )
        case SecurityIdentifier.JAILBREAK_TEXT.rawValue:
            self.showAlertView(message: Constants.JAILBREAK_VIOLATION_TEXT_MESSAGE, condition:SecurityIdentifier.JAILBREAK_TEXT.rawValue,textSize: Constants.TEXT_SIZE_13 )
        case SecurityIdentifier.PASSCODE_AND_JAILBREAK_TEXT.rawValue:
            self.showAlertView(message: Constants.PASSCODE_AND_JAILBREAK_VIOLATION_TEXT_MESSAGE, condition: SecurityIdentifier.PASSCODE_AND_JAILBREAK_TEXT.rawValue,textSize: Constants.TEXT_SIZE_12)
        default:
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "Default case", message: Constants.NO_VIOLATION_TEXT)
        }
    }
    
    func showAlertView(message: String , condition : String, textSize: Int){
        let storyboard : UIStoryboard = UIStoryboard(name: Constants.HAMBURGER_MENU_STORYBOARD_ID, bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: Constants.POPUP_VIEWCONTROLLER_STORYBOARD_ID) as! PopAlertViewController
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.custom
        popoverContent.isPasscodeAndJailbreakViolation = condition
        popoverContent.message = message
        self.present(popoverContent, animated: true, completion: nil)
    }
}

extension HamburgerMenuViewController: OverlayDelegate {
    func showOverLay(withIdentifier identifier:String){
        let storyboard = UIStoryboard(name: Overlays.STORYBOARD, bundle: nil)
        overlayViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? OverlayViewController
        overlayViewController?.delegate = self
        overlayView = overlayViewController?.view
        if let viewController = overlayViewController{
            middleController?.addChild(viewController)
            middleController?.view.addSubview(viewController.view)
            viewController.didMove(toParent: middleController)
        }
    }
    
    func dismissOverlay() {
        overlayView?.removeFromSuperview()
    }
}
