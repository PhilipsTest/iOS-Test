/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import InAppPurchaseDev

class IAPQuantityTableViewControllerTests: XCTestCase {

    var quantityPopOver : IAPQuantityTableViewController?
    
    override func setUp() {

        quantityPopOver = IAPQuantityTableViewController() as IAPQuantityTableViewController
    }
    
    func testConformsToDatasource() {
        XCTAssertTrue((quantityPopOver?.conforms(to: UITableViewDataSource.self))!, "tableview does not conform to UITableViewDataSource")
    }
    
    func testConformsToDelegate() {
        XCTAssertTrue((quantityPopOver?.conforms(to: UITableViewDelegate.self))!, "tableview does not conform to UITableViewDelegate")
    }
    
    func testTableViewDataSource() {
        XCTAssertNotNil(quantityPopOver!.tableView.dataSource, "tableview datasource can't be nil")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(quantityPopOver!.tableView.delegate, "tableview delegate can't be nil")
    }
    
    func testTableViewNumberOfRowsInSection() {
        let expectedRows = 5
        quantityPopOver!.totalQuantity = 5
        
        let actualRows = quantityPopOver!.tableView(quantityPopOver!.tableView, numberOfRowsInSection: 0)
        XCTAssertTrue(actualRows == expectedRows, "actual rows should be 5")
    }
    
    func testTableViewCellCreateCellsWithReuseIdentifier() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = quantityPopOver?.tableView((quantityPopOver?.tableView)!, cellForRowAt: indexPath)
        XCTAssertTrue(cell?.reuseIdentifier == IAPCellIdentifier.tableCell, "Table view does not create reusable cells")
    }
    
    func testTableViewHeightForHeaderInSection() {
        let expectedHeight : CGFloat = 0
        let actualHeight = quantityPopOver!.tableView(quantityPopOver!.tableView, heightForHeaderInSection: 0)
        XCTAssertTrue(actualHeight == expectedHeight, "header height should be zero")
    }
    
    func testSetTotalQuantity() {
        let quantityTotal = 5
        quantityPopOver!.setProductTotalQuantity(quantityTotal)
        XCTAssertTrue(quantityPopOver!.totalQuantity == quantityTotal, "total quantity should be set to 5")
    }
    
    func testPopOverViewHeight() {
        quantityPopOver!.totalQuantity = 10
        var expectedHeight : CGFloat = 250
        var actualPopOverHeight = quantityPopOver!.popOverViewHeight
        XCTAssertTrue(actualPopOverHeight == expectedHeight, "pop over height should be 250")
        
        quantityPopOver!.totalQuantity = 5
        expectedHeight = 200
        actualPopOverHeight = quantityPopOver!.popOverViewHeight
        XCTAssertTrue(actualPopOverHeight == expectedHeight, "pop over height should be 200")
    }
    
    func testTableViewDidSelectRow() {
     
        let indexPath = IndexPath(row: 0, section: 0)
        let quantityDelegate = IAPTestQuantityTableView()
        quantityPopOver!.delegate = quantityDelegate
        quantityPopOver!.selectedProductIndexPath = indexPath
        quantityPopOver!.tableView(quantityPopOver!.tableView, didSelectRowAt: indexPath)
        XCTAssert(quantityDelegate.didSelectMethodInvoked == true, "Did select method is not selected")
    }
}

class IAPTestQuantityTableView:IAPUpdateQuantityTableDelegate {
    var didSelectMethodInvoked = false
    
    func controllerDidSelectQuantity(_ quantity: NSInteger, selectedProductIndexPath: IndexPath, tableViewController: UITableViewController) {
        didSelectMethodInvoked = true
    }
}


