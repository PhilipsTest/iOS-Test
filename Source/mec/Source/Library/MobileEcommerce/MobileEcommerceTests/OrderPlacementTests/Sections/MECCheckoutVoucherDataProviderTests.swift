/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK

class MECCheckoutVoucherDataProviderTests: XCTestCase {

    var sut: MECCheckoutVoucherDataProvider!
    var dataBus:MECDataBus!
    
    override func setUp() {
        super.setUp()
        dataBus = MECDataBus()
        sut = MECCheckoutVoucherDataProvider(with: dataBus)
    }

    override func tearDown() {
        dataBus = nil
        sut = nil
        
        super.tearDown()
    }
    
    func testinitCheck() {
        XCTAssertNotNil(sut.dataBus)
    }
    
    func testHeightForHeaderZeroVoucher() {
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 0)
    }
    
    func testHeightForHeader() {
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testViewForHeaderZeroVoucher() {
        XCTAssertNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testViewForHeader() {
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart
        XCTAssertNotNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutVoucherCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell))
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
    
    func testCellForRowForSummaryWithoutValue() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        let voucher = getVoucher()
        voucher.voucherDiscount?.formattedValue = nil
        cart.data?.attributes?.appliedVouchers = [voucher, getVoucher()]
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutVoucherCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.giftCodeLabel.text, "testVoucher")
        XCTAssertEqual(cell?.percentageDiscountLabel.text, "")
    }
    
    func testCellForRowForSummaryValue() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)

        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart

        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutVoucherCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.giftCodeLabel.text, "testVoucher")
        XCTAssertEqual(cell?.percentageDiscountLabel.text, "10 $ discount |")
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
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 3, section: 0)) as? MECCheckoutVoucherCell
        XCTAssertNil(cell)
    }
    
    func getVoucher() -> ECSPILAppliedVoucher {
        let voucher = ECSPILAppliedVoucher()
        voucher.voucherCode = "testVoucher"
        let appliedPrice = ECSPILPrice()
        appliedPrice.formattedValue = "10$"
        let voucherDiscount = ECSPILPrice()
        voucherDiscount.formattedValue = "10 $"
        voucher.voucherDiscount = voucherDiscount
        voucher.value = appliedPrice
        return voucher
    }
}
