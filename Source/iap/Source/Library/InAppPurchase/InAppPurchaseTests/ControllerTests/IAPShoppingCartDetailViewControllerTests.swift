//
//  IAPShoppingCartDetailViewControllerTests.swift
//  InAppPurchase
//
//  Created by Chittaranjan Sahu on 11/23/16.
//  Copyright © 2016 Rakesh R. All rights reserved.
//

import XCTest
import AppInfra
import PhilipsUIKitDLS
@testable import InAppPurchaseDev

class IAPShoppingCartDetailViewControllerTests: XCTestCase {
    
    var iapShoppingCartDecoratorDelegate: IAPShoppingCartDecoratorProtocolTest!
    var iapShoppingCartDetailsVC: IAPShoppingCartDetailsViewController!
    var iapPopOverDelegate:IAPPopOverProtocolTest!
    
    var iapHandlerTest: IAPInterface!
    var productInfoTest: IAPProductModel!
    var productInfoTest1: IAPProductModel!
    var isFromProductCatalogueViewTest: Bool = false
    var isFromShoppingCartViewTest: Bool = false
    var isFromPurchaseHistoryOrderDetailViewTest: Bool = false
    var testViews = [UIViewController]()
    var pageViewControllerTest: UIPageViewController?
    var currentIndexTest = 0
    var imageUrlListTest: [String] = []
    var productCTNTest:String = ""
    fileprivate var iapDownloadHelperTest = IAPProductInfoHelper()
    fileprivate var cartSyncHelperTest: IAPCartSyncHelper = IAPCartSyncHelper()
    let popoverControllerTest = IAPCustomPopoverController()
    
    let iapAppDependencies = IAPDependencies()
    let appSettings = IAPSettings()

    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        let appInfra = AIAppInfra(builder: nil)
        
        IAPConfiguration.sharedInstance.sharedAppInfra = appInfra
        IAPConfiguration.sharedInstance.locale = "en_US"
        
        let dictionary = self.deserializeData("IAPProductSampleResponse")
        let productsInfo = IAPProductModelCollection(inDict: dictionary!)
        productInfoTest = productsInfo.getProducts().first!
        productInfoTest.setProductTitle("Title")
        let dict = self.deserializeData("IAPOCCCartInfoSampleResponse")
        let shoppingCartInfoTest = IAPCartInfo(inDict: dict! as NSDictionary)
        
        let cartEntryInfo = IAPCartEntriesInfo()
        cartEntryInfo.stockAmount = 32
        cartEntryInfo.quantity    = 22
        cartEntryInfo.entryNumber = 10
        cartEntryInfo.productPrice = "99"
        cartEntryInfo.productBasePrice = "99"
        
        productInfoTest = shoppingCartInfoTest.getProductModel(cartEntryInfo)

        iapShoppingCartDecoratorDelegate = IAPShoppingCartDecoratorProtocolTest()
        iapPopOverDelegate = IAPPopOverProtocolTest()
        iapShoppingCartDetailsVC = IAPShoppingCartDetailsViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        iapShoppingCartDetailsVC.productInfo = productInfoTest
        iapShoppingCartDetailsVC.shoppingCartInfo = shoppingCartInfoTest

