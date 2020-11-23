/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECOrderDetailDeliveryModeDataProviderTests: XCTestCase {

    var sut: MECOrderDetailDeliveryModeDataProvider!
    override func setUp() {
        super.setUp()
        sut = MECOrderDetailDeliveryModeDataProvider(with: ECSOrderDetail())
    }

    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutDeliveryModeCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testnumberOfRowsInSectionDeliveryModeNil() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testnumberOfRowsInSectionDeliveryModeNotNil() {
        let orderDetail = ECSOrderDetail()
        orderDetail.deliveryMode = ECSDeliveryMode()
        sut = MECOrderDetailDeliveryModeDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }
    
    func testcellForRowAt() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutDeliveryModeCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.deliveryModeName.text, "")
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}
