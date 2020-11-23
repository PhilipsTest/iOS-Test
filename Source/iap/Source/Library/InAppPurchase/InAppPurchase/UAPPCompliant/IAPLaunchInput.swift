/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS
import UAPPFramework

/**
 Vertical needs to adopt IAPCartIconProtocol to handle visibility of cart icon and updating cart count. This protocol has two methods.
 - Since: 1.0.0
 */

@objc public protocol IAPCartIconProtocol : class {
    /**
     This method of IAPCartIconProtocol notifies the implementation class to update the cart count
     - Since: 1.0.0
     */
    func didUpdateCartCount()
    
    /**
     This method of IAPCartIconProtocol notifies the implementation class to make the cart icon visible or not
     - Parameter shouldShow: This is BOOL flag parameter to notify the visibility of cart icon
     - Note: *The cart icon should only be shown if the User is Logged In.*
     - Since: 1.0.0
     */
    func updateCartIconVisibility(_ shouldShow: Bool)
}

/**
 Implement this protocol to handle the flow after IAP Flow completes
 - Since: 1903.0.0
*/
@objc public protocol IAPOrderFlowCompletionProtocol: NSObjectProtocol {
    /**
     This method should be implemented in order to tell whether IAP pops back to Product List after flow completion or not. **If not, its advisable to handle the navigation,or else the user will be stuck in the IAP Screen.**
     - Returns: Bool value suggesting whether IAP should pop to Catalogue Screen or not
     - Since: 1903.0.0
     */
    func shouldPopToProductList() -> Bool
    
    /**
     This method is an optional method which calls when the order is placed successfully
     - Since: 1903.0.0
     */
    @objc optional func didPlaceOrder()
    
    /**
     This method is an optional method which calls when the order placement was cancelled
     - Since: 1903.0.0
     */
    @objc optional func didCancelOrder()
}

/**
 Implement this protocol to give a view for the Banner view in Product List Screen
 - Since: 1903.0.0
 */
@objc public protocol IAPBannerConfigurationProtocol: NSObjectProtocol {
    /**
     This method should return the view that is to be displayed on top of the Product List Screen. If nil is passed, no view will show at the top of the Product List.
     - Returns: A view which will display on top of the Product List Screen
     - Since: 1903.0.0
     */
    func viewForBannerInCatalogueScreen() -> UIView?
}

/**
 IAPLaunchInput is responsible for initializing the settings required for launching.
 - Since: 1.0.0
 */
@objcMembers open class IAPLaunchInput: UAPPLaunchInput {
    
    /**
     bannerConfigDelegate is the delegate responsible for handling the IAPBannerConfigurationProtocol.
     - Since: 1903.0.0
     */
    open weak var bannerConfigDelegate: IAPBannerConfigurationProtocol? {
        didSet {
            IAPConfiguration.sharedInstance.bannerConfigDelegate = bannerConfigDelegate
        }
    }
    
    /**
     Set this value to a positive Integer value if the Cart count is to be restricted. If the Cart count exceeds the given value, it will throw an error when user presses on Checkout button in Cart Screen.
     **Default value is 0 which means there is no limitation on the Cart count**
     - Since: 1903.0.0
     */
    open var maximumCartCount: Int = 0 {
        didSet {
            IAPConfiguration.sharedInstance.maximumCartCount = maximumCartCount
        }
    }
    
    /**
     orderFlowCompletionDelegate is the delegate responsible for handling the IAPOrderFlowCompletionProtocol.
     - Since: 1903.0.0
     */
    open weak var orderFlowCompletionDelegate: IAPOrderFlowCompletionProtocol? {
        didSet {
            IAPConfiguration.sharedInstance.orderFlowCompletionDelegate = orderFlowCompletionDelegate
        }
    }
    
    /**
     Set this value to false if Hybris flow needs to be blocked and only Retailer Flow is to be displayed.
     **Default value is true**
     - Since: 1903.0.0
     */
    open var supportsHybris: Bool = true {
        didSet {
            IAPConfiguration.sharedInstance.supportsHybris = supportsHybris
        }
    }
    