        iapShoppingCartDetailsVC.viewDidLoad()
        iapShoppingCartDetailsVC.viewWillAppear(false)
        iapShoppingCartDetailsVC.viewDidDisappear(false)
    }
    
    override func tearDown() {
        super.tearDown()
        Bundle.deSwizzle()
    }
    
    func testUpdateUIForNonHybris() {
        iapShoppingCartDetailsVC.updateUIForNonHybris()
        XCTAssertTrue(iapShoppingCartDetailsVC.ratingView?.isHidden == true, "Update UI for Non Hybris failed")
    }
    
    func testUpdateUIForHybris() {
        iapShoppingCartDetailsVC.isFromPurchaseHistoryOrderDetailView = true
        iapShoppingCartDetailsVC.updateUIForHybris()
        XCTAssertTrue(iapShoppingCartDetailsVC.stockStatusLabel?.isHidden == true, "Update UI for Non Hybris failed")
        
        iapShoppingCartDetailsVC.isFromProductCatalogueView = true
        iapShoppingCartDetailsVC.updateUIForHybris()
        XCTAssertTrue(iapShoppingCartDetailsVC.stockStatusLabel?.isHidden == true, "Update UI for Non Hybris failed")
        
        // Need to handle few more scenarios ..
    }
    
    func testUpdateUI() {
        iapShoppingCartDetailsVC.updateUI()
        XCTAssertNotNil(iapShoppingCartDetailsVC.productDiscountPriceLabel?.text, "Product Discount price label is nil.")
        iapShoppingCartDetailsVC.productInfo.setDiscountPrice("20.0")
        XCTAssertNotNil(iapShoppingCartDetailsVC.productDiscountPriceLabel?.text, "Product Discount price label is nil.")
        iapShoppingCartDetailsVC.isFromProductCatalogueView = true
        iapShoppingCartDetailsVC.productInfo.setTotalPrice("30")
        XCTAssertNotNil(iapShoppingCartDetailsVC.productDiscountPriceLabel?.text, "Product Discount price label is nil.")
    }
    
    func testDidTapTryAgain() {
        iapShoppingCartDetailsVC.didTapTryAgain()
    }
    
    func testFilterOutBlackListedRetailers() {
        let retailerDict = self.deserializeData("IAPRetailerSampleResponse")
        let actualRetailerModelList = IAPRetailerModelCollection(inDict: retailerDict!).getRetailers()
        var filteredRetailerModelList = iapShoppingCartDetailsVC.filterOutBlackListedRetailers(["Walmart"], actualRetailerModelList: actualRetailerModelList)
        XCTAssertNotNil(filteredRetailerModelList, "Filter retailer list is empty")
        
        filteredRetailerModelList = iapShoppingCartDetailsVC.filterOutBlackListedRetailers(
            ["Walmart","amazon","walgreens","Soap","Drugstore","Diapers","Philips"],
            actualRetailerModelList: actualRetailerModelList)
        XCTAssertTrue(filteredRetailerModelList.count == 0, "It does not filter out all retailer list")
    }
    
    func testShowAlertForNoRetailers() {
        iapShoppingCartDetailsVC.showAlertForNoRetailers()
        XCTAssertNotNil(iapShoppingCartDetailsVC.uidAlertController, "UIDAlert controller is nil")
    }
    
    func testProcessRetailerResponseFromWTB() {
        let retailerDict = self.deserializeData("IAPRetailerSampleResponse")
        let actualRetailerModelList = IAPRetailerModelCollection(inDict: retailerDict!).getRetailers()
        iapShoppingCartDetailsVC.processRetailerResponseFromWTB(actualRetailerModelList)
        IAPConfiguration.sharedInstance.setBlackListRetailers(["Philips Online Shop"])
        iapShoppingCartDetailsVC.processRetailerResponseFromWTB(actualRetailerModelList)
    }

    
    /*func testQuantityViewClicked() {
        let testView = UIView(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(tapBlurButton(_:)))
        gestureRecognizer.delegate = iapShoppingCartDetailsVC
        testView.addGestureRecognizer(gestureRecognizer)
        iapShoppingCartDetailsVC.quantityViewClicked(gestureRecognizer)
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Hello!")
    }*/
    /*func testAddToCartClicked() {
        let sender:UIDProgressButton = UIDProgressButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        iapShoppingCartDetailsVC.addToCartClicked(sender)
    }*/
}

class IAPShoppingCartDecoratorProtocolTest: IAPShoppingDecoratorProtocol {
    var updateQuantityMethodInvoked = false
    
    func updateQuantity(_ objectToBeUpdated: IAPProductModel, withCartInfo: IAPCartInfo, quantityValue: Int) {
        updateQuantityMethodInvoked = true
    }
    func adjsutView(_ shouldEnable: Bool) {
        
    }
    
    func displayVoucherView(){
        
    }
    func displayDeliveryModeView() {
        
    }
    func pushDetailView(_ withObject: IAPProductModel) {
        
    }
}

class IAPPopOverProtocolTest: CustomPopoverControllerDelegate {
    var controllerDidDismissMethodInvoked = false
    
    func controllerDidDismissPopover(_ presentedViewController: AnyObject) {
        controllerDidDismissMethodInvoked = true
    }
}
