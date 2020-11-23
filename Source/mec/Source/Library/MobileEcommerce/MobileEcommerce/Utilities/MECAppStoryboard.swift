/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

enum MECAppStoryboard: String {
    case productCatalogue = "MECProductCatalogue"
    case productDetails = "MECProductDetails"
    case productRetailers = "MECProductRetailers"
    case shoppingCart = "MECShoppingCart"
    case addAddress = "MECAddAddress"
    case popoverList = "MECPopover"
    case deliveryDetails = "MECDeliveryDetails"
    case checkout = "MECCheckout"
    case manageAddress = "MECManageAddress"
    case cvvPayment = "MECCVVPayment"
    case paymentConfirmation = "MECPaymentConfirmation"
    case orderHistory = "MECOrderHistory"
    case orderDetail = "MECOrderDetail"
    case productFilter = "MECProductFilter"
    case notifyMe = "MECNotifyMe"

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: MECUtility.getBundle())
    }

    func viewcontroller<T: UIViewController>(viewControllerClass: T.Type) -> T? {
        let storyboardId = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardId) as? T
    }
}
