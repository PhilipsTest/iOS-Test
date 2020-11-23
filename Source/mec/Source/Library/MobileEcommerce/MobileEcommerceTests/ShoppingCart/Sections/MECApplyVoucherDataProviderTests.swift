/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsUIKitDLS
import PhilipsEcommerceSDK


class MECApplyVoucherDataProviderTests: XCTestCase {
    
    var sut: MECApplyVoucherDataProvider!
    var dataBus:MECDataBus!
    let appinfra = MockAppInfra()
    
    override func setUp() {
        super.setUp()
        MECConfiguration.shared.sharedAppInfra = appinfra
        dataBus = MECDataBus()
        sut = MECApplyVoucherDataProvider(cartDataBus: dataBus)
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
    
    func testHeightForHeader() {
        let appConfig = MockAppConfig()
        appConfig.propertyFofKey = 0
        
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 0)
    }
    
    func testHeightForHeaderVoucherEnabled() {
        let appConfig = MockAppConfig()
        appConfig.propertyFofKey = 1
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECApplyVoucherCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testViewForHeader() {
        let appConfig = MockAppConfig()
        appConfig.propertyFofKey = 1
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        
        XCTAssertNotNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testViewForHeaderVoucherDisabled() {
        let appConfig = MockAppConfig()
        appConfig.propertyFofKey = 0
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        
        XCTAssertNil(sut.tableView(UITableView(), viewForHeaderInSection: 0))
    }
    
    func testNumberOfRows() {
         let appConfig = MockAppConfig()
         appConfig.propertyFofKey = 1
         MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }
    
    func testNumberOfRowsVoucherDisabled() {
         let appConfig = MockAppConfig()
         appConfig.propertyFofKey = 0
         MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testCellForRowAtsVoucherEnabled() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let appConfig = MockAppConfig()
        appConfig.propertyFofKey = 1
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECApplyVoucherCell
        XCTAssertNotNil(cell)
    }
    
    func testCellForRowAtVoucherDisabled() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let appConfig = MockAppConfig()
        appConfig.propertyFofKey = 0
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECApplyVoucherCell
        XCTAssertNil(cell)
    }
    
    func testshouldShowApplyVoucher() {
        let appConfig = MockAppConfig()
        MECConfiguration.shared.sharedAppInfra.appConfig = appConfig
        XCTAssertFalse(sut.shouldShowApplyVoucher())
    }
}
