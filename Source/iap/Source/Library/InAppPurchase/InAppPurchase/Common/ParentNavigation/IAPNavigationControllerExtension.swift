/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (left?, right?):
    return left < right
  case (nil, _?):
    return true
  default:
    return false
  }
}

protocol IAPNavigationControllerBackButtonDelegate {
    func viewControllerShouldPopOnBackButton() -> Bool
}

extension UINavigationController: IAPAnalyticsTracking {
    
    func popToProductCatalogue(_ fromController: UIViewController?,
                               withCartDelegate: IAPCartIconProtocol?, withInterfaceDelegate: IAPInterface?) {
        var viewControllers = self.viewControllers
        var controllerToPop: IAPProductCatalogueController!
        
        for controller in viewControllers {
            if let controllerToPopToo = controller as? IAPProductCatalogueController {
                controllerToPop = controllerToPopToo
                break
            }
        }
        
        if nil != controllerToPop {
            self.popToViewController(controllerToPop, animated: true)
            return
        } else {
            if let productCatalogueController = IAPUtility.getProductCatalogueController(withCartDelegate,
                                                                                         withInterfaceDelegate: withInterfaceDelegate) {
                if  let controller = fromController {
                    viewControllers.insert(productCatalogueController, at: viewControllers.firstIndex(of: controller)!)
                    self.setViewControllers(viewControllers, animated: false)
                } else {
                    viewControllers.insert(productCatalogueController, at: 1)
                    self.setViewControllers(viewControllers, animated: false)
                }
                self.popToViewController(productCatalogueController, animated: true)
                return
            }
        }
    }
    
    func navigationBar(_ navigationBar: UINavigationBar, shouldPopItem item: UINavigationItem) -> Bool {
        trackAction(parameterData: [IAPAnalyticsConstants.specialEvents: "backButtonPress"], action: IAPAnalyticsConstants.sendData)
        // Prevents from a synchronization issue of popping too many navigation items
        // and not enough view controllers or viceversa from unusual tapping
        if self.viewControllers.count < navigationBar.items?.count {
            return true
        }
        // Check if we have a view controller that wants to respond to being popped
        var shouldPop = true
        if let viewController = self.topViewController as? IAPNavigationControllerBackButtonDelegate {
            shouldPop = viewController.viewControllerShouldPopOnBackButton()
        }

        if shouldPop {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            // Prevent the back button from staying in an disabled state
            for view in navigationBar.subviews {
                if view.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25, animations: { () -> Void in
                        view.alpha = 1.0
                    })
                }
            }
        }

        return false
    }

    func skipBeforeViewControllerWhenBackPressed(_ viewController: UIViewController) -> Bool {
        let index = self.viewControllerIndex(viewController)
        guard index > 0 else {
            return true
        }

        // Skipping ViewController while coming back from it's successor controllers
        let vc = self.viewControllers[index-1]
        self.popToViewController(vc, animated: true)
        return false
    }

    func viewControllerIndex(_ viewController: UIViewController) -> Int {
        for (index, vc) in self.viewControllers.enumerated() {
            if vc.isKind(of: viewController.classForCoder) {
                return index
            }
        }
        return -1
    }
}
