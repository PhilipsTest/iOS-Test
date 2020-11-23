/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import AppInfra
import UAPPFramework
import PlatformInterfaces
/**
 IAPInterface is the public interface for any proposition to consume InAppPurchase micro app. Its the starting intitialization point.
 - Since: 1.0.0
 */

@objcMembers public class IAPInterface: NSObject, UAPPProtocol {
    private var interfaceHelper = IAPInterfaceHelper()
    private var localeMatch: String?
    private var appDependencies: IAPDependencies!
    private var configurationSettings: IAPLaunchInput?
    private var cartState: IAPCartStateProtocol!
    private var cartDelegate: IAPCartIconProtocol?
    /**
     IAPInterface init method
     - Parameter dependencies: Object of uAppDependencies class,for injecting Dependencies needed by uApp
     - Parameter settings: Object of UAPPSettings class,for injecting one time initialisation parameters needed for uApp Initialisation
     - Since: 1.0.0
     - Returns: An instance of UAPP
     */
    required public init(dependencies: UAPPDependencies, andSettings settings: UAPPSettings?) {
        super.init()
        if let inDependencies = dependencies as? IAPDependencies {
            self.appDependencies = inDependencies
        }
        self.interfaceHelper.delegate = self
        self.setCartState(IAPNoCartState())
        if let udInterface = self.appDependencies.userDataInterface{
            IAPConfiguration.sharedInstance.setUserDataInterface(udInterface)
        }
        IAPUtility.configureTaggingAndLogging(self.appDependencies.appInfra)
        IAPConfiguration.setIAPConfiguration(self.localeMatch ?? "", inAppInfra: self.appDependencies.appInfra)
    }
    
    /**
     IAPInterface instantiateViewController will initializes the rootviewcontroller of the uApp
     - Parameter launchInput: Instance of UAPPLaunchInput class,for setting the parameters needed for launch of uAPP
     - Parameter completionHandler: Block for handling error
     - Since: 1.0.0
     - Returns: An instance of UAPP UIViewController which will be used for launching the uApp
     */
    public func instantiateViewController(_ launchInput: UAPPLaunchInput,
                                          withErrorHandler completionHandler: ((Error?) -> Void)? = nil) -> UIViewController? {
        var iapViewController: UIViewController?
        guard IAPConfiguration.sharedInstance.isInternetReachable() else {
            let error =  NSError(domain: IAPConstants.IAPErrorTaggingConstants.kNoNetwork,
                                 code: IAPConstants.IAPNoInternetError.kNoInternetCode,
                                 userInfo:[NSLocalizedDescriptionKey:IAPLocalizedString("iap_no_internet") ?? ""])
            completionHandler?(error)
            return iapViewController
        }
        self.configurationSettings = launchInput as? IAPLaunchInput
        self.cartDelegate = self.configurationSettings?.cartIconDelegate

        guard shouldShowLoginError() else {
            IAPConfiguration.setIAPConfiguration(self.localeMatch ?? "", inAppInfra: self.appDependencies.appInfra)
            if let landingView = self.configurationSettings?.landingView {
                iapViewController = self.interfaceHelper.launchView(landingView,
                                                                    withProductCTN: self.configurationSettings?.getProductCTNList() ?? [],
                                                                    failure: { (inError: NSError) in
                                                                        completionHandler?(inError)
                })
            }
            return iapViewController
        }
        completionHandler?(IAPUtility.getUserNotLoggedInError())
        return iapViewController
    }
    
    /**
     IAPInterface fetchCompleteProductList will fetch the product ctn list
     - Parameter completion: Block for passing array of ctn in string format
     - Parameter failureHandler: Block for handling error
     - Since: 1.0.0
     - Returns: The list of product CTN's through its completion block
     */
    open func fetchCompleteProductList(_ completion:@escaping (_ withProducts:Array<String>) -> Void,
                                       failureHandler: @escaping (NSError)-> Void) {
        
        guard !shouldShowLoginError() else { failureHandler(IAPUtility.getUserNotLoggedInError()); return }
        isCartVisible({ (inSuccess) in
            self.interfaceHelper.initiateAllProductsDownload(completion, failureHandler: failureHandler)
        }) { (inError) in
            failureHandler(inError)
        }
    }
    
    /**
     IAPInterface getProductCartCount will fetch the cart count
     - Parameter success: Block for handling cart count
     - Parameter failureHandler: Block for handling error
     - Since: 1.0.0
     - Returns: The cart count through its success block
     */
    open func getProductCartCount(_ success:@escaping (Int)->(),failureHandler:@escaping (NSError)->()) {
        
        guard appDependencies.userDataInterface.loggedInState() != .userNotLoggedIn else {
            let error = IAPUtility.getUserNotLoggedInError()
            failureHandler(error)
            return }
        
        let configuarationManager = IAPConfigurationManager()
        let interfaceToBeUsed = configuarationManager.getInterfaceForConfiguration()
        configuarationManager.getConfigurationDataWithInterface(interfaceToBeUsed, successCompletion: { (IAPConfigurationData) in

            self.cartState.fetchCartCount(success, failureHandler: failureHandler)
        }) { (inError: NSError) in
            failureHandler(inError)
        }
    }
    
    /**
     IAPInterface isCartVisible method will inform the uApp for cart visibility. It's an optional method
     - Parameter success: Block for handling cart visibility
     - Parameter failureHandler: Block for handling error
     - Since: 3.0.0
     - Returns: The cart visibility as a boolean value through its success block
     */
    public func isCartVisible(_ success:@escaping (Bool)->(), failureHandler:@escaping (NSError)->()) {
        guard !shouldShowLoginError() else {
            let error = IAPUtility.getUserNotLoggedInError()
            failureHandler(error)
            return
        }
        
        IAPUtility.setIAPPreference({ (isSuccess) in
            success(isSuccess)
        }) { (inError) in
            failureHandler(inError)
        }
    }
    
    func setCartState(_ inCartState:IAPCartStateProtocol) {
        self.cartState = inCartState
        self.cartState.client = self
    }
    
    func getCartState()->IAPCartStateProtocol {
        return self.cartState
    }
    
    func setLocaleCode(_ localeCode: String) {
        self.localeMatch = localeCode
    }
    
    func getCartDelegate()->IAPCartIconProtocol? {
        return self.cartDelegate
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func goToInitialViewController(_ notification: Notification){
        guard let navController = notification.object as? UINavigationController else { return }
        navController.popToProductCatalogue(nil, withCartDelegate: self.cartDelegate, withInterfaceDelegate: self)
    }
    
    func buyProduct(_ productCode:String,success:@escaping (Bool)->(),failureHandler:@escaping (NSError)->()) {
        guard appDependencies.userDataInterface.loggedInState() != .userNotLoggedIn else {
            let error = IAPUtility.getUserNotLoggedInError()
            failureHandler(error)
            return }
        
        self.cartState.buyProduct(productCode, success: { (inSuccess) in
            success(inSuccess)
        }) { (inError) in
            failureHandler(inError)
        }
    }
    
    func shouldShowLoginError() -> Bool {
        if let config = configurationSettings {
            return appDependencies.userDataInterface.loggedInState() == .userNotLoggedIn && IAPUtility.isLoginRequired(for: config)
        }
        return appDependencies.userDataInterface.loggedInState() == .userNotLoggedIn
    }
}
