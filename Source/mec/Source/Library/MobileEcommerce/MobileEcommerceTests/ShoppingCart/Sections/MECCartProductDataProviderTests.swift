/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECCartProductDataProviderTests: XCTestCase {
    
    var sut: MECCartProductDataProvider!
    var dataBus:MECDataBus!
    let appinfra = MockAppInfra()
    
    override func setUp() {
        super.setUp()
        MECConfiguration.shared.sharedAppInfra = appinfra
        dataBus = MECDataBus()
        sut = MECCartProductDataProvider(cartDataBus: dataBus)
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
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECShoppingCartProductCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testViewForHeader() {
        XCTAssertNotNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testNumberOfRowsWithoutProduct() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testNumberOfRowsWithProduct() {
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [getEntry(), getEntry()]
        dataBus.shoppingCart = cart
        
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
        XCTAssertNotEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 3)
    }
    
    func testCellForRowAtsVoucherEnabled() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.items = [getEntry(), getEntry()]
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECShoppingCartProductCell
        XCTAssertNotNil(cell)
    }
    
    func getEntry() -> ECSPILItem {
        let entry = ECSPILItem()
        return entry
    }
}
