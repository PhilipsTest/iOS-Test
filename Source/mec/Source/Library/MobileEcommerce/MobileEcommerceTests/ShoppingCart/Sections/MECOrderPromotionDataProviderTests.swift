/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

class MECOrderPromotionDataProviderTests: XCTestCase {

    var sut: MECOrderPromotionDataProvider!
    var dataBus:MECDataBus!
    let appinfra = MockAppInfra()
    
    override func setUp() {
        super.setUp()
        MECConfiguration.shared.sharedAppInfra = appinfra
        dataBus = MECDataBus()
        sut = MECOrderPromotionDataProvider(cartDataBus: dataBus)
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
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 0)
    }
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testViewForHeader() {
        XCTAssertNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testNumberOfRowsWithoutProduct() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testNumberOfRowsWithPromotion() {
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.promotions = getPromotion()
        dataBus.shoppingCart = cart
        
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
        XCTAssertNotEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 3)
    }
    
    func testheightForRowAt() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertEqual(sut.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0)), UITableView.automaticDimension)
    }
    
    func testCellForRowAt() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.promotions = getPromotion()
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECSummaryCell
        XCTAssertNotNil(cell)
    }
    
    func testCellForRowAtOutOfBound() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cart = ECSPILShoppingCart()
        let data = ECSPILDataClass()
        let attributes = ECSPILCartAttributes()
        data.attributes = attributes
        cart.data = data
        cart.data?.attributes?.promotions = getPromotion()
        dataBus.shoppingCart = cart
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 3, section: 0)) as? MECSummaryCell
        XCTAssertNil(cell)
    }
    
    func getPromotion() -> ECSPILShoppingCartPromotions {
        let promotion = ECSPILShoppingCartPromotions()
        let orderPromotion1 = ECSPILOrderPromotion()
        let orderPromotion2 = ECSPILOrderPromotion()
        promotion.appliedOrderPromotions = [orderPromotion1, orderPromotion2]
        
        return promotion
    }
}