    /**
     landingView is responsible for initializing the flow required for launching.
     - Since: 1.0.0
     */
    open var landingView : IAPFlow?
    /**
     theme is responsible for initializing the theme required for launching.
     - Since: 1.0.0
     */
    open var theme = UIDThemeManager.sharedInstance.defaultTheme
    /**
     cartIconDelegate is the delegate responsible for handling the communication between micro app and vertical app.
     - Since: 1.0.0
     */
    open weak var cartIconDelegate : IAPCartIconProtocol?
    /**
     voucherId is responsible for initializing the apply voucher flow enabling or silently applying voucher from proposition.
     - Since: 2.0.0
     */
    open var voucherId: String? {
        didSet {
           IAPConfiguration.sharedInstance.voucherId = voucherId
        }
    }
    
    fileprivate var productCtnList : [String]?
    
    /**
     IAPLaunchInput init method to initialize IAPLaunchInput with UIDTheme
     - Parameter theme: UIDTheme as an input for setting the theme of uApp. By default it takes default theme as input.
     - Since: 1.0.0
     - Returns: An instance of IAPLaunchInput
     */
    public init?(theme: UIDTheme = UIDThemeManager.sharedInstance.defaultTheme!) {
        self.theme = theme
    }
    
    /**
     IAPLaunchInput setIAPFlow method to set the flow of uApp with required inputs
     - Parameter inIAPFlow: Passed as an enum value of IAPFlow
     - Parameter withSettings: Instance of IAPFlowInput
     - Parameter ignoredRetailersList: Optional input as array of strings to ignore the list of retailers(by default empty list)
     - Since: 1.0.0
     */
    open func setIAPFlow(_ inIAPFlow:IAPFlow, withSettings:IAPFlowInput, ignoredRetailersList:[String] = []) {
        
        IAPConfiguration.sharedInstance.setBlackListRetailers(ignoredRetailersList)
        self.landingView = inIAPFlow
        
        switch inIAPFlow {
            
        case .iapProductCatalogueView:
            self.productCtnList = withSettings.getProductCTNList()//[]
            
        case .iapPurchaseHistoryView:
            self.productCtnList = []
            
        case .iapShoppingCartView:
            self.productCtnList = []
            
        case .iapProductDetailView:
            self.productCtnList = Array(arrayLiteral: withSettings.getProductCTN())
            
        case .iapBuyDirectView:
            self.productCtnList = Array(arrayLiteral: withSettings.getProductCTN())
            
        case .iapCategorizedCatalogueView:
            self.productCtnList = withSettings.getProductCTNList()
            
        }
    }
    
    func getProductCTNList() -> [String]? {
        return self.productCtnList
    }
    
    func getLandingView() -> IAPFlow {
        return self.landingView!
    }
    
    /**
     This enum is used to set the landing view of IAP
     - Since: 1.0.0
     */
    
    @objc public enum IAPFlow: Int {
        /**
         iapProductCatalogueView enum is used for product catalogue view
         - Since: 1.0.0
         */
        case iapProductCatalogueView
        
        /**
         iapShoppingCartView enum is used for shopping cart view
         - Since: 1.0.0
         */
        case iapShoppingCartView
        
        /**
         iapPurchaseHistoryView enum is used for order history view
         - Since: 1.0.0
         */
        case iapPurchaseHistoryView
        
        /**
         iapProductDetailView enum is used for product detail view
         - Since: 1.0.0
         */
        case iapProductDetailView
        
        /**
         iapBuyDirectView enum is used for buy direct view
         - Since: 1.0.0
         */
        case iapBuyDirectView
        
        /**
         iapCategorizedCatalogueView enum is used for categorized catalogue view
         - Since: 1.0.0
         */
        case iapCategorizedCatalogueView
    }
    
}
