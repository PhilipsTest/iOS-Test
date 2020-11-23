/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECOrderDetailPromotionDataProviderTests: XCTestCase {

    var sut: MECOrderDetailPromotionDataProvider!
    override func setUp() {
        super.setUp()
        sut = MECOrderDetailPromotionDataProvider(with: ECSOrderDetail())
    }

    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECSummaryCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }

    func testnumberOfRowsInSection() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
        
        let orderDetail = ECSOrderDetail()
        orderDetail.appliedOrderPromotions = [ECSOrderPromotion(), ECSOrderPromotion()]
        sut = MECOrderDetailPromotionDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
    }
    
    func testcellForRowAt() {
        
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECSummaryCell)
        
        let promotion = ECSOrderPromotion()
        promotion.promotion = ECSPromotion()
        promotion.promotion?.name = "Test promotion"
        promotion.promotion?.promotionDiscount = ECSPrice()
        promotion.promotion?.promotionDiscount?.formattedValue = "10 $"
     
        let orderDetail = ECSOrderDetail()
        orderDetail.appliedOrderPromotions = [promotion]
        sut = MECOrderDetailPromotionDataProvider(with: orderDetail)
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECSummaryCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.primaryLabel.text, "Test promotion")
        XCTAssertEqual(cell?.secondaryLabel.text, "- 10 $")
        
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
