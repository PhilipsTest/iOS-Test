/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */



import XCTest
@testable import MobileEcommerceDev
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECDeliveryCostDataProviderTests: XCTestCase {
    
    var sut: MECDeliveryCostDataProvider!
    var dataBus:MECDataBus!
    
    override func setUp() {
        super.setUp()
        dataBus = MECDataBus()
        sut = MECDeliveryCostDataProvider(cartDataBus: dataBus)
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
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECApplyVoucherCell))
    }
    
    func testViewForHeader() {
        XCTAssertNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testNumberOfRows() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }
    
    func testCellForRowDeliveryCost() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let price = ECSPILPrice()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        let pricing = ECSPILPricing()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.pricing = pricing
        price.formattedValue = "10$"
        cart.data?.attributes?.pricing?.delivery = price
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECSummaryCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.secondaryLabel.text, "10$")
    }
    
    func testCellForRowForDeliveryCostNil() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 3, section: 0)) as? MECAppliedVoucherCell
        XCTAssertNil(cell)
    }
}
