/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

private var VCKey: UInt8 = 0

extension UIViewController : UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if !viewController.shouldSkipShoppingCart {
            guard viewController.navigationItem.rightBarButtonItem != nil else {
              //  Utilites.addCartIconTo(viewController)
                return
            }
        }
    }
}

extension UIViewController {
    
    var shouldSkipShoppingCart : Bool {
        get {
            return Utilites.associatedObject(self, key: &VCKey)
            { return false}
        } set {
            Utilites.associateObject(self,key: &VCKey , value : newValue)
        }
    }
    
    /** Method setNavigationBarTitle is common method to set navigation bar title across the app*/
    func setNavigationBarTitle (_ screenTitle : String) {
        if self.isKind(of:UINavigationController.self){
            (self as? UINavigationController)?.topViewController?.navigationItem.title = screenTitle
        } else {
            navigationItem.title = screenTitle
        }
    }
    
    func setNavigationControllerDelegate() {
        if self.isKind(of:UINavigationController.self) {
            (self as? UINavigationController)?.delegate = (self as? UINavigationController)?.topViewController
        } else {
            navigationController?.delegate = self
        }
    }
}
