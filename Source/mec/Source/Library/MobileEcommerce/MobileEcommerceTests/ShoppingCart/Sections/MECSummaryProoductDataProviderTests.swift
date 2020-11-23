/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECSummaryProoductDataProviderTests: XCTestCase {
    
    var sut: MECSummaryProoductDataProvider!
    var dataBus:MECDataBus!
    
    override func setUp() {
        super.setUp()
        dataBus = MECDataBus()
        sut = MECSummaryProoductDataProvider(cartDataBus: dataBus)
    }
    
    override func tearDown() {
        dataBus = nil
        sut = nil
        
        super.tearDown()
    }
    
    func testinitCheck() {
        XCTAssertNotNil(sut.dataBus)
    }
    
    func testHeightForHeader() {
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testViewForHeader() {
        let view = sut.tableView(UITableView(), viewForHeaderInSection: 0) as? UIDHeaderView
        XCTAssertNotNil(view)
        XCTAssertEqual(view!.headerLabel.text, MECLocalizedString("mec_cart_summary"))
    }
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testNumberOfRowsVoucherNil() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testNumberOfRowsVoucher() {
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [getEntry(), getEntry()]
        dataBus.shoppingCart = cart
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
    }
    
    func testCellForRowForSummary() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [getEntry(), getEntry()]
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECSummaryCell
        XCTAssertNotNil(cell)
    }
    
    func testCellForRowForSummaryOutOfBound() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [getEntry(), getEntry()]
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? MECSummaryCell
        XCTAssertNil(cell)
    }
    
    func getEntry() -> ECSPILItem {
        let entry = ECSPILItem()
        return entry
    }
    
}
