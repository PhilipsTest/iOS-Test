//
//  UINavigationViewController.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//


import Foundation
import UIKit

protocol PPRNavigationControllerBackButtonDelegate {
    func viewControllerShouldPopOnBackButton() -> Bool
}

extension UINavigationController {
    
    func navigationBar(navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        
        // Prevents from a synchronization issue of popping too many navigation items
        // and not enough view controllers or viceversa from unusual tapping
        if self.viewControllers.count < (navigationBar.items?.count)! {
            return true
        }
        
        // Check if we have a view controller that wants to respond to being popped
        var shouldPop = true
        if let viewController = self.topViewController as? PPRNavigationControllerBackButtonDelegate {
            shouldPop = viewController.viewControllerShouldPopOnBackButton()
        }
        
        if (shouldPop) {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        }
        else {
            // Prevent the back button from staying in an disabled state
            for view in navigationBar.subviews {
                if view.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25, animations: {
                        view.alpha = 1.0
                    }, completion: nil)
                }
            }
        }
        
        return false
    }
    
    func skipViewControllerWhenBackPressed(viewController: UIViewController) -> Bool {
        let index = self.viewControllerIndex(viewController: viewController)
        guard index > 0 else {
            return true
        }
        
        // Skipping ViewController while coming back from it's successor controllers
        let vc = self.viewControllers[index-1]
        self.popToViewController(vc, animated: true)
        return false
    }
    
    func viewControllerIndex(viewController: UIViewController) -> Int {
        for (index, vc) in self.viewControllers.enumerated() {
            if vc.isKind(of: viewController.classForCoder) {
                return index
            }
        }
        return -1
    }
}
