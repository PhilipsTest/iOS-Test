/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPPurchaseHistoryViewControllerTests: XCTestCase {
    
    var purchaseHistoryVC: IAPPurchaseHistoryViewController!
    var orderTableView: UITableView!
    var filteredOrderCollection: [IAPPurcahseHistorySortedCollection]!
    
    override func setUp() {
        super.setUp()
        let orderDict = self.deserializeData("IAPGetOrdersResponse")
        filteredOrderCollection = IAPPurchaseHistoryCollection(inDictionary: orderDict!)?.categoriseWithDisplayDate()

        if let orderList = orderDict!["orders"] as? [[String: AnyObject]] {
            let order = orderList[0]
            let orderDetails = IAPPurchaseHistoryModel(inDictionary: order)
            let orderDetailDict = self.deserializeData("IAPGetOrderDetailResponse")
            orderDetails?.initialiseOrderDetails(orderDetailDict!)
            filteredOrderCollection.first?.collection[0] = orderDetails!
        } else {
            assertionFailure("order list creation failed")
        }

        let vc = IAPPurchaseHistoryViewController.instantiateFromAppStoryboard(appStoryboard: .purchaseHistory)
        vc.loadView()
        orderTableView = vc.orderTableView
        purchaseHistoryVC = vc
        purchaseHistoryVC.filteredOrderCollection = self.filteredOrderCollection
        purchaseHistoryVC.viewDidLoad()
        purchaseHistoryVC.viewWillAppear(false)
        purchaseHistoryVC.didTapTryAgain()
    }
    
    func testTableViewDataSource() {
        XCTAssertNotNil(self.purchaseHistoryVC.orderTableView.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(self.purchaseHistoryVC.orderTableView?.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfRowsInSection() {
        let expectedRows = 1
        let actualRows = self.purchaseHistoryVC.tableView(self.orderTableView, numberOfRowsInSection: 0)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be 1")
    }
    
    func testTableViewNumberOfSections() {
        let expectedSections = self.filteredOrderCollection.count
        let actualSections = self.purchaseHistoryVC.numberOfSections(in: self.orderTableView)
        XCTAssertTrue(actualSections == expectedSections, "actual sections should be \(expectedSections)")
    }
    
    func testCellForRowAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.purchaseHistoryVC.tableView(self.orderTableView, cellForRowAt: indexPath)

        XCTAssertTrue(cell.reuseIdentifier == IAPCellIdentifier.orderCell, "Table view does not create reusable cells")
        self.purchaseHistoryVC.tableView(self.orderTableView, willDisplay: cell, forRowAt: indexPath)        
    }
    
    func testViewForHeader() {
        let view = self.purchaseHistoryVC.tableView(self.orderTableView, viewForHeaderInSection: 0)
        XCTAssertNotNil(view, "Header View returned is nil")
    }
    
    func testTableViewRowSelection() {
        let navController = IAPTestNavigationController()
        navController.pushViewController(self.purchaseHistoryVC, animated: false)
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.purchaseHistoryVC.tableView(self.orderTableView, didSelectRowAt: indexPath)
        //XCTAssert(navController.pushedViewController is IAPPurchaseHistoryNewDetailViewController, "IAPPurchaseHistoryNewDetailViewController was not pushed")
    }
    
    func testUpdateUIForOrderHistory() {
        purchaseHistoryVC.updateUIForOrderHistory()
        XCTAssert(purchaseHistoryVC.noHistoryView.isHidden == true, "No history view is not hidden")
        XCTAssert(purchaseHistoryVC.orderTableView.isHidden == false, "Order history table view should be visible")
    }
    
    func testUpdateUIForEmptyOrderHistory() {
        purchaseHistoryVC.updateUIForEmptyOrderHistory()
        XCTAssert(purchaseHistoryVC.noHistoryView.isHidden == false, "No history view is not visible")
        XCTAssert(purchaseHistoryVC.orderTableView.isHidden == true, "Order history table view should not be visible")
    }
}
