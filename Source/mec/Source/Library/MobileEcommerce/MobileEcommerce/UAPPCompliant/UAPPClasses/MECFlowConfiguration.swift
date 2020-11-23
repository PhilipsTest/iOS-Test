/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
This enum holds all the kinds of landing views with which MEC can be loaded.
- Since: 2001.0
*/

@objc public enum MECLandingView: Int {

    /**
    mecProductListView landing view is used to launch the Product Catalogue Screen.
    - Since: 2001.0
    */
    case mecProductListView

    /**
    mecCategorizedProductListView landing view is used to launch the Product Catalogue Screen with a list of Product CTNs passed.
     - **A list of one or more Product CTNs has to be passed when launching with this Landing View.**
    - Since: 2001.0
    */
    case mecCategorizedProductListView

    /**
    mecProductDetailsView landing view is used to launch the Product Details view for the Product CTN passed.
     - **One Product CTN has to be passed when launching with this Landing View.**
    - Since: 2001.0
    */
    case mecProductDetailsView

    /**
    mecShoppingCartView landing view is used to launch the shopping cart view.
     - Since: 2002.0
     */
    case mecShoppingCartView

    /**
    mecOrderHistoryView landing view is used to launch the order history view of an user
    - Since: 2003.0
    */
    case mecOrderHistoryView
}

/**
This class holds all the Configurations needed to decide the behaviour in which MEC will be launched.
- Since: 2001.0
*/
@objcMembers open class MECFlowConfiguration: NSObject {

    /**
    This variable is used to pass a list of one or more Product CTNs to MEC,
    which will be used in combination with the landing view during launch of MEC.
     
     ## Important Notes ##
     1. For mecProductListView landing view, all the CTNs passed will be ignored.
     2. For mecCategorizedProductListView landing view, all valid CTNs passed will be displayed.
     3. For mecProductDetailsView landing view, if one CTN is passed, that CTN details will be loaded,
     if list of CTNs is passed, the first CTN details will be loaded.
    - Since: 2001.0
    */
    open var productCTNs: [String]?

    /**
    This variable is used to pass a Product Category (eg: PRX Product Category, Hybris Product Category, etc)
    which will be used to fetch the relevant Products for the Category and display in the Product List screen.
     
     ## Important Notes ##
     1. You can pass this value while launching MEC with all the landing views, excpet mecOrderHistoryView.
     2. This value will only be used when Hybris is available.
    - Since: 2004.0
    */
    open var productCategory: String? {
        didSet {
            MECConfiguration.shared.productCategory = productCategory
        }
    }

    /**
    This variable is used to pass a landing view with which MEC will be loaded.
     This only takes a value of type MECLandingView.
     - **Default value is mecProductListView.**

    - Since: 2001.0
    */
    open var landingView: MECLandingView?

    private override init() {
        super.init()
    }

    /**
    This convenience constructor can be used to initialise MECFlowConfiguration with landing view with which MEC will be launched.
     - Parameter landingView: A type of MECLandingView enum.
     - Returns: An instance of MECFlowConfiguration.

    - Since: 2001.0
    */
    public convenience init(landingView: MECLandingView) {
        self.init()
        self.landingView = landingView
    }
}
