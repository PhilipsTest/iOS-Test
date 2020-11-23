/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import InAppPurchase
import UAPPFramework

/** IAPLandingOptions contains a enum having InAppPurchase features listed
 */
enum IAPLandingOptions: Int {
    case iapProductCatalogueOption
    case iapShoppingCartOption
    case iapPurchaseHistoryOption
    case iapProductDetailOption
    case iapCategorizedOption
    
    /** getLaunchingView maps IAPLandingOptions to its corresponding landingView */
    func getLaunchingView() -> IAPLaunchInput.IAPFlow {
        let landingView:IAPLaunchInput.IAPFlow
        switch self {
        case .iapProductCatalogueOption:
            landingView = .iapProductCatalogueView
        case .iapShoppingCartOption:
            landingView = .iapShoppingCartView
        case .iapPurchaseHistoryOption:
            landingView = .iapPurchaseHistoryView
        case .iapProductDetailOption:
            landingView = .iapProductDetailView
        case .iapCategorizedOption:
            landingView = .iapCategorizedCatalogueView
        }
        return landingView
    }
}


/**
 InAppPurchaseModel class providing interface for InAppPurchase CoCo launching
 */
class InAppPurchaseModel : ComponentModel {
    
    //MARK: Variable declarations
    ///Singleton instance of InAppPurchaseModel
    static let sharedInstance = InAppPurchaseModel()
    fileprivate override init() {}
    
    var errorHandler : ((Error?)->Void)?
    var productCTN : String?
    var launchingOption : IAPLandingOptions?
    var CTNList : [String]? = [String]()
}

/** InAppPurchaseState class is inherited from UIBaseState, Manages navigation to it corresponding ViewController, Manage state
 */

class InAppPurchaseState: BaseState, IAPCartIconProtocol {
    
    //MARK: Variable Declarations
    static let inAppPurchaseHandler:IAPInterface = {
        var inAppPurchaseDependencies = IAPDependencies()
        inAppPurchaseDependencies.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        inAppPurchaseDependencies.userDataInterface = UserDataInterfaceInstance.sharedInstance.userDataInterface
        var handler =  IAPInterface(dependencies: inAppPurchaseDependencies, andSettings: nil)
        return handler
    }()
    var inAppPurchaseLaunchInput : IAPLaunchInput?
    var inAppPurchaseViewController : UIViewController?
    var inAppPurchaseSettingsHelper : IAPFlowInput?
    var inAppPurchaseDependencies : IAPDependencies?
    var inAppPurchaseNavigationController : UINavigationController?
    var inAppHandler:IAPInterface?
    var dataModel : InAppPurchaseModel? {
        get {
            return InAppPurchaseModel.sharedInstance
        } set {
            self.dataModel = newValue
        }
    }
    
    override init() {
        super.init(stateId : AppStates.InAppPurchase)
        inAppHandler = InAppPurchaseState.inAppPurchaseHandler
    }
    
    //MARK: ComponentBaseInterface implementation methods
    fileprivate func getProductCount(_ success:@escaping (Int)->() ,failure : @escaping (NSError)->()) {
        inAppHandler?.getProductCartCount({ (count) in
            success(count)
        }, failureHandler: failure)
    }
    
    /** Method setupIAPHandler handles the InAppPurchase dependencies */
    
    
    /** Method setupIAPLaunchInput handles Launching of InAppPurchase */
    func setupIAPLaunchInput() {
        if let CTNList = dataModel?.CTNList{
            inAppPurchaseSettingsHelper = IAPFlowInput(inCTNList: CTNList)
            inAppPurchaseLaunchInput = IAPLaunchInput()
            inAppPurchaseLaunchInput?.landingView = dataModel?.launchingOption?.getLaunchingView()
            inAppPurchaseLaunchInput?.cartIconDelegate = self
            if let launchView = dataModel?.launchingOption?.getLaunchingView(){
                if let settings = inAppPurchaseSettingsHelper{
                    inAppPurchaseLaunchInput?.setIAPFlow(launchView, withSettings:settings)
                }
            }
        }
    }
    
    /** Method refreshIAPCartCount gets the cart count from IAP */
    func refreshIAPCartCount() {
        if Constants.APPDELEGATE?.getFlowManager().getCondition(AppConditions.IsLoggedIn)?.isSatisfied() == true {
            getProductCount({ (count) in
                DispatchQueue.main.async{
                    Constants.APPDELEGATE?.cartIcon?.badgeString = "\(count)"
                    UserDefaults.standard.set(count, forKey: Constants.BADGE_COUNT)
                }
            } , failure:
                { error in
                    AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_INAPP_TAG, message: "\(Constants.LOGGING_INAPP_FETCHCART_ERROR_MESSAGE) \(error)")
            })
        } else {
            Constants.APPDELEGATE?.cartIcon?.badgeString = Constants.INAPP_SHOPPING_CART_ICON_BADGE_STRING
        }
    }
    
    /** Navigation to it corresponding ViewController is implemented in getViewController method
     - returns : ViewController that needs to be loaded and navigated to */
    override func getViewController() -> UIViewController? {
        updateDataModel()
        inAppPurchaseNavigationController = nil
        getIAPViewController()
        return inAppPurchaseViewController
    }
    
    /** Method getIAPViewController Invokes InAppPurchase Component */
    fileprivate func getIAPViewController() {
        setupIAPLaunchInput()
        //Invoke InAppPurchase screen passing LaunchInputs
        inAppPurchaseViewController = inAppHandler?.instantiateViewController(inAppPurchaseLaunchInput!, withErrorHandler: dataModel?.errorHandler )
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "InAppPurchaseState:getIAPViewController", message: "Launching InAppPurchase View Controller")
    }
    
    //MARK: IAPCartIconProtocol method implementations
    /** Any changes in cart count refreshIAPCartCount method is invoked */
    func didUpdateCartCount() {
        refreshIAPCartCount()
    }
    
    /** Decision to be taken if cart icon to be shown or not */
    func updateCartIconVisibility(_ shouldShow: Bool) {
        
        if inAppPurchaseNavigationController == nil {
            inAppPurchaseNavigationController = inAppPurchaseViewController?.navigationController
        }
        
        inAppPurchaseNavigationController?.topViewController?.shouldSkipShoppingCart = !shouldShow
        // Commenting Out the logic as whole logic is for Hybris and it will be used in future 
//        if shouldShow {
//            // Utilites.addCartIconTo((inAppPurchaseNavigationController?.topViewController)!)
//        } else {
//            inAppPurchaseNavigationController?.topViewController?.navigationItem.rightBarButtonItem = nil
//        }
        
    }
    
    func getVersion() -> String {
        let dictionary = Bundle(for:IAPInterface.self).infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as! String
        //let build = dictionary?["CFBundleVersion"] as! String
        return "\(version)"
    }
}

