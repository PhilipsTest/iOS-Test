//
//  MECOrderDetailDeliveryCostDataProviderTests.swift
//  MobileEcommerceTests
//
//  Created by Prasad on 5/7/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECOrderDetailDeliveryCostDataProviderTests: XCTestCase {

    var sut: MECOrderDetailDeliveryCostDataProvider!
    override func setUp() {
        super.setUp()
        sut = MECOrderDetailDeliveryCostDataProvider(with: ECSOrderDetail())
    }

    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testnumberOfRowsInSectionZeroVoucher() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }

    func testcellForRowAtWithoutDeliveryCost() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNil(sut.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0)) as? MECSummaryCell)
        
    }
    
    func testcellForRowAtWithDeliveryCost() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let orderDetail = ECSOrderDetail()
        orderDetail.deliveryCost = ECSPrice()
        orderDetail.deliveryCost?.formattedValue = "10 $"
        sut = MECOrderDetailDeliveryCostDataProvider(with: orderDetail)
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0)) as? MECSummaryCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.secondaryLabel.text, "10 $")
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
