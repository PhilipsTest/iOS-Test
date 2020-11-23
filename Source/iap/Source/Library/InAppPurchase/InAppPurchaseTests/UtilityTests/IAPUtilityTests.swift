/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev
@testable import PlatformInterfaces

class IAPUtilityTests: XCTestCase {
    
    static let PHILIPS_TRACK_ACTION = "origin=15_global"
    
    override func setUp() {
        super.setUp()
        IAPConfiguration.sharedInstance.locale = "en_US"
    }

   func testBuilderCreations() {
        let cartInterfaceBuilder = IAPUtility.getCartInterfaceBuilder()
        XCTAssertNotNil(cartInterfaceBuilder, "Builder returned is nil")

        let addressInterfaceBuilder = IAPUtility.getAddressInterfaceBuilder()
        XCTAssertNotNil(addressInterfaceBuilder, "Builder returned is nil")
        
        let paymentInterfaceBuilder = IAPUtility.getPaymentInterfaceBuilder()
        XCTAssertNotNil(paymentInterfaceBuilder, "Builder returned is nil")
        
        let error = IAPUtility.getUserNotLoggedInError()
        XCTAssertNotNil(error, "Error returned is nil")
    }
    
    func testNavigationControllerPopping() {
        let navigationController = UINavigationController()
        XCTAssertNotNil(navigationController, "Controller is nil")
        let shoppingController = IAPUtility.getShoppingCartController(nil, withInterfaceDelegate: nil)
        XCTAssertNotNil(shoppingController, "Controller returned is nil")
        let productCatalogController = IAPUtility.getProductCatalogueController(nil, withInterfaceDelegate: nil)
        XCTAssertNotNil(productCatalogController, "Controller returned is nil")

        let orderViewController = IAPOrderSummaryViewController.instantiateFromAppStoryboard(appStoryboard: .order)
            if let viewControllersToPush = [IAPProductCatalogueController(), orderViewController, shoppingController,
                                            productCatalogController, IAPShoppingCartDetailsViewController()] as? [UIViewController] {
                navigationController.viewControllers = viewControllersToPush
                IAPUtility.popToShoppingCartController(navigationController)

                var countOfControllers = navigationController.viewControllers.count
                XCTAssert(3 == countOfControllers, "Popping to shopping cart was not done properly")

                navigationController.viewControllers = viewControllersToPush
                IAPUtility.popToOrderSummaryViewController(navigationController)
                countOfControllers = navigationController.viewControllers.count
                XCTAssert(2 == countOfControllers, "Popping to order summary was not done properly")
            }
        }
    
    func testStringManipulation() {
        let stringToPass = "In app purchase"
        let strikedString = IAPUtility.getStrikeThroughAttributedText(stringToPass)
        XCTAssertNotNil(strikedString, "String returned is nil")
        XCTAssert(strikedString.length == stringToPass.length, "Lengths of both the strings are not matching")
    }
    
    func testCellCreation() {
        let orderViewController = IAPOrderSummaryViewController.instantiateFromAppStoryboard(appStoryboard: .order)
        orderViewController.loadView()
        var vatCell = IAPUtility.getTotalCell(orderViewController.shoppingTableView, withTotal: "In App Purchase")
        XCTAssertNotNil(vatCell, "Cell returned is nil")
        vatCell = IAPUtility.getTotalCell(orderViewController.shoppingTableView, withTotal: "In App Purchase", withItems: 2)
        XCTAssertNotNil(vatCell, "Cell returned is nil")
    }
    
    func testGetUserLoggingError() {
        let error = IAPUtility.getUserNotLoggedInError()
        XCTAssertNotNil(error, "error returned is nil")
    }

    func testGetServiceDicoveryError() {
        let error = IAPUtility.getServiceDiscoveryError()
        XCTAssertNotNil(error, "error returned is nil")
    }
    
