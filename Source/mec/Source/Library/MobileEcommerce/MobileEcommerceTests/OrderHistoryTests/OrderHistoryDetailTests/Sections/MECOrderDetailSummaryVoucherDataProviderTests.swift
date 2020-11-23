/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECOrderDetailSummaryVoucherDataProviderTests: XCTestCase {

    var sut: MECOrderDetailSummaryVoucherDataProvider!
    override func setUp() {
        super.setUp()
        sut = MECOrderDetailSummaryVoucherDataProvider(with: ECSOrderDetail())
    }

    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testnumberOfRowsInSectionZeroVoucher() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testnumberOfRowsInSection() {
        let orderDetail = ECSOrderDetail()
        let voucher = ECSVoucher()
        voucher.name = "test voucher"
        voucher.appliedValue = ECSPrice()
        voucher.appliedValue?.formattedValue = "10 $"
        orderDetail.appliedVouchers = [voucher, voucher]
        sut = MECOrderDetailSummaryVoucherDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
    }
    
    func testcellForRowAtWithoutVoucher() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECSummaryCell)
    }
    
    func testcellForRowAtWithVoucher() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let orderDetail = ECSOrderDetail()
        let voucher = ECSVoucher()
        voucher.name = "test voucher"
        voucher.appliedValue = ECSPrice()
        voucher.appliedValue?.formattedValue = "10 $"
        orderDetail.appliedVouchers = [voucher, voucher]
        sut = MECOrderDetailSummaryVoucherDataProvider(with: orderDetail)
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECSummaryCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.primaryLabel.text, "test voucher")
        XCTAssertEqual(cell?.secondaryLabel.text, " - 10 $")
        
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

}
