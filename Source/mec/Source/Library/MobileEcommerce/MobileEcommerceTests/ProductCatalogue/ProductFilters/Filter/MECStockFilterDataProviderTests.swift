/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECStockFilterDataProviderTests: XCTestCase {

    var sut: MECStockFilterDataProvider!

    override func setUp(){
        super.setUp()
        let filter = ECSPILProductFilter()
        filter.stockLevels = []
        sut = MECStockFilterDataProvider(appliedFilter: filter)
    }

    func testinitMethod() {
        let filter = ECSPILProductFilter()
        sut = MECStockFilterDataProvider(appliedFilter: filter)
        
        XCTAssertEqual(filter, sut?.appliedFilter)
    }
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECStockFilterCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testViewForHeaderInSection() {
        let view = sut.tableView(UITableView(), viewForHeaderInSection: 0) as? UIDHeaderView
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.headerLabel.text, MECLocalizedString("mec_filter_title"))
    }
    
    func testHeightForHeaderInSection() {
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testnumberOfRowsInSectionDeliveryAddressNil() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 3)
    }
    
    func testCellForRowAt() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECStockFilterCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.filterSelectionCheckbox.title, "In stock")
    }
    
    func testCellForRowAtOutOfBound() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        XCTAssertNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 10, section: 0)) as? MECStockFilterCell)
    }
    
    func testdidClickOnStock() {
        let tableView = MockTableView()
        tableView.indextPath = IndexPath(row: 0, section: 0)
        sut.registerCell(for: tableView)
        sut.tableView = tableView
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as!MECStockFilterCell
        cell.delegate?.didClickOnStock(tableCell: cell, selected: true)
        XCTAssertTrue(sut.appliedFilter.stockLevels?.contains(.inStock) ?? false)
        
        cell.delegate?.didClickOnStock(tableCell: cell, selected: false)
        XCTAssertFalse(sut.appliedFilter.stockLevels?.contains(.inStock) ?? false)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
