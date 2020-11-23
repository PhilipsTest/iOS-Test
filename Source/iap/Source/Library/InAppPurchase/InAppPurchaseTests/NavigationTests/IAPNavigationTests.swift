/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
import AdobeMobileSDK
@testable import InAppPurchaseDev

class IAPNavigationTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        ADBMobile.overrideConfigPath(Bundle.main.path(forResource: "ADBMobileConfig", ofType: "json")!)
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
        let componentInfoDict:Dictionary = Bundle.main.infoDictionary!
        IAPConfiguration.sharedInstance.sharedAppInfra.tagging.createInstance(
            forComponent: componentInfoDict["CFBundleName"] as? String ?? "",
            componentVersion: componentInfoDict["CFBundleShortVersionString"] as? String ?? "")
    }
    
    override class func tearDown() {
        Bundle.deSwizzle()
        super.tearDown()
    }
    
    func testViewControllerIndex() {
        let navigationController = UINavigationController()
        let productCatalogController = IAPProductCatalogueController()
        let storyboard = IAPAppStoryboard.order.instance

        if let shoppingController = IAPUtility.getShoppingCartController(nil, withInterfaceDelegate: nil) {
            let orderViewController = IAPOrderSummaryViewController.instantiateFromAppStoryboard(appStoryboard: .order)
            if var viewControllersToPush = [shoppingController, orderViewController, productCatalogController] as? [UIViewController] {
                navigationController.viewControllers = viewControllersToPush
                var indexOfController =  navigationController.viewControllerIndex(orderViewController)
                XCTAssert(1 == indexOfController, "Index returned is not proper")
                indexOfController =  navigationController.viewControllerIndex(shoppingController)
                XCTAssert(0 == indexOfController, "Index returned is not proper")
                indexOfController =  navigationController.viewControllerIndex(productCatalogController)
                XCTAssert(2 == indexOfController, "Index returned is not proper")
                viewControllersToPush = [shoppingController, productCatalogController]
                navigationController.viewControllers = viewControllersToPush
                indexOfController =  navigationController.viewControllerIndex(orderViewController)
                XCTAssert(-1 == indexOfController, "Index returned is not proper")
            }
        } else {
            assertionFailure("view controller creation failed")
        }
    }
    
    func testSkipVeforeViewController() {
        let navigationController = UINavigationController()
        let shoppingController = IAPUtility.getShoppingCartController(nil, withInterfaceDelegate: nil)
        let productCatalogController = IAPProductCatalogueController()
        
        var storyboard = IAPAppStoryboard.order.instance
        let orderViewController = IAPOrderSummaryViewController.instantiateFromAppStoryboard(appStoryboard: .order)
        storyboard = IAPAppStoryboard.order.instance
        let deliveryVC = IAPDeliveryModeViewController.instantiateFromAppStoryboard(appStoryboard: .order)
        if let viewControllersToPush = [shoppingController, orderViewController, deliveryVC] as? [UIViewController] {
            navigationController.viewControllers = viewControllersToPush
            var result = navigationController.skipBeforeViewControllerWhenBackPressed(deliveryVC)
            var controllerCount = navigationController.viewControllers.count
            XCTAssert(2 == controllerCount, "Index returned is not proper")
            XCTAssert(result == false, "Value returned is not right")

            //                viewControllersToPush = [shoppingController, orderViewController, deliveryVC]
            navigationController.viewControllers = viewControllersToPush
            result = navigationController.skipBeforeViewControllerWhenBackPressed(productCatalogController)
            controllerCount = navigationController.viewControllers.count
            XCTAssert(3 == controllerCount, "Index returned is not proper")
            XCTAssert(result == true, "Value returned is not right")
        }
    }
}
