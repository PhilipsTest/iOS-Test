/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import MobileEcommerceDev
import PhilipsEcommerceSDK
import PhilipsPRXClient

class MECOrderHistoryPresenterTests: XCTestCase {
    
    var orderHistoryPresenter: MECOrderHistoryPresenter!
    var mockECSService: MockECSService?

    override func setUp() {
        super.setUp()
        let appInfra = MockAppInfra()
        MECConfiguration.shared.sharedAppInfra = appInfra
        orderHistoryPresenter = MECOrderHistoryPresenter()
        mockECSService = MockECSService(propositionId: "TEST", appInfra: appInfra)
        MECConfiguration.shared.ecommerceService = mockECSService
        MECConfiguration.shared.isHybrisAvailable = true
    }

    override func tearDown() {
        super.tearDown()
        orderHistoryPresenter = nil
        mockECSService = nil
        MECConfiguration.shared.ecommerceService = nil
        MECConfiguration.shared.isHybrisAvailable = false
        MECConfiguration.shared.sharedAppInfra = nil
    }
    
    func testFetchOrderHistorySuccess() {
        swizzlePlacedDateFormatMethod()
        let mockOrderHistory = ECSOrderHistory()
        let mockOrder = ECSOrder()
        let mockOrderDetail = ECSOrderDetail()
        let mockOrderDate = "TestOrderDate"
        let mockOrderID = "TestID"
        let mockDeliveryStatus = "MockDeliveryStatus"
        mockOrderDetail.deliveryStatus = mockDeliveryStatus
        mockOrder.orderID = mockOrderID
        mockOrder.placedDateString = mockOrderDate
        mockOrderHistory.orders = [mockOrder]
        mockECSService?.orderHistory = mockOrderHistory
        mockECSService?.orderDetails = [mockOrderID: mockOrderDetail]
        let expectation = self.expectation(description: "testFetchOrderHistorySuccess")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertNil(error)
                XCTAssertEqual(self?.orderHistoryPresenter.orderDisplayDates?.count, 1)
                XCTAssertEqual(self?.orderHistoryPresenter.placedOrders?.keys.count, 1)
                XCTAssertEqual(self?.orderHistoryPresenter.placedOrders?[mockOrderDate]?.count, 1)
                XCTAssertEqual(self?.orderHistoryPresenter.placedOrders?[mockOrderDate]?.first, mockOrder)
                XCTAssertEqual(self?.orderHistoryPresenter.placedOrders?[mockOrderDate]?.first?.orderID, mockOrderID)
                XCTAssertEqual(self?.orderHistoryPresenter.placedOrders?[mockOrderDate]?.first?.orderDetails?.deliveryStatus, mockDeliveryStatus)
                XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.isDataFetching, false)
                self?.deSwizzlePlacedDateFormatMethod()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryFailure() {
        mockECSService?.orderHistoryError = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchOrderHistoryFailure")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.code, 123)
                XCTAssertEqual(self?.orderHistoryPresenter.orderDisplayDates?.count, 0)
                XCTAssertEqual(self?.orderHistoryPresenter.placedOrders?.keys.count, 0)
                XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.isDataFetching, false)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryFailureForOAuth() {
        mockECSService?.shouldSendOauthError = true
        let expectation = self.expectation(description: "testFetchOrderHistoryFailureForOAuth")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertNil(error)
                XCTAssertEqual(self?.orderHistoryPresenter.orderDisplayDates?.count, 0)
                XCTAssertEqual(self?.orderHistoryPresenter.placedOrders?.keys.count, 0)
                XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.isDataFetching, false)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithoutOrders() {
        let mockOrderHistory = ECSOrderHistory()
        mockECSService?.orderHistory = mockOrderHistory
        let expectation = self.expectation(description: "testFetchOrderHistoryWithoutOrders")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertNil(error)
                XCTAssertEqual(self?.orderHistoryPresenter.orderDisplayDates?.count, 0)
                XCTAssertEqual(self?.orderHistoryPresenter.placedOrders?.keys.count, 0)
                XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.isDataFetching, false)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDetailsForOrderSuccess() {
        let mockOrder = ECSOrder()
        let mockOrderDetail = ECSOrderDetail()
        let mockOrderDate = "TestOrderDate"
        let mockOrderID = "TestID"
        let mockDeliveryStatus = "MockDeliveryStatus"
        mockOrderDetail.deliveryStatus = mockDeliveryStatus
        mockOrder.orderID = mockOrderID
        mockOrder.placedDateString = mockOrderDate
        mockECSService?.orderDetails = [mockOrderID: mockOrderDetail]
        let expectation = self.expectation(description: "testFetchOrderHistorySuccess")
        orderHistoryPresenter.fetchDetailsForOrder(order: mockOrder) { [weak self] in
            XCTAssertNotNil(mockOrder.orderDetails)
            XCTAssertEqual(mockOrder.orderDetails?.deliveryStatus, mockDeliveryStatus)
            XCTAssertEqual(mockOrder.orderID, mockOrderID)
            XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.isDataFetching, false)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDetailsForOrderFailure() {
        let error = NSError(domain: "", code: 123, userInfo: nil)
        let mockOrder = ECSOrder()
        let mockOrderDate = "TestOrderDate"
        let mockOrderID = "TestID"
        mockOrder.orderID = mockOrderID
        mockOrder.placedDateString = mockOrderDate
        mockECSService?.orderDetailError = [mockOrderID: error]
        let expectation = self.expectation(description: "testFetchDetailsForOrderFailure")
        orderHistoryPresenter.fetchDetailsForOrder(order: mockOrder) { [weak self] in
            XCTAssertNil(mockOrder.orderDetails)
            XCTAssertEqual(mockOrder.orderID, mockOrderID)
            XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.isDataFetching, false)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDetailsForOrderFailureWithOAuth() {
        mockECSService?.shouldSendOauthError = true
        let mockOrder = ECSOrder()
        let mockOrderDetail = ECSOrderDetail()
        let mockOrderDate = "TestOrderDate"
        let mockOrderID = "TestID"
        let mockDeliveryStatus = "MockDeliveryStatus"
        mockOrderDetail.deliveryStatus = mockDeliveryStatus
        mockOrder.orderID = mockOrderID
        mockOrder.placedDateString = mockOrderDate
        mockECSService?.orderDetails = [mockOrderID: mockOrderDetail]
        let expectation = self.expectation(description: "testFetchDetailsForOrderFailureWithOAuth")
        orderHistoryPresenter.fetchDetailsForOrder(order: mockOrder) { [weak self] in
            XCTAssertNotNil(mockOrder.orderDetails)
            XCTAssertEqual(mockOrder.orderDetails?.deliveryStatus, mockDeliveryStatus)
            XCTAssertEqual(mockOrder.orderID, mockOrderID)
            XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.isDataFetching, false)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchTotalNumberOfOrders() {
        swizzlePlacedDateFormatMethod()
        let mockOrderHistory = ECSOrderHistory()
        let mockOrder1 = ECSOrder()
        let mockOrder2 = ECSOrder()
        let mockOrder3 = ECSOrder()
        let mockOrderDetail1 = ECSOrderDetail()
        let mockOrderDate1 = "TestOrderDate1"
        let mockOrderID1 = "TestID1"
        let mockDeliveryStatus1 = "MockDeliveryStatus1"
        let mockOrderDetail2 = ECSOrderDetail()
        let mockOrderDate2 = "TestOrderDate2"
        let mockOrderID2 = "TestID2"
        let mockDeliveryStatus2 = "MockDeliveryStatus2"
        let mockOrderDetail3 = ECSOrderDetail()
        let mockOrderDate3 = "TestOrderDate3"
        let mockOrderID3 = "TestID3"
        let mockDeliveryStatus3 = "MockDeliveryStatus3"
        mockOrderDetail1.deliveryStatus = mockDeliveryStatus1
        mockOrder1.orderID = mockOrderID1
        mockOrder1.placedDateString = mockOrderDate1
        mockOrderDetail2.deliveryStatus = mockDeliveryStatus2
        mockOrder2.orderID = mockOrderID2
        mockOrder2.placedDateString = mockOrderDate2
        mockOrderDetail3.deliveryStatus = mockDeliveryStatus3
        mockOrder3.orderID = mockOrderID3
        mockOrder3.placedDateString = mockOrderDate3
        mockOrderHistory.orders = [mockOrder1, mockOrder2, mockOrder3]
        mockECSService?.orderHistory = mockOrderHistory
        mockECSService?.orderDetails = [mockOrderID1: mockOrderDetail1, mockOrderID2: mockOrderDetail2, mockOrderID3: mockOrderDetail3]
        let expectation = self.expectation(description: "testFetchTotalNumberOfOrders")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchTotalNumberOfOrders(), 3)
                self?.deSwizzlePlacedDateFormatMethod()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchTotalNumberOfOrdersWithSameDateOrders() {
        swizzlePlacedDateFormatMethod()
        let mockOrderHistory = ECSOrderHistory()
        let mockOrder1 = ECSOrder()
        let mockOrder2 = ECSOrder()
        let mockOrder3 = ECSOrder()
        let mockOrderDetail1 = ECSOrderDetail()
        let mockOrderDate1 = "TestOrderDate1"
        let mockOrderID1 = "TestID1"
        let mockDeliveryStatus1 = "MockDeliveryStatus1"
        let mockOrderDetail2 = ECSOrderDetail()
        let mockOrderDate2 = "TestOrderDate1"
        let mockOrderID2 = "TestID2"
        let mockDeliveryStatus2 = "MockDeliveryStatus2"
        let mockOrderDetail3 = ECSOrderDetail()
        let mockOrderDate3 = "TestOrderDate3"
        let mockOrderID3 = "TestID3"
        let mockDeliveryStatus3 = "MockDeliveryStatus3"
        mockOrderDetail1.deliveryStatus = mockDeliveryStatus1
        mockOrder1.orderID = mockOrderID1
        mockOrder1.placedDateString = mockOrderDate1
        mockOrderDetail2.deliveryStatus = mockDeliveryStatus2
        mockOrder2.orderID = mockOrderID2
        mockOrder2.placedDateString = mockOrderDate2
        mockOrderDetail3.deliveryStatus = mockDeliveryStatus3
        mockOrder3.orderID = mockOrderID3
        mockOrder3.placedDateString = mockOrderDate3
        mockOrderHistory.orders = [mockOrder1, mockOrder2, mockOrder3]
        mockECSService?.orderHistory = mockOrderHistory
        mockECSService?.orderDetails = [mockOrderID1: mockOrderDetail1, mockOrderID2: mockOrderDetail2, mockOrderID3: mockOrderDetail3]
        let expectation = self.expectation(description: "testFetchTotalNumberOfOrdersWithSameDateOrders")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchTotalNumberOfOrders(), 2)
                self?.deSwizzlePlacedDateFormatMethod()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchTotalNumberOfOrdersForBlankOrders() {
        orderHistoryPresenter.orderDisplayDates = nil
        let expectation = self.expectation(description: "testFetchTotalNumberOfOrdersForBlankOrders")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchTotalNumberOfOrders(), 0)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchNumberOfOrderForSection() {
        swizzlePlacedDateFormatMethod()
        let mockOrderHistory = ECSOrderHistory()
        let mockOrder1 = ECSOrder()
        let mockOrder2 = ECSOrder()
        let mockOrder3 = ECSOrder()
        let mockOrderDetail1 = ECSOrderDetail()
        let mockOrderDate1 = "TestOrderDate1"
        let mockOrderID1 = "TestID1"
        let mockDeliveryStatus1 = "MockDeliveryStatus1"
        let mockOrderDetail2 = ECSOrderDetail()
        let mockOrderDate2 = "TestOrderDate2"
        let mockOrderID2 = "TestID2"
        let mockDeliveryStatus2 = "MockDeliveryStatus2"
        let mockOrderDetail3 = ECSOrderDetail()
        let mockOrderDate3 = "TestOrderDate3"
        let mockOrderID3 = "TestID3"
        let mockDeliveryStatus3 = "MockDeliveryStatus3"
        mockOrderDetail1.deliveryStatus = mockDeliveryStatus1
        mockOrder1.orderID = mockOrderID1
        mockOrder1.placedDateString = mockOrderDate1
        mockOrderDetail2.deliveryStatus = mockDeliveryStatus2
        mockOrder2.orderID = mockOrderID2
        mockOrder2.placedDateString = mockOrderDate2
        mockOrderDetail3.deliveryStatus = mockDeliveryStatus3
        mockOrder3.orderID = mockOrderID3
        mockOrder3.placedDateString = mockOrderDate3
        mockOrderHistory.orders = [mockOrder1, mockOrder2, mockOrder3]
        mockECSService?.orderHistory = mockOrderHistory
        mockECSService?.orderDetails = [mockOrderID1: mockOrderDetail1, mockOrderID2: mockOrderDetail2, mockOrderID3: mockOrderDetail3]
        let expectation = self.expectation(description: "testFetchNumberOfOrderForSection")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchNumberOfOrderFor(section: 0), 1)
                XCTAssertEqual(self?.orderHistoryPresenter.fetchNumberOfOrderFor(section: 1), 1)
                XCTAssertEqual(self?.orderHistoryPresenter.fetchNumberOfOrderFor(section: 2), 1)
                self?.deSwizzlePlacedDateFormatMethod()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchNumberOfOrderForSectionWithDifferentOrders() {
        swizzlePlacedDateFormatMethod()
        let mockOrderHistory = ECSOrderHistory()
        let mockOrder1 = ECSOrder()
        let mockOrder2 = ECSOrder()
        let mockOrder3 = ECSOrder()
        let mockOrderDetail1 = ECSOrderDetail()
        let mockOrderDate1 = "TestOrderDate1"
        let mockOrderID1 = "TestID1"
        let mockDeliveryStatus1 = "MockDeliveryStatus1"
        let mockOrderDetail2 = ECSOrderDetail()
        let mockOrderDate2 = "TestOrderDate1"
        let mockOrderID2 = "TestID2"
        let mockDeliveryStatus2 = "MockDeliveryStatus2"
        let mockOrderDetail3 = ECSOrderDetail()
        let mockOrderDate3 = "TestOrderDate3"
        let mockOrderID3 = "TestID3"
        let mockDeliveryStatus3 = "MockDeliveryStatus3"
        mockOrderDetail1.deliveryStatus = mockDeliveryStatus1
        mockOrder1.orderID = mockOrderID1
        mockOrder1.placedDateString = mockOrderDate1
        mockOrderDetail2.deliveryStatus = mockDeliveryStatus2
        mockOrder2.orderID = mockOrderID2
        mockOrder2.placedDateString = mockOrderDate2
        mockOrderDetail3.deliveryStatus = mockDeliveryStatus3
        mockOrder3.orderID = mockOrderID3
        mockOrder3.placedDateString = mockOrderDate3
        mockOrderHistory.orders = [mockOrder1, mockOrder2, mockOrder3]
        mockECSService?.orderHistory = mockOrderHistory
        mockECSService?.orderDetails = [mockOrderID1: mockOrderDetail1, mockOrderID2: mockOrderDetail2, mockOrderID3: mockOrderDetail3]
        let expectation = self.expectation(description: "testFetchNumberOfOrderForSectionWithDifferentOrders")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchNumberOfOrderFor(section: 0), 2)
                XCTAssertEqual(self?.orderHistoryPresenter.fetchNumberOfOrderFor(section: 1), 1)
                self?.deSwizzlePlacedDateFormatMethod()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchNumberOfOrderForSectionWithoutOrders() {
        orderHistoryPresenter.orderDisplayDates = nil
        let expectation = self.expectation(description: "testFetchNumberOfOrderForSectionWithoutOrders")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchNumberOfOrderFor(section: 0), 0)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchNumberOfOrderForSectionWithBlankOrders() {
        orderHistoryPresenter.orderDisplayDates = ["TestPlacedDate"]
        let expectation = self.expectation(description: "testFetchNumberOfOrderForSectionWithBlankOrders")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchNumberOfOrderFor(section: 0), 0)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderForIndexpath() {
        swizzlePlacedDateFormatMethod()
        let mockOrderHistory = ECSOrderHistory()
        let mockOrder1 = ECSOrder()
        let mockOrder2 = ECSOrder()
        let mockOrder3 = ECSOrder()
        let mockOrderDetail1 = ECSOrderDetail()
        let mockOrderDate1 = "TestOrderDate1"
        let mockOrderID1 = "TestID1"
        let mockDeliveryStatus1 = "MockDeliveryStatus1"
        let mockOrderDetail2 = ECSOrderDetail()
        let mockOrderDate2 = "TestOrderDate1"
        let mockOrderID2 = "TestID2"
        let mockDeliveryStatus2 = "MockDeliveryStatus2"
        let mockOrderDetail3 = ECSOrderDetail()
        let mockOrderDate3 = "TestOrderDate3"
        let mockOrderID3 = "TestID3"
        let mockDeliveryStatus3 = "MockDeliveryStatus3"
        mockOrderDetail1.deliveryStatus = mockDeliveryStatus1
        mockOrder1.orderID = mockOrderID1
        mockOrder1.placedDateString = mockOrderDate1
        mockOrderDetail2.deliveryStatus = mockDeliveryStatus2
        mockOrder2.orderID = mockOrderID2
        mockOrder2.placedDateString = mockOrderDate2
        mockOrderDetail3.deliveryStatus = mockDeliveryStatus3
        mockOrder3.orderID = mockOrderID3
        mockOrder3.placedDateString = mockOrderDate3
        mockOrderHistory.orders = [mockOrder1, mockOrder2, mockOrder3]
        mockECSService?.orderHistory = mockOrderHistory
        mockECSService?.orderDetails = [mockOrderID1: mockOrderDetail1, mockOrderID2: mockOrderDetail2, mockOrderID3: mockOrderDetail3]
        let expectation = self.expectation(description: "testFetchOrderForIndexpath")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchOrderFor(indexPath: IndexPath(row: 1, section: 0)), mockOrder2)
                self?.deSwizzlePlacedDateFormatMethod()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderForNilOrder() {
        orderHistoryPresenter.orderDisplayDates = nil
        let expectation = self.expectation(description: "testFetchOrderForNilOrder")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertNil(self?.orderHistoryPresenter.fetchOrderFor(indexPath: IndexPath(row: 1, section: 0)))
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderForBlankOrder() {
        orderHistoryPresenter.orderDisplayDates = ["TestDate"]
        let expectation = self.expectation(description: "testFetchOrderForBlankOrder")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertNil(self?.orderHistoryPresenter.fetchOrderFor(indexPath: IndexPath(row: 2, section: 0)))
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderForIndexPath() {
        swizzlePlacedDateFormatMethod()
        let mockOrderHistory = ECSOrderHistory()
        let mockOrder1 = ECSOrder()
        let mockOrder2 = ECSOrder()
        let mockOrder3 = ECSOrder()
        let mockOrderDetail1 = ECSOrderDetail()
        let mockOrderDate1 = "TestOrderDate1"
        let mockOrderID1 = "TestID1"
        let mockDeliveryStatus1 = "MockDeliveryStatus1"
        let mockOrderDetail2 = ECSOrderDetail()
        let mockOrderDate2 = "TestOrderDate2"
        let mockOrderID2 = "TestID2"
        let mockDeliveryStatus2 = "MockDeliveryStatus2"
        let mockOrderDetail3 = ECSOrderDetail()
        let mockOrderDate3 = "TestOrderDate3"
        let mockOrderID3 = "TestID3"
        let mockDeliveryStatus3 = "MockDeliveryStatus3"
        mockOrderDetail1.deliveryStatus = mockDeliveryStatus1
        mockOrder1.orderID = mockOrderID1
        mockOrder1.placedDateString = mockOrderDate1
        mockOrderDetail2.deliveryStatus = mockDeliveryStatus2
        mockOrder2.orderID = mockOrderID2
        mockOrder2.placedDateString = mockOrderDate2
        mockOrderDetail3.deliveryStatus = mockDeliveryStatus3
        mockOrder3.orderID = mockOrderID3
        mockOrder3.placedDateString = mockOrderDate3
        mockOrderHistory.orders = [mockOrder1, mockOrder2, mockOrder3]
        mockECSService?.orderHistory = mockOrderHistory
        mockECSService?.orderDetails = [mockOrderID1: mockOrderDetail1, mockOrderID2: mockOrderDetail2, mockOrderID3: mockOrderDetail3]
        let expectation = self.expectation(description: "testFetchOrderForIndexPath")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchOrderDisplayDateFor(section: 2), "TestOrderDate3")
                self?.deSwizzlePlacedDateFormatMethod()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderForIndexPathWithMultipleOrders() {
        swizzlePlacedDateFormatMethod()
        let mockOrderHistory = ECSOrderHistory()
        let mockOrder1 = ECSOrder()
        let mockOrder2 = ECSOrder()
        let mockOrder3 = ECSOrder()
        let mockOrderDetail1 = ECSOrderDetail()
        let mockOrderDate1 = "TestOrderDate1"
        let mockOrderID1 = "TestID1"
        let mockDeliveryStatus1 = "MockDeliveryStatus1"
        let mockOrderDetail2 = ECSOrderDetail()
        let mockOrderDate2 = "TestOrderDate1"
        let mockOrderID2 = "TestID2"
        let mockDeliveryStatus2 = "MockDeliveryStatus2"
        let mockOrderDetail3 = ECSOrderDetail()
        let mockOrderDate3 = "TestOrderDate3"
        let mockOrderID3 = "TestID3"
        let mockDeliveryStatus3 = "MockDeliveryStatus3"
        mockOrderDetail1.deliveryStatus = mockDeliveryStatus1
        mockOrder1.orderID = mockOrderID1
        mockOrder1.placedDateString = mockOrderDate1
        mockOrderDetail2.deliveryStatus = mockDeliveryStatus2
        mockOrder2.orderID = mockOrderID2
        mockOrder2.placedDateString = mockOrderDate2
        mockOrderDetail3.deliveryStatus = mockDeliveryStatus3
        mockOrder3.orderID = mockOrderID3
        mockOrder3.placedDateString = mockOrderDate3
        mockOrderHistory.orders = [mockOrder1, mockOrder2, mockOrder3]
        mockECSService?.orderHistory = mockOrderHistory
        mockECSService?.orderDetails = [mockOrderID1: mockOrderDetail1, mockOrderID2: mockOrderDetail2, mockOrderID3: mockOrderDetail3]
        let expectation = self.expectation(description: "testFetchOrderForIndexPathWithMultipleOrders")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchOrderDisplayDateFor(section: 0), "TestOrderDate1")
                self?.deSwizzlePlacedDateFormatMethod()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderDisplayDateForIndexpathWithNilOrders() {
        orderHistoryPresenter.orderDisplayDates = nil
        let expectation = self.expectation(description: "testFetchOrderDisplayDateForIndexpathWithNilOrders")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertEqual(self?.orderHistoryPresenter.fetchOrderDisplayDateFor(section: 0), "")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchProductImageURLForOrder() {
        let mockEntry = ECSEntry()
        let mockProduct = ECSProduct()
        let mockProductSummary = PRXSummaryData()
        let mockImageURL = "TestMockImage"
        mockProductSummary.imageURL = mockImageURL
        mockProduct.productPRXSummary = mockProductSummary
        mockEntry.product = mockProduct
        XCTAssertEqual(orderHistoryPresenter.fetchProductImageURLFor(orderEntry: mockEntry).contains("TestMockImage"), true)
    }
    
    func testFetchProductImageURLForOrderWithoutImage() {
        let mockEntry = ECSEntry()
        let mockProduct = ECSProduct()
        let mockProductSummary = PRXSummaryData()
        mockProduct.productPRXSummary = mockProductSummary
        mockEntry.product = mockProduct
        XCTAssertEqual(orderHistoryPresenter.fetchProductImageURLFor(orderEntry: mockEntry), "")
    }
    
    func testPaginationDataForOrderHistory() {
        swizzlePlacedDateFormatMethod()
        let mockOrderHistory = ECSOrderHistory()
        let mockPagination = ECSPagination()
        let mockOrder = ECSOrder()
        let mockOrderDetail = ECSOrderDetail()
        let mockOrderDate = "TestOrderDate"
        let mockOrderID = "TestID"
        let mockDeliveryStatus = "MockDeliveryStatus"
        mockPagination.currentPage = 1
        mockPagination.totalPages = 3
        mockPagination.pageSize = 20
        mockPagination.totalResults = 60
        mockOrderDetail.deliveryStatus = mockDeliveryStatus
        mockOrder.orderID = mockOrderID
        mockOrder.placedDateString = mockOrderDate
        mockOrderHistory.orders = [mockOrder]
        mockOrderHistory.pagination = mockPagination
        mockECSService?.orderHistory = mockOrderHistory
        mockECSService?.orderDetails = [mockOrderID: mockOrderDetail]
        let expectation = self.expectation(description: "testPaginationDataForOrderHistory")
        orderHistoryPresenter.fetchOrderHistory { [weak self] (error) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertNotNil(self?.orderHistoryPresenter.paginationHandler.paginationModel)
                XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.paginationModel?.currentPage, 1)
                XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.paginationModel?.totalPages, 3)
                XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.paginationModel?.pageSize, 20)
                XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.paginationModel?.totalResults, 60)
                XCTAssertEqual(self?.orderHistoryPresenter.paginationHandler.isDataFetching, false)
                self?.deSwizzlePlacedDateFormatMethod()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testShouldLoadMoreOrders() {
        let mockPaginationHandler = MECPaginationHelper()
        let mockPagination = ECSPagination()
        mockPagination.currentPage = 1
        mockPagination.totalPages = 3
        mockPagination.pageSize = 20
        mockPagination.totalResults = 60
        mockPaginationHandler.isDataFetching = true
        mockPaginationHandler.paginationModel = mockPagination
        orderHistoryPresenter.paginationHandler = mockPaginationHandler
        XCTAssertEqual(orderHistoryPresenter.shouldLoadMoreOrders(), false)
        
        mockPagination.totalResults = 0
        XCTAssertEqual(orderHistoryPresenter.shouldLoadMoreOrders(), false)
        
        mockPagination.currentPage = 1
        mockPaginationHandler.isDataFetching = false
        mockPagination.totalResults = 60
        XCTAssertEqual(orderHistoryPresenter.shouldLoadMoreOrders(), true)
        
        mockPagination.currentPage = 2
        mockPaginationHandler.isDataFetching = false
        mockPagination.totalResults = 60
        XCTAssertEqual(orderHistoryPresenter.shouldLoadMoreOrders(), false)
        
        mockPagination.currentPage = 3
        XCTAssertEqual(orderHistoryPresenter.shouldLoadMoreOrders(), false)
        
        mockPaginationHandler.paginationModel = nil
        XCTAssertEqual(orderHistoryPresenter.shouldLoadMoreOrders(), false)
    }
    
    func testUpdatePlacedOrderListWithOrder() {
        swizzlePlacedDateFormatMethod()
        let mockOrder = ECSOrder()
        let mockDate = "TestPlacedDate"
        mockOrder.placedDateString = mockDate
        
        orderHistoryPresenter.updatePlacedOrderListWith(order: mockOrder)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.count, 1)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.first, mockDate)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?.keys.count, 1)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDate]?.count, 1)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDate]?.first, mockOrder)
        deSwizzlePlacedDateFormatMethod()
    }
    
    func testUpdatePlacedOrderListWithAlreadyPlacedOrder() {
        swizzlePlacedDateFormatMethod()
        let mockOrderOld = ECSOrder()
        let mockOrder = ECSOrder()
        let mockDate = "TestPlacedDate"
        mockOrder.placedDateString = mockDate
        
        orderHistoryPresenter.placedOrders = [mockDate: [mockOrderOld]]
        
        orderHistoryPresenter.updatePlacedOrderListWith(order: mockOrder)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.count, 1)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.first, mockDate)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?.keys.count, 1)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDate]?.count, 2)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDate]?.first, mockOrderOld)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDate]?.last, mockOrder)
        deSwizzlePlacedDateFormatMethod()
    }
    
    func testUpdatePlacedOrderListWithNewOrders() {
        swizzlePlacedDateFormatMethod()
        let mockOrderOld = ECSOrder()
        let mockDateOld = "TestPlacedDateOld"
        mockOrderOld.placedDateString = mockDateOld
        let mockOrder = ECSOrder()
        let mockDate = "TestPlacedDate"
        mockOrder.placedDateString = mockDate
        
        orderHistoryPresenter.placedOrders = [mockDateOld: [mockOrderOld]]
        orderHistoryPresenter.orderDisplayDates = [mockDateOld]
        
        orderHistoryPresenter.updatePlacedOrderListWith(order: mockOrder)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.count, 2)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.first, mockDateOld)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.last, mockDate)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?.keys.count, 2)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDate]?.count, 1)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDateOld]?.count, 1)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDate]?.first, mockOrder)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDateOld]?.first, mockOrderOld)
        deSwizzlePlacedDateFormatMethod()
    }
    
    func testUpdatePlacedOrderListWithNoPlacedDateWithExistingOrders() {
        let mockOrderOld = ECSOrder()
        let mockDateOld = "TestPlacedDateOld"
        mockOrderOld.placedDateString = mockDateOld
        let mockOrder = ECSOrder()
        
        orderHistoryPresenter.placedOrders = [mockDateOld: [mockOrderOld]]
        orderHistoryPresenter.orderDisplayDates = [mockDateOld]
        
        orderHistoryPresenter.updatePlacedOrderListWith(order: mockOrder)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.count, 1)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.first, mockDateOld)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?.keys.count, 1)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDateOld]?.count, 1)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?[mockDateOld]?.first, mockOrderOld)
    }
    
    func testUpdatePlacedOrderListWithNoPlacedDate() {
        let mockOrder = ECSOrder()
        
        orderHistoryPresenter.updatePlacedOrderListWith(order: mockOrder)
        XCTAssertEqual(orderHistoryPresenter.orderDisplayDates?.count, 0)
        XCTAssertNil(orderHistoryPresenter.orderDisplayDates?.first)
        XCTAssertEqual(orderHistoryPresenter.placedOrders?.keys.count, 0)
    }
    
    func testConvertOrderPlacedDateToDisplayFormatUtility() {
        let actualDate = "2020-06-14T09:10:03+0000"
        let expectedDate = "Sunday June 14, 2020"
        XCTAssertEqual(MECUtility.convertOrderPlacedDateToDisplayFormat(placedDate: actualDate), expectedDate)
    }
    
    func testConvertOrderPlacedDateToDisplayFormatUtilityForBlankDate() {
        XCTAssertEqual(MECUtility.convertOrderPlacedDateToDisplayFormat(placedDate: ""), "")
    }
    
    func testConvertOrderPlacedDateToDisplayFormatUtilityForWrongDates() {
        XCTAssertEqual(MECUtility.convertOrderPlacedDateToDisplayFormat(placedDate: "2020-06-14"), "")
        XCTAssertEqual(MECUtility.convertOrderPlacedDateToDisplayFormat(placedDate: "T09:10:03+0000"), "")
    }
}

extension MECOrderHistoryPresenterTests {
    
    func swizzlePlacedDateFormatMethod() {
        let originalSelector = #selector(MECUtility.convertOrderPlacedDateToDisplayFormat(placedDate:))
        let swizzledSelector = #selector(MECMockOrderPlacedDate.fetchMockFormattedPlacedDate(date:))
        if let originalMethod = class_getClassMethod(MECUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(MECMockOrderPlacedDate.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func deSwizzlePlacedDateFormatMethod() {
        let originalSelector = #selector(MECUtility.convertOrderPlacedDateToDisplayFormat(placedDate:))
        let swizzledSelector = #selector(MECMockOrderPlacedDate.fetchMockFormattedPlacedDate(date:))
        if let originalMethod = class_getClassMethod(MECUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(MECMockOrderPlacedDate.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
}

class MECMockOrderPlacedDate: NSObject {
    
    @objc class func fetchMockFormattedPlacedDate(date: String) -> String {
        return date
    }
}
