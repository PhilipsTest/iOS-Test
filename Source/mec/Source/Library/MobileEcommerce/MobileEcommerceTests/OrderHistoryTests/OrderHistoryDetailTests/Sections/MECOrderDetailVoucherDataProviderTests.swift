/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECOrderDetailVoucherDataProviderTests: XCTestCase {

    var sut: MECOrderDetailVoucherDataProvider!
    override func setUp() {
        super.setUp()
        sut = MECOrderDetailVoucherDataProvider(with: ECSOrderDetail())
    }

    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutVoucherCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }

    func testnumberOfRowsInSectionWithoutVoucher() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testnumberOfRowsInSectionWithVoucher() {
        let orderDetail = ECSOrderDetail()
        let voucher = ECSVoucher()
        voucher.name = "test voucher"
        voucher.appliedValue = ECSPrice()
        voucher.appliedValue?.formattedValue = "10 $"
        orderDetail.appliedVouchers = [voucher, voucher]
        sut = MECOrderDetailVoucherDataProvider(with: orderDetail)
        
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
    }
    
    func testheightForHeaderInSection() {

        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 0)
        
        let orderDetail = ECSOrderDetail()
        let voucher = ECSVoucher()
        voucher.name = "test voucher"
        voucher.appliedValue = ECSPrice()
        voucher.appliedValue?.formattedValue = "10 $"
        orderDetail.appliedVouchers = [voucher, voucher]
        sut = MECOrderDetailVoucherDataProvider(with: orderDetail)
        
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40.0)
    }
    
    func testviewForHeaderInSection() {
        
        XCTAssertNil(sut.tableView(UITableView(), viewForHeaderInSection: 0) as? UIDHeaderView)
        
        let orderDetail = ECSOrderDetail()
        let voucher = ECSVoucher()
        voucher.name = "test voucher"
        voucher.voucherCode = "abcd"
        voucher.appliedValue = ECSPrice()
        voucher.appliedValue?.formattedValue = "10 $"
        orderDetail.appliedVouchers = [voucher, voucher]
        sut = MECOrderDetailVoucherDataProvider(with: orderDetail)
        
        let view = sut.tableView(UITableView(), viewForHeaderInSection: 0) as? UIDHeaderView
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.headerLabel.text, MECLocalizedString("mec_accepted_codes"))
    }
    
    func testcellForRowAt() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        XCTAssertNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutVoucherCell)
        
        let orderDetail = ECSOrderDetail()
        let voucher = ECSVoucher()
        voucher.name = "test voucher"
        voucher.voucherCode = "abcd"
        voucher.appliedValue = ECSPrice()
        voucher.appliedValue?.formattedValue = "10 $"
        orderDetail.appliedVouchers = [voucher, voucher]
        sut = MECOrderDetailVoucherDataProvider(with: orderDetail)
        
        XCTAssertNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 3, section: 0)) as? MECCheckoutVoucherCell)
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? MECCheckoutVoucherCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.giftCodeLabel.text, "abcd")
        XCTAssertEqual(cell?.discountValueLabel.text, "10 $")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
