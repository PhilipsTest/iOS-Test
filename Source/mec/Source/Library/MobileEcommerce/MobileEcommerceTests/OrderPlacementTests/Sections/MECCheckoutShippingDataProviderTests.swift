/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK

class MECCheckoutShippingDataProviderTests: XCTestCase {
    var sut: MECCheckoutShippingDataProvider!
    var dataBus:MECDataBus!
    let appinfra = MockAppInfra()
    
    override func setUp() {
        super.setUp()
        MECConfiguration.shared.sharedAppInfra = appinfra
        dataBus = MECDataBus()
        sut = MECCheckoutShippingDataProvider(with: dataBus)
    }
    
    override func tearDown() {
        dataBus = nil
        sut = nil
        MECConfiguration.shared.sharedAppInfra = nil
        
        super.tearDown()
    }
    
    func testinitCheck() {
        XCTAssertNotNil(sut.dataBus)
    }
    
    func testHeightForHeaderVoucherEnabled() {
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testViewForHeader() {
        XCTAssertNotNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutDeliveryModeCell))
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutShippingCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testNumberOfRows() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
    }
    
    func testCellForRowAt() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        
        dataBus.shoppingCart = cart
        
        XCTAssertNotNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutShippingCell)
        XCTAssertNotNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? MECCheckoutDeliveryModeCell)
        XCTAssertNotNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 2, section: 0)))
    }
}
