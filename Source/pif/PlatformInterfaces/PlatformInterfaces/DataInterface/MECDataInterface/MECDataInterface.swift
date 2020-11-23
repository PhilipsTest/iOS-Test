/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 Implement this protocol to get the update related to shopping cart
 - Since: 2002.0
 */
@objc public protocol MECCartUpdateProtocol: NSObjectProtocol {
    /**
     This method of MECCartUpdateProtocol notifies the implementation class after any changes to the Cart
     - Parameter cartCount: This variable will give the latest Cart Count after the Cart update changes
     - Since: 2002.0
     */
    func didUpdateCartCount(cartCount: Int)

    /**
     This method of MECCartUpdateProtocol notifies the implementation class to make the cart icon visible or not
     - Parameter shouldShow: This is BOOL flag parameter to notify the visibility of cart icon
     - Note: *Cart functionality is only available for Logged In Users.*
     - Since: 2002.0
     */
    func shouldShowCart(_ shouldShow: Bool)
}

/**
 Conform to this protocol for getting updates in MEC Component.
- Since: 2002.0
*/
@objc public protocol MECDataInterface: NSObjectProtocol {

    /**
    addCartUpdateDelegate is responsible for adding delegate for notifying any Cart related changes
     - Parameter cartUpdateDelegate: The delegate who wants to listen to the callbacks
    - Since: 2002.0
    */
    func addCartUpdateDelegate(_ cartUpdateDelegate: MECCartUpdateProtocol)

    /**
    removeCartUpdateDelegate is responsible for removing delegate which is used for notifying cart updates
     - Parameter cartUpdateDelegate: The delegate which has to be removed.
    - Since: 2002.0
    */
    func removeCartUpdateDelegate(_ cartUpdateDelegate: MECCartUpdateProtocol)

    /**
    isHybrisAvailable method will inform if the current locale and Proposition ID combination of MEC
    supports Hybris or not and accordingly the Cart icon can be shown/hidden
     - Note: If Hybris is explicitly turned off from code, false will be returned as isHybrisAvailable value,
     even though Proposition for that locale might have Hybris enabled in backend
    - Parameter completionHandler: Closure with whether Hybris is available or not and error, if any.
     If any error occurs, error is returned with isHybrisAvailable as false.
    - Since: 2002.0
    */
    func isHybrisAvailable(_ completionHandler: @escaping (_ isHybrisAvailable: Bool, _ error: Error?) -> Void)

    /**
    fetchCartCount will fetch shopping cart count
    - Parameter completionHandler: Closure which contains Cart Count and error, if any.
     If any error occurs, error is returned with cartCount as 0.
    - Since: 2002.0
    */
    func fetchCartCount(completionHandler: @escaping (_ cartCount: Int, _ error: Error?) -> Void)
}
