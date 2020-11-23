/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework

/**
This enum holds the environments for BazaarVoice SDK.
- Since: 2001.0
*/
public enum MECBazaarVoiceEnvironment: String {
    /**
    Setting of staging value will result in fetching all values from Staging Environment of BazaarVoice.
    - Since: 2001.0
    */
    case staging

    /**
    Setting of production value will result in fetching all values from Production Environment of BazaarVoice.
    - Since: 2001.0
    */
    case production
}

/**
Implement this protocol to give a view for the Banner view in Product List Screen.
- Since: 2001.0
*/
@objc public protocol MECBannerConfigurationProtocol: NSObjectProtocol {
    /**
    This method should return the view that is to be displayed on top of the Product List Screen.
     If nil is passed, no view will show at the top of the Product List.
    - Returns: A view which will display on top of the Product List Screen.
    - Since: 2001.0
    */
    func viewForBannerInProductListScreen() -> UIView?
}

/**
 Implement this protocol to handle the flow after MEC Flow completes
 - Since: 2002.0
*/
@objc public protocol MECOrderFlowCompletionProtocol: NSObjectProtocol {
    /**
    This method should be implemented in order to tell whether MEC pops back to Product List after flow completion or not.
     **If false is return, its advisable to handle the navigation,or else the user will be stuck in the MEC Screen.**
    - Returns: Bool value suggesting whether MEC should pop to Catalogue Screen or not
    - Since: 2002.0
    */
    func shouldPopToProductList() -> Bool

    /**
    This method is an optional method which calls when the order is placed successfully
    - Since: 2002.0
    */
    @objc optional func didPlaceOrder()

    /**
    This method is an optional method which calls when the order placement was cancelled
    - Since: 2002.0
    */
    @objc optional func didCancelOrder()
}

/**
MECLaunchInput holds all the Configuration Values needed to Launch and Customize Mobile Ecommerce behaviour.
- Since: 2001.0
*/
@objcMembers open class MECLaunchInput: UAPPLaunchInput {

    /**
    orderFlowCompletionDelegate is the delegate responsible for handling the callbacks after MEC Flow Completion
    - Since: 2002.0
    */
    open weak var orderFlowCompletionDelegate: MECOrderFlowCompletionProtocol? {
        didSet {
            MECConfiguration.shared.orderFlowCompletionDelegate = orderFlowCompletionDelegate
        }
    }

    /**
    This is used to set the flow before launching MEC, like landing view, CTN, etc.
     Please refer MECFlowConfiguration class for more info.
    - Since: 2002.0
    */
    open var flowConfiguration: MECFlowConfiguration? {
        didSet {
            MECConfiguration.shared.flowConfiguration = flowConfiguration
        }
    }

    /**
    This delegate is used to handle callbacks for MECBannerConfigurationProtocol.
    - Since: 2001.0
    */
    open weak var bannerConfigDelegate: MECBannerConfigurationProtocol? {
        didSet {
            MECConfiguration.shared.bannerConfigDelegate = bannerConfigDelegate
        }
    }

    /**
    This  variable is used  to pass a list of Retailer Names which should be excluded from displaying in the Retailers Screen.
     - **Default value is nil.**

     - Important: This does a case-insesitive, contains check. Partial case-insensitive Retailer Names can also be passed to this list.
    - Since: 2001.0
    */
    open var blacklistedRetailerNames: [String]? {
        didSet {
            MECConfiguration.shared.blacklistedRetailerNames = blacklistedRetailerNames
        }
    }

    /**
    Set this value to false if Hybris flow needs to be blocked and only Retailer Flow is to be displayed.
    - **Default value is true.**
    - Since: 2001.0
    */
    open var supportsHybris: Bool = true {
        didSet {
            MECConfiguration.shared.supportsHybris = supportsHybris
        }
    }

    /**
    Set this value to false if Retailers Option needs to be blocked and only Hybris Flow is to be displayed.
    - **Default value is true.**
    - Since: 2001.0
    */
    open var supportsRetailers: Bool = true {
        didSet {
            MECConfiguration.shared.supportsRetailers = supportsRetailers
        }
    }

    /**
    Set this value to pass Client ID which, will be used while initialising BazaarVoice SDK during MEC Launch.

    - Since: 2001.0
    */
    open var bazaarVoiceClientID: String? {
        didSet {
            MECConfiguration.shared.bazaarVoiceClientID = bazaarVoiceClientID
        }
    }

    /**
    Set this value to pass Conversation API Key, which will be used while initialising BazaarVoice SDK during MEC Launch.
     - **Set the Key according to the BazaarVoice Environment that is set.**

    - Since: 2001.0
    */
    open var bazaarVoiceConversationAPIKey: String? {
        didSet {
            MECConfiguration.shared.bazaarVoiceConversationAPIKey = bazaarVoiceConversationAPIKey
        }
    }

    /**
    Set this value to pass BazaarVoice Environment, which will be used while initialising BazaarVoice SDK during MEC Launch.
     - **Default value is staging environment.**

    - Since: 2001.0
    */
    open var bazaarVoiceEnvironment: MECBazaarVoiceEnvironment? {
        didSet {
            MECConfiguration.shared.bazaarVoiceEnvironment = bazaarVoiceEnvironment
        }
    }

    /**
     voucherCode is responsible for silently applying voucher from proposition without user Interaction,
        whenever user visits the Cart Screen
     - Since: 2002.0
     */
    open var voucherCode: String? {
        didSet {
           MECConfiguration.shared.voucherCode = voucherCode
        }
    }

    /**
     Set this value to a positive Integer value if the Cart count is to be restricted.
     If the Cart count exceeds the given value,
     it will throw an error when user presses on Checkout button in Cart Screen.
     **Default value is 0 which means there is no limitation on the Cart count**
     - Since: 2002.0
     */
    open var maxCartCount: Int = 0 {
        didSet {
            MECConfiguration.shared.maximumCartCount = maxCartCount
        }
    }

    // swiftlint:disable inert_defer

    public override init() {
        super.init()
        defer {
            flowConfiguration = MECFlowConfiguration(landingView: .mecProductListView)
        }
    }

    // swiftlint:enable inert_defer
}
