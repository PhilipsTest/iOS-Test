/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit

class MockNavigationController: UINavigationController {

    var pushedViewController: UIViewController?
    var popToProductListCalled = false
    var viewControllersList: [UIViewController]?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
    }
    
    func popToProductListScreen() {
        popToProductListCalled = true
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        viewControllersList = viewControllers
    }
}
