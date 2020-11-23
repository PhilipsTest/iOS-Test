/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsUIKitDLS
import PhilipsPRXClient

class MECOrderDetailContactProviderTests: XCTestCase {

    var sut: MECOrderDetailContactProvider!
    
    override func setUp() {
        super.setUp()
        sut = MECOrderDetailContactProvider(with: PRXCDLSResponse(), orderDetail: ECSOrderDetail())
    }
    
    func testRegister() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        XCTAssertNotNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECOrderDetailContactCell))
        XCTAssertNil(tableView.dequeueReusableCell(withIdentifier: MECCellIdentifier.MECProductGridCell))
    }
    
    func testnumberOfRowsInSection() {
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 1)
    }
    
    func testheightForHeaderInSection() {
        XCTAssertEqual(sut.tableView(UITableView(), heightForHeaderInSection: 0), 40.0)
    }
    
    func testviewForHeaderInSectionWithoutCreationDate() {
        let view = sut.tableView(UITableView(), viewForHeaderInSection: 0) as? UIDHeaderView
        
        XCTAssertNotNil(view)
        XCTAssertNil(view?.headerLabel.text)
    }
    
    func testviewForHeaderInSectionWithCreationDate() {
        
        let orderDetail = ECSOrderDetail()
        orderDetail.created = "2020-05-06T11:21:15+0000"
        
        sut = MECOrderDetailContactProvider(with: PRXCDLSResponse(), orderDetail: orderDetail)
        let view = sut.tableView(UITableView(), viewForHeaderInSection: 0) as? UIDHeaderView
        
        XCTAssertNotNil(view)
        XCTAssertEqual(view?.headerLabel.text, "Wednesday May 06, 2020")
    }

    func testcellForRowAtWithoutCDLS() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let orderDetail = ECSOrderDetail()
        orderDetail.statusDisplay = "processing"
        orderDetail.orderID = "12345"
        sut = MECOrderDetailContactProvider(with: nil, orderDetail: orderDetail)
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECOrderDetailContactCell
        XCTAssertEqual(cell?.orderStatusLabel.text, "Your order is processing")
        XCTAssertEqual(cell?.orderIdLabel.text, "Order number: 12345")
        
        XCTAssertEqual(cell?.weekdayopeningHour.isHidden, true)
        XCTAssertEqual(cell?.weekendOpeningHour.isHidden, true)
        XCTAssertEqual(cell?.consumerCareInfo.isHidden, true)
        XCTAssertEqual(cell?.callusButton.isHidden, true)
    }
    
    func testcellForRowAtWithCDLS() {
        let tableView = UITableView()
        sut.registerCell(for: tableView)
        
        let orderDetail = ECSOrderDetail()
        orderDetail.statusDisplay = "processing"
        orderDetail.orderID = "12345"
        sut = MECOrderDetailContactProvider(with: getCDLS(), orderDetail: orderDetail)
        
        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MECOrderDetailContactCell
        XCTAssertEqual(cell?.orderStatusLabel.text, "Your order is processing")
        XCTAssertEqual(cell?.orderIdLabel.text, "Order number: 12345")
        
        XCTAssertEqual(cell?.weekdayopeningHour.isHidden, false)
        XCTAssertEqual(cell?.weekendOpeningHour.isHidden, false)
        XCTAssertEqual(cell?.consumerCareInfo.isHidden, false)
        XCTAssertEqual(cell?.callusButton.isHidden, false)
        
        XCTAssertEqual(cell?.weekdayopeningHour.text, "Test opening hour Weekdays")
        XCTAssertEqual(cell?.weekendOpeningHour.text, "Test opening hour saturday")
        XCTAssertEqual(cell?.consumerCareInfo.text, "Please contact Philips Consumer Care 12345 for further support.")
        XCTAssertEqual(cell?.callusButton.titleLabel?.text, "Call  12345")
    }
    
    func getCDLS() -> PRXCDLSResponse {
        let cdls = PRXCDLSResponse()
        cdls.data = PRXCDLSData()
        let phone = PRXCDLSDetails()
        phone.openingHoursSaturday  = "Test opening hour saturday"
        phone.openingHoursSunday  = "Test opening hour Sunday"
        phone.openingHoursWeekdays  = "Test opening hour Weekdays"
        phone.phoneNumber  = "12345"
        cdls.data?.contactPhone = [phone]
        
        return cdls
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
