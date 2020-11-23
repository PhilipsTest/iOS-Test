/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import UAPPFramework
import PlatformInterfaces

@testable import InAppPurchaseDev
import PhilipsRegistration

class IAPInterfaceHelperTests: XCTestCase {
    
    let interfaceHelper = IAPInterfaceHelper()
    let iapAppDependencies = IAPDependencies()
    let appSettings = IAPSettings( )
    var iapInterface : IAPInterface? = nil
    let productCTNList : [String] = ["12345", "54321"]
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        let appInfra = AIAppInfra(builder: nil)
        iapAppDependencies.appInfra = appInfra
        iapAppDependencies.userDataInterface = setUserDataInterface(appInfra: appInfra)
        iapInterface = IAPInterface(dependencies: iapAppDependencies, andSettings: appSettings)
        interfaceHelper.delegate = iapInterface
    }
    
    func setUserDataInterface(appInfra:AIAppInfra!) -> UserDataInterface!{
        let UserRegistrationDependencies = URDependencies()
        UserRegistrationDependencies.appInfra = appInfra
        let urInterface = URInterface(dependencies: UserRegistrationDependencies, andSettings: nil)
        return urInterface.userDataInterface()
    }
    
    override func tearDown() {
        super.tearDown()
        Bundle.deSwizzle()
    }
    
    func testInit() {
        let interfaceHelper = IAPInterfaceHelper()
        XCTAssertNotNil(interfaceHelper,"object is not initialized")
    }
    
    func testLaunchIAPShoppingCart() {
        
        let viewController = interfaceHelper.launchIAPShoppingCart(productCTNList[0]) { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        }
        XCTAssert(viewController is IAPShoppingCartViewController, "view controller is not of type IAPShoppingCartViewController")
    }
    
    func testLaunchIAPProductCatalogue() {
        let viewController = interfaceHelper.launchIAPProductCatalogue(productCTNList)
        XCTAssert(viewController is IAPProductCatalogueController, "view controller is not of type IAPShoppingCartViewController")
    }
    
    /*func testLaunchIAPCategorizedCatalogue() {
        let viewController = interfaceHelper.launchCategorizedCatalog(productCTNList)
        XCTAssert(viewController is IAPProductCatalogueController!, "view controller is not of type IAPProductCatalogueController")
    }*/
    
    func testLaunchIAPPurchaseHistory() {
        let viewController = interfaceHelper.launchIAPPurchaseHistoryController()
        XCTAssert(viewController is IAPPurchaseHistoryViewController, "view controller is not of type IAPPurchaseHistoryViewController")
    }
    
    func testLaunchIAPProductDetailView() {
        var viewController = interfaceHelper.launchIAPProductDetailView(productCTNList[0]) { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        }
        XCTAssertNotNil(viewController, "view controller returned is nil")
        
        //test for invalid product
        viewController = interfaceHelper.launchIAPProductDetailView("", failure: { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        })
        XCTAssertNil(viewController, "view controller should be nil as invalid product ctn is passed.")
    }
    
    func testLaunchBuyDirectView() {
        var viewController = interfaceHelper.launchIAPBuyDirectView(productCTNList[0]) { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        }
        XCTAssertNotNil(viewController, "view controller returned is nil")
        
        //test for invalid product
        viewController = interfaceHelper.launchIAPBuyDirectView("", failure: { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        })
        XCTAssertNil(viewController, "view controller should be nil as invalid product ctn is passed.")
    }
    
    /*func testLocaleCodeFromLocaleManager() {
        interfaceHelper.currentLocale("") { (inLocaleCode) in
            let localeMatch = inLocaleCode
            XCTAssertNotNil(localeMatch, "locale match returned is nil")
        }
    }*/
    
    func testInitiateAllProductsDownload() {
        let interfaceHelper = IAPInterfaceHelper()
        IAPConfiguration.sharedInstance.oauthInfo = IAPOAuthInfo()
        IAPConfiguration.sharedInstance.locale = "en_US"
        IAPConfiguration.sharedInstance.baseURL = "https://www.occ.shop.philips.com"
        
        interfaceHelper.initiateAllProductsDownload({ (withProducts) in
            XCTAssertNotNil(withProducts,"products downloaded is nil")
        }) { (inError) in
            XCTAssertNotNil(inError,"Error returned is nil")
        }
    }
    
    func testLaunchView() {
        
        var viewController : UIViewController?
        
        //test for catalogue view
        viewController = interfaceHelper.launchView(.iapProductCatalogueView, withProductCTN: productCTNList, failure: { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        })
        XCTAssertNotNil(viewController, "view controller returned is nil")
        XCTAssert(viewController is IAPProductCatalogueController, "Catalogue view controller is not returned")
        
        //test for catalogue view with empty product list
        viewController = interfaceHelper.launchView(.iapProductCatalogueView, withProductCTN: [], failure: { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        })
        XCTAssertNil(viewController, "view controller returned is not nil")
        
        
        //test for purchase history view
        viewController = interfaceHelper.launchView(.iapPurchaseHistoryView, withProductCTN: productCTNList) { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        }
        
        XCTAssertNotNil(viewController, "view controller returned is nil")
        XCTAssert(viewController is IAPPurchaseHistoryViewController, "Purchase history view controller is not returned")
        
        //test for shopping cart view
        viewController = interfaceHelper.launchView(.iapShoppingCartView, withProductCTN: productCTNList) { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        }
        
        XCTAssertNotNil(viewController, "view controller returned is nil")
        XCTAssert(viewController is IAPShoppingCartViewController, "Shopping cart view controller is not returned")
        
        //test for shopping cart view with empty product list
        viewController = interfaceHelper.launchView(.iapShoppingCartView, withProductCTN: []) { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        }
        
        XCTAssertNotNil(viewController, "view controller returned is nil")
        XCTAssert(viewController is IAPShoppingCartViewController, "Shopping cart view controller is not returned")
        
        //test for categorized view
        viewController = interfaceHelper.launchView(.iapCategorizedCatalogueView, withProductCTN: productCTNList) { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        }
        
        XCTAssertNotNil(viewController, "view controller returned is nil")
        XCTAssert(viewController is IAPProductCatalogueController, "Categorized catalogue view controller is not returned")
        
        //test for buy direct view
        viewController = interfaceHelper.launchView(.iapBuyDirectView, withProductCTN: productCTNList) { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        }
        
        XCTAssertNotNil(viewController, "view controller returned is nil")
        XCTAssert(viewController is IAPBuyDirectViewController, "Buy direct view controller is not returned")
        
        //test for product detail view
        viewController = interfaceHelper.launchView(.iapProductDetailView, withProductCTN: productCTNList) { (inError) in
            XCTAssertNotNil(inError, "error returned is nil")
        }
        
        XCTAssertNotNil(viewController, "view controller returned is nil")
        XCTAssert(viewController is IAPShoppingCartDetailsViewController, "Product detail view controller is not returned")
    }
    
    func testErrorCallbackForNotLoggedInForCatalogue() {
        let mockUserInterface = MockUserDataInterface()
        iapAppDependencies.userDataInterface = mockUserInterface
        let launchInput = IAPTestUtilities.configureIAPLaunchInput(with: .iapProductCatalogueView)
        if let inAppInterface = iapInterface {
            _ = inAppInterface.instantiateViewController(launchInput)
            XCTAssertFalse(inAppInterface.shouldShowLoginError())
        }
    }
    
    func testErrorCallbackForLoggedInForCatalogue() {
        let mockUserInterface = MockUserDataInterface()
        mockUserInterface.isLoggedIn = true
        iapAppDependencies.userDataInterface = mockUserInterface
        let launchInput = IAPTestUtilities.configureIAPLaunchInput(with: .iapProductCatalogueView)
        if let inAppInterface = iapInterface {
            _ = inAppInterface.instantiateViewController(launchInput)
            XCTAssertFalse(inAppInterface.shouldShowLoginError())
        }
    }
    
    func testErrorCallbackForLoggedInForCart() {
        let mockUserInterface = MockUserDataInterface()
        mockUserInterface.isLoggedIn = true
        iapAppDependencies.userDataInterface = mockUserInterface
        let launchInput = IAPTestUtilities.configureIAPLaunchInput(with: .iapShoppingCartView)
        if let inAppInterface = iapInterface {
            _ = inAppInterface.instantiateViewController(launchInput)
            XCTAssertFalse(inAppInterface.shouldShowLoginError())
        }
    }
    
    func testErrorCallbackForNotLoggedInForCart() {
        let mockUserInterface = MockUserDataInterface()
        iapAppDependencies.userDataInterface = mockUserInterface
        let launchInput = IAPTestUtilities.configureIAPLaunchInput(with: .iapShoppingCartView)
        if let inAppInterface = iapInterface {
            _ = inAppInterface.instantiateViewController(launchInput)
            XCTAssertTrue(inAppInterface.shouldShowLoginError())
        }
    }
    
    func testErrorCallbackWithoutConfig() {
        let mockUserInterface = MockUserDataInterface()
        iapAppDependencies.userDataInterface = mockUserInterface
        if let inAppInterface = iapInterface {
            XCTAssertTrue(inAppInterface.shouldShowLoginError())
        }
    }
    
    func testErrorCallbackWithConfig() {
        let mockUserInterface = MockUserDataInterface()
        mockUserInterface.isLoggedIn = true
        iapAppDependencies.userDataInterface = mockUserInterface
        if let inAppInterface = iapInterface {
            XCTAssertFalse(inAppInterface.shouldShowLoginError())
        }
    }
}