    func testCommonViewForHeaderInSection() {
        if let headerView = IAPUtility.getBundle().loadNibNamed("IAPPurchaseHistoryOverviewSectionHeader",
            owner: self, options: nil)?[0] as? IAPPurchaseHistoryOverviewSectionHeader {

            let headerView1 = IAPUtility.commonViewForHeaderInSection(IAPConstants.IAPCommonSectionHeaderView.kShoppingCartSection,
                                                                      sectionValue: IAPConstants.TableviewSectionConstants.kShoppingCartSection,
                                                                      headerView: headerView) as? IAPPurchaseHistoryOverviewSectionHeader
            XCTAssertNotNil(headerView1, "section header view returned is nil")

            let headerView2 = IAPUtility.commonViewForHeaderInSection(
                                IAPConstants.IAPCommonSectionHeaderView.kShoppingCartSection,
                                sectionValue: IAPConstants.TableviewSectionConstants.kShoppingCartSection,
                                productCount: 2, headerView: headerView) as? IAPPurchaseHistoryOverviewSectionHeader
            XCTAssertNotNil(headerView2, "section header view returned is nil")


            let headerView3 = IAPUtility.commonViewForHeaderInSection(
                                        IAPConstants.IAPCommonSectionHeaderView.kShoppingCartSection,
                                              sectionValue: IAPConstants.TableviewSectionConstants.kAddressCellSection,
                                                    headerView: headerView) as? IAPPurchaseHistoryOverviewSectionHeader
            XCTAssertNotNil(headerView3, "section header view returned is nil")

            let headerView4 = IAPUtility.commonViewForHeaderInSection(
                                        IAPConstants.IAPCommonSectionHeaderView.kShoppingCartSection,
                                        sectionValue: IAPConstants.TableviewSectionConstants.kDeliveryModeSection,
                                                headerView: headerView) as? IAPPurchaseHistoryOverviewSectionHeader
            XCTAssertNotNil(headerView4, "section header view returned is nil")

            let headerView5 = IAPUtility.commonViewForHeaderInSection(
                                                        IAPConstants.IAPCommonSectionHeaderView.kOrderSummarySection,
                                            sectionValue: IAPConstants.TableviewSectionConstants.kOrderSummarySection,
                                                headerView: headerView) as? IAPPurchaseHistoryOverviewSectionHeader
            XCTAssertNotNil(headerView5, "section header view returned is nil")

            let headerView6 = IAPUtility.commonViewForHeaderInSection(
                                                        IAPConstants.IAPCommonSectionHeaderView.kOrderSummarySection,
                                            sectionValue: IAPConstants.TableviewSectionConstants.kAddressCellSection,
                                                headerView: headerView) as? IAPPurchaseHistoryOverviewSectionHeader
            XCTAssertNotNil(headerView6, "section header view returned is nil")
        }
    }
    
    func testIsStockavailable() {
        XCTAssertFalse(IAPUtility.isStockAvailable(stockLevelStatus: IAPConstants.IAPShoppingCartKeys.kOutOfStockKey,
                                                   stockAmount: 0))
        XCTAssertTrue(IAPUtility.isStockAvailable(stockLevelStatus: IAPConstants.IAPShoppingCartKeys.kInStockKey,
                                                  stockAmount: 3))
    }
    
    func testLoginRequirementForCatalogueLandingView() {
        XCTAssertFalse(IAPUtility.isLoginRequired(for: IAPTestUtilities.configureIAPLaunchInput(with: .iapProductCatalogueView)))
    }
    
    func testLoginRequirementForCatalogueCategorizedLandingView() {
        XCTAssertFalse(IAPUtility.isLoginRequired(for: IAPTestUtilities.configureIAPLaunchInput(with: .iapCategorizedCatalogueView)))
    }
    
    func testLoginRequirementForCartLandingView() {
        XCTAssertTrue(IAPUtility.isLoginRequired(for: IAPTestUtilities.configureIAPLaunchInput(with: .iapShoppingCartView)))
    }
    
    func testLoginRequirementForPurchaseHistoryLandingView() {
        XCTAssertTrue(IAPUtility.isLoginRequired(for: IAPTestUtilities.configureIAPLaunchInput(with: .iapPurchaseHistoryView)))
    }
    
