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

class MECOrderDetailPresenterTests: XCTestCase {

    var sut: MECOrderDetailPresenter!
    
    override func setUp() {
        
    }

    func testnumberOfProductInCart() {
        let orderDetail = ECSOrderDetail()
        sut = MECOrderDetailPresenter(with: orderDetail)
        XCTAssertEqual(sut.numberOfProductInCart(), 0)
        orderDetail.entries = [ECSEntry(), ECSEntry()]
        XCTAssertEqual(sut.numberOfProductInCart(), 2)
    }
    
    func testtotalTax() {
        let orderDetail = ECSOrderDetail()
        sut = MECOrderDetailPresenter(with: orderDetail)
        XCTAssertEqual(sut.totalTax(), "")
        orderDetail.totalTax = ECSPrice()
        orderDetail.totalTax?.formattedValue = "10 $"
        XCTAssertEqual(sut.totalTax(), "10 $")
    }
    
    func testtotalPrice() {
        let orderDetail = ECSOrderDetail()
        sut = MECOrderDetailPresenter(with: orderDetail)
        XCTAssertEqual(sut.totalPrice(), "")
        orderDetail.totalPriceWithTax = ECSPrice()
        orderDetail.totalPriceWithTax?.formattedValue = "101 $"
        
        XCTAssertEqual(sut.totalPrice(), "101 $")
    }
    
    func testFetchCDLSDetailforProductNil() {
        let orderDetail = ECSOrderDetail()
        sut = MECOrderDetailPresenter(with: orderDetail)
        sut.fetchCDLSDetailfor { (response) in
            XCTAssertNil(response)
        }
    }
    
    func testFetchCDLSDetailforProductNotNil() {
        let orderDetail = ECSOrderDetail()
        let entry = ECSEntry()
        entry.product = ECSProduct()
        entry.product?.productPRXSummary = PRXSummaryData()
        entry.product?.productPRXSummary?.subcategory = "TestCategory"
        orderDetail.entries = [entry]
        
        sut = MECOrderDetailPresenter(with: orderDetail)
        let prxManager = MockPRXHandler()
        prxManager.mockCDLSDetails = getCDLS()
        sut.prxManager = prxManager
        sut.fetchCDLSDetailfor { (response) in
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.data?.contactPhone?.first?.phoneNumber, "12345")
            XCTAssertEqual(response?.data?.contactPhone?.first?.openingHoursSaturday, "Test opening hour saturday")
            XCTAssertEqual(response?.data?.contactPhone?.first?.openingHoursSunday, "Test opening hour Sunday")
        }
    }
    
    func testTrakinURLWithoutConsignment() {
        let orderDetail = ECSOrderDetail()
        sut = MECOrderDetailPresenter(with: orderDetail)
        XCTAssertNil(sut.trakinURL(at: 0))
    }
    
    func testTrakinURLWithConsignment() {
        let orderDetail = ECSOrderDetail()
        let consignment = ECSConsignment()
        let entry = ECSConsignmentEntry()
        entry.trackAndTraceUrls = ["{300068874=http://www.fedex.com/Tracking?action=track&cntry_code=us&tracknumber_list=300068874}"]
        entry.trackAndTraceIDs = ["300068874"]
        consignment.entries = [entry]
        orderDetail.consignments = [consignment]
        sut = MECOrderDetailPresenter(with: orderDetail)
        XCTAssertEqual(sut.trakinURL(at: 0)?.absoluteString, "http://www.fedex.com/Tracking?action=track&cntry_code=us&tracknumber_list=300068874")
    }
    
    func testTrakinURLWithConsignmentWithoutTrackingID() {
        let orderDetail = ECSOrderDetail()
        let consignment = ECSConsignment()
        let entry = ECSConsignmentEntry()
        entry.trackAndTraceUrls = ["{300068874=http://www.fedex.com/Tracking?action=track&cntry_code=us&tracknumber_list=300068874}"]
        entry.trackAndTraceIDs = []
        consignment.entries = [entry]
        orderDetail.consignments = [consignment]
        sut = MECOrderDetailPresenter(with: orderDetail)
        XCTAssertNil(sut.trakinURL(at: 0)?.absoluteString)
    }
    
    func testTrakinURLWithConsignmentInvalidURL() {
        let orderDetail = ECSOrderDetail()
        let consignment = ECSConsignment()
        let entry = ECSConsignmentEntry()
        entry.trackAndTraceUrls = ["{300068874=}"]
        entry.trackAndTraceIDs = ["300068874"]
        consignment.entries = [entry]
        orderDetail.consignments = [consignment]
        sut = MECOrderDetailPresenter(with: orderDetail)
        XCTAssertNil(sut.trakinURL(at: 0)?.absoluteString)
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
