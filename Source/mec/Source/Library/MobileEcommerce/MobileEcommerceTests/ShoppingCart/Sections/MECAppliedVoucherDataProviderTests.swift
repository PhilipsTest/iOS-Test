/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECAppliedVoucherDataProviderTests: XCTestCase {

    var sut: MECAppliedVoucherDataProvider!
    var dataBus:MECDataBus!
    
    override func setUp() {
        super.setUp()
        dataBus = MECDataBus()
        sut = MECAppliedVoucherDataProvider(cartDataBus: dataBus)
    }

    override func tearDown() {
        dataBus = nil
        sut = nil
        
        super.tearDown()
    }
    
    func testinitCheck() {
        XCTAssertNotNil(sut.dataBus)
    }
    
    func testHeightForHeaderNoVoucher() {
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 0)
    }
 
    func testHeightForHeaderForVoucher() {
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECAppliedVoucherCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECApplyVoucherCell))
    }
    
    func testViewForHeaderForVoucher() {
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart
        XCTAssertNotNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testViewForHeaderNoVoucher() {
        XCTAssertNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testNumberOfRowsForVoucher() {
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
    }
    
    func testNumberOfRowsNoVoucher() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testCellForRowForVoucher() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECAppliedVoucherCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.giftCodeLabel.text, "abcd")
        XCTAssertEqual(cell?.percentageDiscountLabel.text, "10$ discount |")
    }
    
    func testCellForRowForVoucherWithoutValue() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)

        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        let voucher = getVoucher()
        voucher.voucherDiscount?.formattedValue = "10 $"
        cart.data?.attributes?.appliedVouchers = [voucher, getVoucher()]
        dataBus.shoppingCart = cart

        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECAppliedVoucherCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.giftCodeLabel.text, "abcd")
        XCTAssertEqual(cell?.percentageDiscountLabel.text, "10 $ discount |")
    }
    
    func testCellForRowForVoucherOutOfBound() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.appliedVouchers = [getVoucher(), getVoucher()]
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 3, section: 0)) as? MECAppliedVoucherCell
        XCTAssertNil(cell)
    }
    
    func getVoucher() -> ECSPILAppliedVoucher {
        let voucher = ECSPILAppliedVoucher()
        voucher.name = "testVoucher"
        voucher.voucherCode = "abcd"
        let appliedPrice = ECSPILPrice()
        appliedPrice.formattedValue = "10$"
        let voucherDiscount = ECSPILPrice()
        voucherDiscount.formattedValue = "10$"
        voucher.voucherDiscount = voucherDiscount
        voucher.value = appliedPrice
        return voucher
    }
}