    func testLoginRequirementForProductDetailsLandingView() {
        XCTAssertFalse(IAPUtility.isLoginRequired(for: IAPTestUtilities.configureIAPLaunchInput(with: .iapProductDetailView)))
    }
    
    func testTaggingURLForNonPhilipsRetailer() {
        let nonPhilipsRetailer = FakeRetailerModel(isPhilipsStore: false)
        if let buyURL = URL(string: nonPhilipsRetailer.buyURL),
            let tagURL = (IAPUtility.fetchTaggingURLFor(actualURL: buyURL)) {
            XCTAssertTrue(tagURL.absoluteString.contains(IAPUtilityTests.PHILIPS_TRACK_ACTION))
        }
    }
    
    func testTaggingURLForPhilipsRetailer() {
        let nonPhilipsRetailer = FakeRetailerModel(isPhilipsStore: true)
        if let buyURL = URL(string: nonPhilipsRetailer.buyURL),
            let tagURL = (IAPUtility.fetchTaggingURLFor(actualURL: buyURL)) {
            XCTAssertTrue(tagURL.absoluteString.contains(IAPUtilityTests.PHILIPS_TRACK_ACTION))
        }
    }
    
    func testTaggingURLForPhilipsRetailerAndNoParameters() {
        let nonPhilipsRetailer = FakeRetailerModel(isPhilipsStore: true, storeURL: "https://philips.channelsight.com//ClickThru/Index/7ef57669-b703-4472-be81-7bfb093d185d")
        if let buyURL = URL(string: nonPhilipsRetailer.buyURL),
            let tagURL = (IAPUtility.fetchTaggingURLFor(actualURL: buyURL)) {
            XCTAssertTrue(tagURL.absoluteString.contains(IAPUtilityTests.PHILIPS_TRACK_ACTION))
        }
    }
    
    func testTaggingURLForNonPhilipsRetailerAndNoParameters() {
        let nonPhilipsRetailer = FakeRetailerModel(isPhilipsStore: false, storeURL: "https://philips.channelsight.com//ClickThru/Index/7ef57669-b703-4472-be81-7bfb093d185d")
        if let buyURL = URL(string: nonPhilipsRetailer.buyURL),
            let tagURL = (IAPUtility.fetchTaggingURLFor(actualURL: buyURL)) {
            XCTAssertTrue(tagURL.absoluteString.contains(IAPUtilityTests.PHILIPS_TRACK_ACTION))
        }
    }
}

class IAPTestUtilities: NSObject {
    
    @discardableResult
    class func configureIAPLaunchInput(with landingView:IAPLaunchInput.IAPFlow) -> IAPLaunchInput {
        let iapLaunchInput: IAPLaunchInput! = IAPLaunchInput()
        iapLaunchInput.landingView = landingView
        return iapLaunchInput
    }
}

class FakeRetailerModel: IAPRetailerModel {
    
    init(inDict: [String : AnyObject] = [:], isPhilipsStore: Bool, storeURL: String = "") {
        let philipsStoreAvailable = isPhilipsStore ? "Y" : "N"
        let philipsBuyURL = storeURL.count > 0 ? storeURL : "https://philips.channelsight.com//ClickThru/Index/7ef57669-b703-4472-be81-7bfb093d185d?lang=en"
        super.init(inDict: [IAPConstants.IAPRetailerKeys.kRetailerNameKey: "Amazon" as NSObject,
                            IAPConstants.IAPRetailerKeys.kRetailerProductAvailability: "YES" as AnyObject,
                            IAPConstants.IAPRetailerKeys.kRetailerBuyURL: philipsBuyURL as AnyObject,
                            IAPConstants.IAPRetailerKeys.kRetailerLogoURL: "https://channelsightstorage.blob.core.windows.net/logos/PhilipsAmazonUS.png" as AnyObject,
                            IAPConstants.IAPRetailerKeys.kPhilipsStoreAvailable: philipsStoreAvailable as NSObject])
    }
}
