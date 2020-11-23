/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS

class MECOrderDetailShippingDataProviderTests: XCTestCase {

    var sut: MECOrderDetailShippingDataProvider!
    
    override func setUp() {
        super.setUp()
        sut = MECOrderDetailShippingDataProvider(with: getOrderDetail())
    }

    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECCheckoutShippingCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testViewForHeaderInSection() {
        let view = sut.tableView(UITableView(), viewForHeaderInSection: 0) as? UIDHeaderView
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.headerLabel.text, MECLocalizedString("mec_order_summary_shipping"))
    }
    
    func testHeightForHeaderInSectionDeliveryModeAndDeliveryAddressNil() {
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 0)
    }
    
    func testHeightForHeaderInSectionDeliveryAddressNil() {
        let orderDetail = getOrderDetail()
        orderDetail.deliveryMode = ECSDeliveryMode()
        orderDetail.deliveryAddress = nil
        sut = MECOrderDetailShippingDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testHeightForHeaderInSectionDeliveryModeNil() {
        let orderDetail = getOrderDetail()
        orderDetail.deliveryMode = nil
        orderDetail.deliveryAddress = ECSAddress()
        sut = MECOrderDetailShippingDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testHeightForHeaderInSectionDeliveryModeAndDeliveryAddressNotNil() {
        let orderDetail = getOrderDetail()
        orderDetail.deliveryMode = ECSDeliveryMode()
        orderDetail.deliveryAddress = ECSAddress()
        sut = MECOrderDetailShippingDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40)
    }
    
    func testnumberOfRowsInSectionDeliveryAddressNil() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
    
    func testnumberOfRowsInSectionDeliveryAddressNotNil() {
        let orderDetail = getOrderDetail()
        orderDetail.deliveryAddress = ECSAddress()
        sut = MECOrderDetailShippingDataProvider(with: orderDetail)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }
    
    func testCellForRowAt() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        XCTAssertNotNil(sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECCheckoutShippingCell)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func getOrderDetail() -> ECSOrderDetail {
        let orderDetail = ECSOrderDetail()
        return orderDetail
    }
}
