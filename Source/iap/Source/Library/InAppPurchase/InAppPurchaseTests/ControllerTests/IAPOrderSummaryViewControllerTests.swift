/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsUIKitDLS
@testable import InAppPurchaseDev

class IAPOrderSummaryViewControllerTests: XCTestCase {
    let navController = IAPTestNavigationController()
    var iapOrderSummaryVC: IAPOrderSummaryViewController!
    var cartInfoTest: IAPCartInfo! = IAPCartInfo()
    var productListTest: [IAPProductModel] = [IAPProductModel]()
    var paymentDetailsTest: IAPPaymentInfo!
    var shoppingTableViewTest: UITableView!
    var addressList: [IAPUserAddress] = []
    
    var cartSyncHelperTest = IAPCartSyncHelper()
    var sender:UIDButton!
    
    override func setUp() {
        super.setUp()
        let dict = self.deserializeData("IAPOCCCartInfoSampleResponse")
        cartInfoTest = IAPCartInfo(inDict: dict! as NSDictionary)

        let vc = IAPOrderSummaryViewController.instantiateFromAppStoryboard(appStoryboard: .order)
        vc.loadView()
        shoppingTableViewTest = vc.shoppingTableView
        iapOrderSummaryVC = vc
        
        iapOrderSummaryVC.cartInfo = cartInfoTest
        navController.pushViewController(iapOrderSummaryVC, animated: false)
        iapOrderSummaryVC.viewDidLoad()
        iapOrderSummaryVC.viewWillAppear(false)
        iapOrderSummaryVC.didReceiveMemoryWarning()
        let addressDict = self.deserializeData("IAPOCCGetAddress")
        XCTAssertNotNil(addressDict, "JSON has not been deserialsed")
        let userAddresses = IAPUserAddressInfo(inDict: addressDict!)
        addressList = userAddresses.address
        
        sender = UIDButton(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
    }
    
    func testCancelButtonClicked() {
        iapOrderSummaryVC.cancelButtonClicked(sender)
        // tbd
    }
    
    func testPayNowButtonClicked() {
        iapOrderSummaryVC.payNowButtonClicked(sender)
        // tbd
        
        iapOrderSummaryVC.paymentOrderId = "ZZ010"
        iapOrderSummaryVC.billingAddress = getAddressToDisplay()
        iapOrderSummaryVC.payNowButtonClicked(sender)
        // tbd
        
        iapOrderSummaryVC.isFromWorldPay = true
        iapOrderSummaryVC.payNowButtonClicked(sender)
        // tbd
        
        let paymentDict = self.deserializeData("IAPPaymentDetailsInfo")
        XCTAssertNotNil(paymentDict, "JSON has not been deserialsed")
        let paymentDetails = IAPPaymentDetailsInfo(inDict: paymentDict!)
        paymentDetailsTest = paymentDetails.arrayOfPaymentDetails.first
        iapOrderSummaryVC.paymentDetails = paymentDetailsTest
        iapOrderSummaryVC.isCVVToBeAsked = true
        iapOrderSummaryVC.payNowButtonClicked(sender)
        // tbd
    }
    
    func testTappedOutsideCVVView() {
        iapOrderSummaryVC.tappedOutsideCVVView(sender)
        XCTAssertTrue(iapOrderSummaryVC.cvvContainerView.isHidden == true, "Container view is not hidden")
    }
    
    func testProceedToPayment() {
        iapOrderSummaryVC.cvvTextField.text = ""
        iapOrderSummaryVC.proceedToPayment()
        XCTAssertNotNil(iapOrderSummaryVC.cvvUsed, "CVV used is nil")
        
        iapOrderSummaryVC.cvvTextField.text = "999"
        iapOrderSummaryVC.proceedToPayment()
        XCTAssertNotNil(iapOrderSummaryVC.cvvUsed, "CVV used is not nil")
    }
    
    func testTextField() {
        iapOrderSummaryVC.cvvTextField.text = "999"
        iapOrderSummaryVC.textField(iapOrderSummaryVC.cvvTextField, shouldChangeCharactersIn: NSMakeRange(0, (iapOrderSummaryVC.cvvTextField.text?.length)!), replacementString: "100")
        XCTAssertTrue((iapOrderSummaryVC.cvvTextField.text?.length)! == 3, "CVV used is not nil")
    }
    
    func testNavigateToOrderSummaryScreen() {
        iapOrderSummaryVC.navigateToOrderSummaryScreen(true, orderId: "ZZ101")
        XCTAssertNil(iapOrderSummaryVC.navigationItem.leftBarButtonItem, "CVV used is not nil")
    }

    func testTableViewDataSource() {
        XCTAssertNotNil(iapOrderSummaryVC.shoppingTableView.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(iapOrderSummaryVC.shoppingTableView?.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfSections() {
        var expectedSections = 0
        var actualSections = iapOrderSummaryVC.numberOfSections(in: shoppingTableViewTest)
        XCTAssertTrue(actualSections == expectedSections, "actual rows should be \(expectedSections)")
        
        iapOrderSummaryVC.productList = returnProductList(count: 2)
        expectedSections = 8
        actualSections = iapOrderSummaryVC.numberOfSections(in: shoppingTableViewTest)
        XCTAssertTrue(actualSections == expectedSections, "actual rows should be \(expectedSections)")
    }
    
    func testTableViewNumberOfRowsInSection() {
        var expectedRows = 0
        var actualRows = iapOrderSummaryVC.tableView(shoppingTableViewTest, numberOfRowsInSection: 0)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be \(expectedRows)")
        
        productListTest = returnProductList(count: 1)
        expectedRows = productListTest.count
        actualRows = self.iapOrderSummaryVC.tableView(shoppingTableViewTest, numberOfRowsInSection: 1)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be \(expectedRows)")
    }

    func testViewForHeaderInSection() {
        iapOrderSummaryVC.productList = returnProductList(count: 1)
        var testView = iapOrderSummaryVC.tableView(shoppingTableViewTest, viewForHeaderInSection: 0)
        XCTAssertNotNil(testView, "View returned was not nil")
        
        iapOrderSummaryVC.productList = returnProductList(count: 2)
        testView = iapOrderSummaryVC.tableView(shoppingTableViewTest, viewForHeaderInSection: 0)
        XCTAssertNotNil(testView, "View returned was not nil")
        
        testView = iapOrderSummaryVC.tableView(shoppingTableViewTest, viewForHeaderInSection: 1)
        XCTAssertNotNil(testView, "View returned was not nil")
        
        testView = iapOrderSummaryVC.tableView(shoppingTableViewTest, viewForHeaderInSection: 2)
        XCTAssertNotNil(testView, "View returned was not nil")
        
        testView = iapOrderSummaryVC.tableView(shoppingTableViewTest, viewForHeaderInSection: 3)
        XCTAssertNotNil(testView, "View returned was not nil")
    }
    
    func testHeightForHeaderInSection() {
        var height = iapOrderSummaryVC.tableView(shoppingTableViewTest, heightForHeaderInSection: 1)
        XCTAssert(height == 48, "Height returned from the last section is correct")
        
        height = iapOrderSummaryVC.tableView(shoppingTableViewTest, heightForHeaderInSection: 2)
        XCTAssert(height == 0, "Height returned from the last section is correct")
    }
    
    func testCellForRowAtIndexPath() {
        var indexPath = IndexPath(row: 0, section: 0)
        iapOrderSummaryVC.productList = returnProductList(count: 2)
        iapOrderSummaryVC.shippingAddress = getAddressToDisplay()
        iapOrderSummaryVC.billingAddress = getAddressToDisplay()
        var cell = iapOrderSummaryVC.tableView(shoppingTableViewTest, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.productCell, "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 0, section: 1)
        cell = iapOrderSummaryVC.tableView(shoppingTableViewTest, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == "AddressCell", "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 0, section: 2)
        cell = iapOrderSummaryVC.tableView(shoppingTableViewTest, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == "shippingCostCell", "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 0, section: 3)
        cell = iapOrderSummaryVC.tableView(shoppingTableViewTest, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.summaryCustomCell, "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 0, section: 7)
        cell = iapOrderSummaryVC.tableView(shoppingTableViewTest, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.purchaseHistoryPriceCell, "Table view does not create reusable cells")
    }
    
    func testDidSelectRowAtIndexPath() {
        let productDetailViewController = IAPShoppingCartDetailsViewController.instantiateFromAppStoryboard(appStoryboard: .shoppingCart)
        navController.pushViewController(productDetailViewController, animated: false)
        let indexPath = IndexPath(row: 0, section: 0)
        iapOrderSummaryVC.productList = returnProductList(count: 2)
        iapOrderSummaryVC.tableView(shoppingTableViewTest, didSelectRowAt: indexPath)
        XCTAssert(navController.pushedViewController is IAPShoppingCartDetailsViewController, "IAPShoppingCartDetailsViewController is not pushed in navigation stack")
    }

    
    func testTableWillDisplayCells() {
        let indexPath = IndexPath(row: 0, section: 1)
        iapOrderSummaryVC.productList = returnProductList(count: 2)
        iapOrderSummaryVC.shippingAddress = getAddressToDisplay()
        iapOrderSummaryVC.billingAddress = getAddressToDisplay()
        let cell = iapOrderSummaryVC.tableView(shoppingTableViewTest, cellForRowAt: indexPath)
        iapOrderSummaryVC.tableView(shoppingTableViewTest, willDisplay: cell, forRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == "AddressCell", "Table view does not create reusable cells")
    }
    
    func returnProductList(count: Int) -> [IAPProductModel] {
        let dictionary   = self.deserializeData("IAPProductSampleResponse")
        let productsInfo = IAPProductModelCollection(inDict: dictionary!)
        let productList: [IAPProductModel]
        if count == 1 {
            productList = [productsInfo.getProducts().first!]
        } else {
            productList = productsInfo.getProducts()
        }
        return productList
    }
    
    func getAddressToDisplay() -> IAPUserAddress {
        let addressDict = self.deserializeData("IAPOCCGetAddress")
        XCTAssertNotNil(addressDict, "JSON has not been deserialsed")
        let userAddresses = IAPUserAddressInfo(inDict: addressDict!)
        return userAddresses.address.first!
    }
    
    func testPushToWorldpayScreen() {
        let paymentInfoDict = self.deserializeData("IAPOCCMakePayment")
        XCTAssertNotNil(paymentInfoDict, "JSON has not been deserialsed")
        let makePaymentInfo:IAPMakePaymentInfo = IAPMakePaymentInfo(inDict: paymentInfoDict!)
        XCTAssertNotNil(makePaymentInfo, "payment info object is nil")
        
        iapOrderSummaryVC.pushToWorldpayScreen("12345", paymentInfo: makePaymentInfo)
        XCTAssert(navController.pushedViewController is IAPWorldPayViewController, "IAPWorldPayViewController is not pushed in navigation stack")
    }
    
    func testPushToConfirmationScreen() {
        iapOrderSummaryVC.pushConfirmationScreen("12345")
        XCTAssert(navController.pushedViewController is IAPPaymentConfirmationViewController,
                  "IAPPaymentConfirmationViewController is not pushed in navigation stack")
    }
}
