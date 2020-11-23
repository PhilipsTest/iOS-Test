/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK

class MECSummaryVoucherDataProviderTests: XCTestCase {

    var sut: MECSummaryVoucherDataProvider!
    var dataBus:MECDataBus!
    
    override func setUp() {
        super.setUp()
        dataBus = MECDataBus()
        sut = MECSummaryVoucherDataProvider(cartDataBus: dataBus)
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
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 0)
    }
    
    func testViewForHeader() {
        XCTAssertNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
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
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
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
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECSummaryCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.primaryLabel.text, "testVoucher")
    }
    
    func testCellForRowForSummaryOutOfBound() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 3, section: 0)) as? MECSummaryCell
        XCTAssertNil(cell)
    }
    
    func getVoucher() -> ECSPILAppliedVoucher {
        let voucher = ECSPILAppliedVoucher()
        voucher.name = "testVoucher"
        let appliedPrice = ECSPILPrice()
        appliedPrice.formattedValue = "10$"
        let voucherDiscount = ECSPILPrice()
        voucherDiscount.formattedValue = "10$"
        voucher.voucherDiscount = voucherDiscount
        voucher.value = appliedPrice
        return voucher
    }
}
