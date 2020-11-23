/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import PhilipsConsumerCare
import UAPPFramework
import PhilipsUIKitDLS

/**
 ConsumerCareComponentModel class providing interface for Consumer Care CoCo launching
 */
class ConsumerCareComponentModel: ComponentModel {
    
    //MARK: Variable declarations
    /// Singletone object for ConsumerCareComponentModel
    static let sharedInstance = ConsumerCareComponentModel()
    fileprivate override init() {}
}


/**
 ConsumerCareState class manages the state and guides navigation to it's corresponding ViewController
 */
class ConsumerCareState : BaseState, DCMenuDelegates {
    
    //MARK: Variable Declarations
    var consumerCareLaunchInput : DCLaunchInput?
    var consumerCareInterface : DCInterface?
    var consumerCareViewController : UIViewController?
    var consumerCareDependencies : DCDependencies?
    var liveChatURL : String?
    
    /// Singletone Object of ConsumerCareComponentModel
    var dataModel : ConsumerCareComponentModel? {
        get {
            return ConsumerCareComponentModel.sharedInstance
        } set {
            self.dataModel = newValue
        }
    }
    
    //MARK: BaseState method implementation
    
    override init() {
        super.init(stateId : AppStates.ConsumerCare)
        setupCCInterface()
    }
    

    ///Set/Update the CoCo inputs and get the viewController to be navigated to
    override func getViewController() -> UIViewController? {
        updateDataModel()
        getCCViewController()
        return consumerCareViewController
    }
    
    /** To send any data to consumer care component, add parameter in updateDataModel */
    override func updateDataModel() {
        
    }
    
    fileprivate func getCCViewController() {
        setupCCLaunchInput()
        //Invoke consumer care screen passing one of the CTNs
        consumerCareViewController = consumerCareInterface?.instantiateViewController(consumerCareLaunchInput!, withErrorHandler: { (error) in
            if error != nil {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_CONSUMERCARE_TAG , message: " \(Constants.LOGGING_CONSUMERCARE_ERRORMESSAGE) \(String(describing: error))")
            } else {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_CONSUMERCARE_TAG, message: Constants.LOGGING_CONSUMERCARE_MESSAGE)
            }
        })
    }
    
/** Interface for ConsumerCare Dependencies are provided or managed in setupCCInterface method */
    func setupCCInterface() {
        consumerCareDependencies = DCDependencies()
        consumerCareDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        consumerCareInterface = DCInterface(dependencies: consumerCareDependencies!, andSettings: nil)
    }
    
/** setupCCLaunchInput Manages implementation and Setup of ConsumerCare component by passing CTN */
    func setupCCLaunchInput() {
        let hardcodedList = PSHardcodedProductList()
        hardcodedList.catalog = CARE
        hardcodedList.sector = B2C
        
        consumerCareLaunchInput = DCLaunchInput()
        consumerCareLaunchInput?.dCMenuDelegates = self
        consumerCareLaunchInput?.productModelSelectionType = hardcodedList
        consumerCareLaunchInput?.chatURL = UserDefaults.standard.value(forKey: "ChinaURL") as! String?
        
        //To Do: This implementation will be removed after Consumer Care reading URL from service discovery
        // Add a different plist file for China Locale. To remove Facebook and twitter for China
        if UserDefaults.standard.value(forKey: "Locale") as! String? == "CN" {
            consumerCareLaunchInput?.appSpecificConfigFilePath = Bundle.main.path(forResource: "DigitalCareConfiguration_china", ofType: Constants.PLIST_TYPE)
        }

        hardcodedList.hardcodedProductListArray = CTNUtilities.getProductCTNsForHomeCountry();
    }
    
    /* Live Chat Url Settings ..
       After the AppInfra will provide the proper API for getting the country, the Ref App implementation will change ...
     To Do: This was of checking the country implementation will be removed after Consumer Care reading URL from service discovery */
    func setChatURL() {
        AppInfraSharedInstance.sharedInstance.appInfraHandler?.serviceDiscovery.getHomeCountry({ (country, sourceType, error) in
            if country == "CN" {
                 UserDefaults.standard.set(Constants.LIVE_CHAT_URL_CN, forKey: "ChinaURL")
                 UserDefaults.standard.set("CN", forKey: "Locale")

            }else{
                self.liveChatURL = nil
                UserDefaults.standard.set(self.liveChatURL, forKey: "ChinaURL")
                UserDefaults.standard.set("Other", forKey: "Locale")
            }
        })
    }
    
    deinit {
        consumerCareLaunchInput?.dCMenuDelegates = nil
    }

    //MARK: DCMainMenuDelegate methods
    /// Extension of DCMainMenuDelegate, to override buttons clicked on Consumer Care landing screen

    /** DCMenuDelegates Method which manages the logic what to happen on tapping of any of the CC provided options/Features */
    func mainMenuItemSelected(_ item: String!, with index: Int) -> Bool {
        
       if (Utilites.aFLocalizedString(item) == Utilites.aFLocalizedString("RA_Product_Registration_Text")) {
            do {
                if let nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.ConsumerCare), forEventId: Constants.CONSUMERCARE_MAIN_MENU_SELECTION_PR) {
                    if let nextVC = nextState.getViewController() {
                        let loadDetails = ScreenToLoadModel(viewControllerLoadType: .Push, animates: true, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                        Launcher.navigateToViewController(consumerCareViewController, toViewController: nextVC, loadDetails: loadDetails)
                    }
                }
            } catch {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_FLOW_MANAGER_TAG, message: (error as! FlowManagerErrors).message())
                let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
                Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: nil)
            }
            
            return true
        }
        return false
    }
    
    func getVersion() -> String {
        let dictionary = Bundle(for:DCInterface.self).infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as! String
        //let build = dictionary?["CFBundleVersion"] as! String
        return "\(version)"
    }
}
