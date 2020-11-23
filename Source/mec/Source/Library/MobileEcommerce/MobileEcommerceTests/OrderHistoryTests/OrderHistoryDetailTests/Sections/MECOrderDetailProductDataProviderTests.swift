/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS
import PhilipsPRXClient

class MECOrderDetailProductDataProviderTests: XCTestCase {

    var sut: MECOrderDetailProductDataProvider!
    
    override func setUp() {
        super.setUp()
        sut = MECOrderDetailProductDataProvider(with: ECSOrderDetail())
    }

    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECOrderDetailProductCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testNumberOfRowsInSectionEntriesNil() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testNumberOfRowsInSectionWithEntries() {
        
        let orderDetail = ECSOrderDetail()
        orderDetail.entries = [ECSEntry(), ECSEntry(), ECSEntry()]
        sut = MECOrderDetailProductDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 3)
    }
    
    func testheightForHeaderInSection() {
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40.0)
    }
    
    func testViewForHeaderInSection() {
        let view = sut.tableView(UITableView(), viewForHeaderInSection: 0) as? UIDHeaderView
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.headerLabel.text, MECLocalizedString("mec_order_summary"))
    }
    
    func testcellForRowAt() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)

        XCTAssertNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECOrderDetailProductCell)
        
        let orderDetail = ECSOrderDetail()
        orderDetail.entries = []
        sut = MECOrderDetailProductDataProvider(with: orderDetail)
        XCTAssertNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECOrderDetailProductCell)
    }
    
    func testcellForRowAtWithEntrie() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)

        let orderDetail = ECSOrderDetail()
        orderDetail.entries = [getEntry(), getEntry()]
        sut = MECOrderDetailProductDataProvider(with: orderDetail)
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECOrderDetailProductCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.productNameLabel.text, "Test product")
        XCTAssertEqual(cell?.productQuantityLabel.text, "Quantity: 2")
        XCTAssertEqual(cell?.productPriceLabel.text, "10 $")
        XCTAssertEqual(cell?.trackOrderButton.isEnabled, false)
    }
    
    func testcellForRowAtWithEntrieWithTrackingInfo() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)

        let orderDetail = ECSOrderDetail()
        let consignment = ECSConsignment()
        let entry = ECSConsignmentEntry()
        entry.trackAndTraceUrls = ["www.test.com"]
        consignment.entries = [entry]
        orderDetail.consignments = [consignment]
        
        orderDetail.entries = [getEntry(), getEntry()]
        sut = MECOrderDetailProductDataProvider(with: orderDetail)
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECOrderDetailProductCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.productNameLabel.text, "Test product")
        XCTAssertEqual(cell?.productQuantityLabel.text, "Quantity: 2")
        XCTAssertEqual(cell?.productPriceLabel.text, "10 $")
        XCTAssertEqual(cell?.trackOrderButton.isEnabled, true)
    }
    
    func getEntry() -> ECSEntry {
        let entry = ECSEntry()
        let product = ECSProduct()
        product.productPRXSummary = PRXSummaryData()
        product.productPRXSummary?.productTitle = "Test product"
        entry.quantity = 2
        entry.product = product
        entry.totalPrice = ECSPrice()
        entry.totalPrice?.formattedValue = "10 $"
        return entry
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
