//
//  IAPShoppingCartViewControllerTests.swift
//  InAppPurchase
//
//  Created by Chittaranjan Sahu on 11/23/16.
//  Copyright © 2016 Rakesh R. All rights reserved.
//

import XCTest
import AppInfra
import AdobeMobileSDK
@testable import InAppPurchaseDev

class IAPShoppingCartViewControllerTests: XCTestCase {
    
    var shoppingController: IAPShoppingCartViewController!
    
    override func setUp() {
        super.setUp()
        shoppingController = IAPShoppingCartViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        
        Bundle.loadSwizzler()
        ADBMobile.overrideConfigPath(Bundle.main.path(forResource: "ADBMobileConfig", ofType: "json")!)
        let appInfra = AIAppInfra(builder: nil)
        IAPConfiguration.setIAPConfiguration("en_US", inAppInfra: appInfra!)
        let componentInfoDict:Dictionary = Bundle.main.infoDictionary!
        IAPConfiguration.sharedInstance.sharedAppInfra.tagging.createInstance(
            forComponent: componentInfoDict["CFBundleName"] as? String ?? "",
            componentVersion: componentInfoDict["CFBundleShortVersionString"] as? String ?? "")
        
        shoppingController.loadView()
        shoppingController.viewDidLoad()
        shoppingController.viewWillAppear(false)
        shoppingController.didTapTryAgain()
        
        let dict = self.deserializeData("IAPOCCCartInfoSampleResponse")
        let cartModelInfo = IAPCartInfo(inDict: dict! as NSDictionary)
        shoppingController.decorator.shoppingCartInfo = cartModelInfo
    }
    
    override func tearDown() {
        Bundle.deSwizzle()
        IAPConfiguration.sharedInstance.maximumCartCount = 0
        super.tearDown()
    }
    
    func testUpdateUIForEmptyCart() {
        shoppingController?.updateUIForEmptyCart()
        XCTAssertTrue(shoppingController?.noItemsLabel?.isHidden == false, "No items label should not be hidden. It should be false")
        XCTAssertTrue(shoppingController?.checkoutBtn?.isHidden == true, "Check out button should be hidden. It should be true")
    }
    
    func testUpdateUIForNonEmptyCart() {
        shoppingController?.updateUIForNonEmptyCart()
        XCTAssertTrue(shoppingController?.noItemsLabel?.isHidden == true, "No items label should be hidden. It should be true")
        XCTAssertTrue(shoppingController?.checkoutBtn?.isHidden == false, "Check out button should not be hidden. It should be false")
    }
    
    func testAdjustView() {
        shoppingController?.adjsutView(false)
        XCTAssertTrue(shoppingController?.checkoutBtn?.isEnabled == false, "Check out button should not be enabled.")
    }
    
    func testDisplayDeliveryModeView() {
        let navController = IAPTestNavigationController()
        navController.pushViewController(shoppingController!, animated: false)
        shoppingController?.displayDeliveryModeView()
        XCTAssertTrue(navController.pushedViewController is IAPDeliveryModeViewController, "IAPDeliveryModeViewController was not pushed")
    }
    
    func testPushDetailView() {
        let dictionary   = self.deserializeData("IAPProductSampleResponse")
        let productModel = IAPProductModelCollection(inDict: dictionary!)
        
        let navController = IAPTestNavigationController()
        navController.pushViewController(shoppingController!, animated: false)
        
        shoppingController?.pushDetailView(productModel.getProducts()[0])
        XCTAssertTrue(navController.pushedViewController is IAPShoppingCartDetailsViewController, "IAPShoppingCartDetailsViewController was not pushed")
    }
    
    func testNavigateToAddressSelectionView() {
        let navController = IAPTestNavigationController()
        navController.pushViewController(shoppingController!, animated: false)
        
        shoppingController?.navigateToAddressSelectionView()
        XCTAssertTrue(navController.pushedViewController is IAPShippingAddressSelectionViewcontroller, "IAPShippingAddressSelectionViewcontroller was not pushed")
    }
    
    func testNavigateToShippingAddressEditView() {
        let navController = IAPTestNavigationController()
        navController.pushViewController(shoppingController!, animated: false)
        
        shoppingController?.navigateToShippingAddressEditView()
        XCTAssertTrue(navController.pushedViewController is IAPShippingAddressEditViewController, "IAPShippingAddressEditViewController was not pushed")
    }
    
    func testMaximumShoppingCartCountByDefault() {
        XCTAssertTrue(shoppingController.shouldAllowCheckout())
    }
    
    func testMaximumShoppingCartForZeroCount() {
        IAPConfiguration.sharedInstance.maximumCartCount = 0
        XCTAssertTrue(shoppingController.shouldAllowCheckout())
    }
    
    func testMaximumShoppingCartDoesnotCheckForZero() {
        IAPConfiguration.sharedInstance.maximumCartCount = 0
        shoppingController.decorator.shoppingCartInfo.totalUnitCount = 0
        XCTAssertTrue(shoppingController.shouldAllowCheckout())
    }
    
    func testMaximumShoppingCartForLessCount() {
        IAPConfiguration.sharedInstance.maximumCartCount = 2
        shoppingController.decorator.shoppingCartInfo.totalUnitCount = 1
        XCTAssertTrue(shoppingController.shouldAllowCheckout())
    }
    
    func testMaximumShoppingCartForEqualCount() {
        IAPConfiguration.sharedInstance.maximumCartCount = 2
        shoppingController.decorator.shoppingCartInfo.totalUnitCount = 2
        XCTAssertTrue(shoppingController.shouldAllowCheckout())
    }
    
    func testMaximumShoppingCartForGreaterCount() {
        IAPConfiguration.sharedInstance.maximumCartCount = 2
        shoppingController.decorator.shoppingCartInfo.totalUnitCount = 3
        XCTAssertFalse(shoppingController.shouldAllowCheckout())
    }
    
    func testMaximumShoppingCartForNilCart() {
        IAPConfiguration.sharedInstance.maximumCartCount = 2
        shoppingController.decorator.shoppingCartInfo.totalUnitCount = nil
        XCTAssertTrue(shoppingController.shouldAllowCheckout())
    }
}
