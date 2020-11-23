//
//  IAPAppStoryboard.swift
//  InAppPurchase
//
//  Created by Prasad Devadiga on 27/11/18.
//  Copyright © 2018 Rakesh R. All rights reserved.
//

import UIKit
import Foundation

enum IAPAppStoryboard: String {
    case productCatalogue = "ProductCatalogueStoryboard"
    case purchaseHistory  = "PurchaseHistory"
    case shoppingCart     = "ShoppingCart"
    case buyDirect        = "BuyDirect"
    case worldPay         = "WorldPay"
    case shippingAddress  = "ShippingAddress"
    case order            = "Order"
    case retailer         = "Retailer"

    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: IAPUtility.getBundle())
    }

    func viewcontroller<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardId = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardId) as! T
    }

}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }

    static func instantiateFromAppStoryboard(appStoryboard: IAPAppStoryboard) -> Self {
        return appStoryboard.viewcontroller(viewControllerClass: self)
    }
}
