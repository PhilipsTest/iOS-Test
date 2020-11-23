/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK

class MECCheckoutPaymentDataProviderTests: XCTestCase {

    var sut: MECCheckoutPaymentDataProvider!
    var dataBus:MECDataBus!
    
    override func setUp() {
        super.setUp()
        dataBus = MECDataBus()
        sut = MECCheckoutPaymentDataProvider(with: dataBus)
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
        XCTAssertNotNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutPaymentCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell))
    }
    
    func testNumberOfRows() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }
    
    func testCellForRowForSummaryWithoutSelectedPayment() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutPaymentCell
        XCTAssertNil(cell)
    }
    
    func testCellForRowForSummaryValue() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let paymentImfo = MECPaymentsInfo()
        let selected = ECSPayment()
        paymentImfo.selectedPayment = selected
        dataBus.paymentsInfo = paymentImfo
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutPaymentCell
        XCTAssertNotNil(cell)
    }
}
