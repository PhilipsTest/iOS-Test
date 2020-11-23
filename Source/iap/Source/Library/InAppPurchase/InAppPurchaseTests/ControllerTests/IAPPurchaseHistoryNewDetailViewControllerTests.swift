/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPPurchaseHistoryNewDetailViewControllerTests: XCTestCase {
    var orderDetail: IAPPurchaseHistoryModel!
    var consumerCareInfo: IAPPRXConsumerModel!
    var purchaseHistoryNewDetailVC: IAPPurchaseHistoryNewDetailViewController!
    var orderDetailTableView: UITableView!
    
    override func setUp() {
        super.setUp()
        let orderDict = self.deserializeData("IAPGetOrdersResponse")
        
        if let orderList = orderDict!["orders"] as? [[String: AnyObject]] {
            let order = orderList[0]
            self.orderDetail = IAPPurchaseHistoryModel(inDictionary: order)
            let orderDetailDict = self.deserializeData("IAPGetOrderDetailResponse")
            self.orderDetail.initialiseOrderDetails(orderDetailDict!)
            let consumerDict = self.deserializeData("IAPPRXConsumerResponse")
            self.consumerCareInfo = IAPPRXConsumerModel(inDict: consumerDict!)
        } else {
            assertionFailure("order list creation failed")
        }
        let purchaseHistoryNewDetailController = IAPPurchaseHistoryNewDetailViewController.instantiateFromAppStoryboard(appStoryboard: .purchaseHistory)
        purchaseHistoryNewDetailController.loadView()
        self.orderDetailTableView = purchaseHistoryNewDetailController.orderDetailTableView
        self.purchaseHistoryNewDetailVC = purchaseHistoryNewDetailController
        self.purchaseHistoryNewDetailVC.orderDetail = self.orderDetail
        self.purchaseHistoryNewDetailVC.consumerCareInfo = self.consumerCareInfo
        self.purchaseHistoryNewDetailVC.viewDidLoad()
        self.purchaseHistoryNewDetailVC.viewWillAppear(false)
        self.purchaseHistoryNewDetailVC.orderDetailTableView = self.orderDetailTableView
        
    }
    
    func testTableViewDataSource() {
        XCTAssertNotNil(self.purchaseHistoryNewDetailVC.orderDetailTableView.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(self.purchaseHistoryNewDetailVC.orderDetailTableView?.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfSections() {
        let expectedSections = IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kTotalSection + 1
        let actualSections = self.purchaseHistoryNewDetailVC.numberOfSections(in: self.orderDetailTableView)
        XCTAssertTrue(actualSections == expectedSections, "actual rows should be \(expectedSections)")
    }
    
    func testTableViewNumberOfRowsInSection() {
        var expectedRows = 2
        var actualRows = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, numberOfRowsInSection: 0)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be \(expectedRows)")
        
        expectedRows = self.orderDetail.products.count
        actualRows = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, numberOfRowsInSection: 1)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be \(expectedRows)")
        
        expectedRows = 3
        actualRows = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, numberOfRowsInSection: 2)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be \(expectedRows)")
        
        expectedRows = self.orderDetail.products.count
        actualRows = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, numberOfRowsInSection: 3)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be \(expectedRows)")
        
        expectedRows = 1
        actualRows = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, numberOfRowsInSection: 4)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be \(expectedRows)")
    }
    
    func testCellForRowAtIndexPath(){
        var indexPath = IndexPath(row: 0, section: 0)
        var cell = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == "orderNumberCell", "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 1, section: 0)
        cell = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == "IAPPurchaseHistoryDetailCustomerCareCell", "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 0, section: 1)
        cell = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == "orderProductCell", "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 0, section: 2)
        cell = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.addressCell, "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 1, section: 2)
        cell = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.addressCell, "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 2, section: 2)
        cell = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.summaryPaidCell, "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 0, section: 3)
        cell = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.summaryCustomCell, "Table view does not create reusable cells")
        
        indexPath = IndexPath(row: 0, section: 4)
        cell = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, cellForRowAt: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.purchaseHistoryPriceCell, "Table view does not create reusable cells")

    }
    
    func testHeightForRow() {
        var indexPath: IndexPath
        var height: CGFloat
        for index in 0...4 {
            if index == 0 {
                for innerIndex in 0...1 {
                    indexPath = IndexPath(row: innerIndex, section: index)
                    height = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, heightForRowAt: indexPath)
                    XCTAssert(height == UITableView.automaticDimension, "Height returned was not correct")
                }
            } else if index == 1 {
                for (index, _) in self.orderDetail.products.enumerated() {
                    indexPath = IndexPath(row: index, section: index)
                    height = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, heightForRowAt: indexPath)
                    XCTAssert(height == UITableView.automaticDimension, "Height returned was not correct")
                }
            } else if index == 2 {
                for innerIndex in 0...2 {
                    if innerIndex == 2 {
                        if (self.orderDetail.getCardNumber() == "") {
                            indexPath = IndexPath(row: innerIndex, section: index)
                            height = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, heightForRowAt: indexPath)
                            XCTAssert(height == 0, "Height returned was not correct")
                        } else {
                            indexPath = IndexPath(row: innerIndex, section: index)
                            height = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, heightForRowAt: indexPath)
                            XCTAssert(height == UITableView.automaticDimension, "Height returned was not correct")
                        }
                    }
                }
            } else if index == 3 {
                for (index, _) in self.orderDetail.products.enumerated() {
                    indexPath = IndexPath(row: index, section: index)
                    height = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, heightForRowAt: indexPath)
                    XCTAssert(height == UITableView.automaticDimension, "Height returned was not correct")
                }
            } else if index == 4 {
                indexPath = IndexPath(row: 0, section: index)
                height = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, heightForRowAt: indexPath)
                XCTAssert(height == UITableView.automaticDimension, "Height returned was not correct")
            }
        }
    }
    
    func testViewForHeaderInSection () {
        var testView = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, viewForHeaderInSection: IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kPurchaseHistoryConsumerSection)
        XCTAssertNotNil(testView, "View returned was not nil")
        
        testView = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, viewForHeaderInSection: IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kProductsSection)
        var productType: String = "Products"
        if self.orderDetail.getItemsCount() > 1 {
            XCTAssertTrue(productType == "Products", "Number of products is more than 1")
        } else {
            productType = "Product"
            XCTAssertTrue(productType == "Product", "Number of product is eqaul to 1")
        }
        XCTAssertNotNil(testView, "View returned was not nil")
        
        testView = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, viewForHeaderInSection: IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kYourDetailsSection)
        XCTAssertNotNil(testView, "View returned was not nil")
        
        testView = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, viewForHeaderInSection: IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kSummarySection)
        XCTAssertNotNil(testView, "View returned was not nil")
        
        testView = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, viewForHeaderInSection: IAPConstants.IAPPurchaseHistoryOrderDetailsSection.kTotalSection)
        XCTAssertNotNil(testView, "View returned was not nil")
    }
    
    func testHeightForHeaderInSection() {
        let sectionCount = [0, 1, 2, 3, 4]
        var height:CGFloat
        for (_, element) in sectionCount.enumerated() {
            if (element == 4) {
                height = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, heightForHeaderInSection: element)
                XCTAssert(height == 0, "Height returned from the last section is correct")
            } else {
                height = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView, heightForHeaderInSection: element)
                XCTAssert(height == IAPConstants.IAPPaymentSelectionDecoratorConstants.kHeaderHeightConstant, "Height returned from sections other than the last one is correct")
            }
        }
    }
    
    func testCancelButtonClicked() {
        let cancelOrderVC = IAPCancelOrderViewController.instantiateFromAppStoryboard(appStoryboard: .purchaseHistory)
        let navController = IAPTestNavigationController()
        navController.pushViewController(cancelOrderVC, animated: false)
        let indexPath = IndexPath(row: 0, section: 4)
        if let cell = self.purchaseHistoryNewDetailVC.tableView(self.orderDetailTableView,
                                                                cellForRowAt: indexPath) as? IAPPurchaseHistoryOrderDetailsPriceSummaryCell {
            self.purchaseHistoryNewDetailVC.userSelectedcancelButton(cell)
            XCTAssert(navController.pushedViewController is IAPCancelOrderViewController,
                      "IAPCancelOrderViewController is not pushed in navigation stack")
        } else {
            assertionFailure("cell failed")
        }
    }
}
