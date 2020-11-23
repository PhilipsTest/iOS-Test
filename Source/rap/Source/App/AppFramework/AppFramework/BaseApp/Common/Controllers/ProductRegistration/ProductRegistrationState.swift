/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsProductRegistration
import PhilipsPRXClient
import UAPPFramework
import PhilipsUIKitDLS

/** PRLaunchOptions is a enum that hold the launching options */
enum PRLaunchOptions: Int {
    ///Launch welcome screen
    case welcomeLaunchOption
    /// Launch PR
    case productRegistrationLaunchOption
    
    /** getLaunchingView maps launchView with its corresponding PPRUILaunchOption*/
    func getLaunchingView() -> PPRUILaunchOption {
        let launchView:PPRUILaunchOption
        switch self {
        case .welcomeLaunchOption:
            launchView = .WelcomeScreen
        case .productRegistrationLaunchOption:
            launchView = .ProductRegistrationScreen
        }
        return launchView
    }
}

/**
 ProductRegistrationComponentModel class providing interface for ProductRegistration CoCo launching
 */
class ProductRegistrationComponentModel: ComponentModel{
   ///Singleton instance of ProductRegistrationComponentModel
    static let sharedInstance = ProductRegistrationComponentModel()
    fileprivate override init() {}
    
    //MARK: Variable declarations
    var benefitText : String?
    var extendedWarrentyText : String?
    var emailText : String?
    var ctn : String?
    var serialNumber : String?
    var friendlyName : String?
    var sendEmail: Bool?
    var launchOption: PRLaunchOptions?
    var completionHandler : ((Error?) -> Void)?
}

/** ProductRegistrationState class is inherited from UIBaseState, Manages navigation to it corresponding VC
 */
class ProductRegistrationState : BaseState, PPRUserInterfaceDelegate {
    
    //MARK: Variable declarations
    var productRegistrationHandler : PPRInterface?
    var productRegistrationLaunchInput : PPRLaunchInput?
    var productRegistrationViewController : UIViewController?
    var productRegistrationDependencies : PPRInterfaceDependency?
    
    //MARK: BaseState method implementation
    var dataModel : ProductRegistrationComponentModel? {
        get {
            return ProductRegistrationComponentModel.sharedInstance
        } set {
            self.dataModel = newValue
        }
    }
    
    override init() {
        super.init(stateId : AppStates.ProductRegistration)
        self.setUpProductRegistrationHandler()
    }
    
///Method setUpProductRegistrationHandler manages the productRegistration dependencies
    func setUpProductRegistrationHandler() {
        productRegistrationDependencies = PPRInterfaceDependency()
        productRegistrationDependencies?.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        productRegistrationDependencies?.userDataInterface = UserDataInterfaceInstance.sharedInstance.userDataInterface
        productRegistrationHandler = PPRInterface(dependencies: productRegistrationDependencies!, andSettings: nil)
    }
    
    ///Method setUpProductRegistrationLaunchInput manages configuration for ProductRegistration
    func setUpProductRegistrationLaunchInput() {
        
        let contentConfig = PPRContentConfiguration()
        contentConfig.benefitText = dataModel?.benefitText
        contentConfig.extendWarrantyText = dataModel?.extendedWarrentyText
        contentConfig.emailText = dataModel?.emailText
        //Check for country India
         let country = AppInfraSharedInstance.sharedInstance.appInfraHandler?.serviceDiscovery.getHomeCountry() ?? "UNKNOWN"
        if country == "IN" {
            contentConfig.mandatoryProductRegistration = true
            contentConfig.mandatoryRegisterButtonText = "Extend Warranty"
        }
        let configuration = PPRConfiguration()
        // Launch Option
        configuration.launchOption = (dataModel?.launchOption?.getLaunchingView())!
        
        // Content configuraion
        configuration.contentConfiguration = contentConfig
        
        let productInfo : PPRProduct = PPRProduct(ctn: (dataModel?.ctn)!, sector: B2C, catalog: CONSUMER)
        productInfo.serialNumber = dataModel?.serialNumber
        productInfo.friendlyName = dataModel?.friendlyName
        productInfo.sendEmail = (dataModel?.sendEmail)!
        
        productRegistrationLaunchInput = PPRLaunchInput()
        productRegistrationLaunchInput?.userInterfacedelegate = self
        productRegistrationLaunchInput?.productInfo = [productInfo]
        productRegistrationLaunchInput?.launchConfiguration = configuration
    }
    
     override func updateDataModel() {
        dataModel?.benefitText = Constants.PRODUCTREGISTRATION_BENIFIT_TEXT
        dataModel?.extendedWarrentyText = Constants.PRODUCTREGISTRATION_EXTENDED_WARRENTY_TEXT
        dataModel?.emailText = Constants.PRODUCTREGISTRATION_EMAIL_TEXT
        
        dataModel?.ctn = CTNUtilities.getProductCTNsForHomeCountry()?.first
        dataModel?.sendEmail = true
        dataModel?.launchOption = .welcomeLaunchOption
        
        dataModel?.completionHandler = { error in
            if error != nil {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_PRODUCTREGISTRATION , message: " \(Constants.LOGGING_PRODUCTREGISTRATION_ERROR_MESSAGE) \(String(describing: error))")
            } else {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_PRODUCTREGISTRATION, message: Constants.LOGGING_PRODUCTREGISTRATION_MESSAGE)
            }
        }
    }
    
/** Pass data to ProductRegistration and get the ViewController to be Navigated 
     - returns : ViewController to be loaded */
    override func getViewController() -> UIViewController? {
        updateDataModel()
        setUpProductRegistrationLaunchInput()
        productRegistrationViewController = productRegistrationHandler?.instantiateViewController(productRegistrationLaunchInput!, withErrorHandler: { error in
            if error != nil {
                var errorMessage : String?
                if (error! as NSError).code == PPRError.USER_NOT_LOGGED_IN.rawValue {
                    errorMessage = Constants.LOGIN_MESSAGE
                } else if (error! as NSError).code == PPRError.INPUT_VALIDATION_FAILED.rawValue {
                    errorMessage = Constants.INVALID_PARAMETERS_MESSAGE
                }
                DispatchQueue.main.async{
                    let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
                    Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: errorMessage, buttonAction: [alertAction], usingController: nil)
                }
            } else {
               _ = self.dataModel?.completionHandler
            }
        })
        return productRegistrationViewController
    }
    
    deinit {
        productRegistrationLaunchInput?.userInterfacedelegate = nil
    }
    
/** PPRUserInterfaceDelegate implementation on back button
     - parameter userProduct: instance of PPRUserWithProducts
     - parameter products: Holds Array of Products */
    func productRegistrationBack(userProduct: PPRUserWithProducts?, products: [PPRRegisteredProduct]) {
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_PRODUCTREGISTRATION, message: Constants.LOGGING_PRODUCTREGISTRATION_BACK_PRESSED)
    }
    
    /** PPRUserInterfaceDelegate implementation on continue button   
     - parameter userProduct: instance of PPRUserWithProducts
     - parameter products: Holds Array of Products */
    func productRegistrationContinue(userProduct: PPRUserWithProducts?, products: [PPRRegisteredProduct]) {
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_PRODUCTREGISTRATION, message:Constants.LOGGING_PRODUCTREGISTRATION_CONTINUE_PRESSED)
    }
    
    func getVersion() -> String {
        let dictionary = Bundle(for:PPRInterface.self).infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as! String
        //let build = dictionary?["CFBundleVersion"] as! String
        return "\(version)"
    }
}
