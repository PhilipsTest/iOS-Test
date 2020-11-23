/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev
import PhilipsPRXClient

class ECSFetchOrderHistoryDetailsTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var serviceDiscoveryMock: ServiceDiscoveryMock!
    var mockOrder: ECSOrder!
    var mockOrderDetail: ECSOrderDetail!
    var mockOrderID: String!

    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        serviceDiscoveryMock = ServiceDiscoveryMock()
        mockOrderID = "24003330178"
        mockOrder = ECSOrder()
        mockOrder.orderID = mockOrderID
        mockOrderDetail = ECSOrderDetail()
        mockOrderDetail.orderID = mockOrderID
    }

    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        mockRestClient = nil
        serviceDiscoveryMock = nil
        mockOrder = nil
        mockOrderDetail = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
        ECSUtilityMock.requestManager = nil
    }
    
    func testFetchOrderHistoryDetailsSuccess() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsSuccess")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertEqual(orderDetail?.consignments?.first?.entries?.first?.trackAndTraceUrls?.first, "{300068874=http://www.fedex.com/Tracking?action=track&cntry_code=us&tracknumber_list=300068874}")
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsSuccessEntries() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsSuccessEntries")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertNil(error)
            XCTAssertEqual(orderDetail?.entries?.count, 1)
            XCTAssertNotNil(orderDetail?.entries?.first?.product)
            XCTAssertEqual(orderDetail?.orderID, self.mockOrderID)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithBlankOrderHistory() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistoryDetailsEmptyOrder")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithBlankOrderHistory")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertNil(error)
            XCTAssertNil(orderDetail?.entries)
            XCTAssertNil(orderDetail?.entries?.first?.product)
            XCTAssertEqual(orderDetail?.orderID, "24003376629")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithProductSummaryFetchFailure() {
        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey:"Provide Proper CTNs"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockRestClient.secondErrorData = NSError(domain: "", code: 333, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithProductSummaryFetchFailure")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertNotNil(orderDetail?.entries?.first?.product)
            XCTAssertNil(orderDetail?.entries?.first?.product?.productPRXSummary)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Provide Proper CTNs")
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithNilCTN() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsListWithNilEntryCTN")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithNilCTN")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertNotNil(orderDetail?.entries?.first?.product)
            XCTAssertNil(orderDetail?.entries?.first?.product?.productPRXSummary)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithInvalidOrderID() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsInvalidIdError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithInvalidOrderID")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithNilOrderID() {
        mockOrderDetail.orderID = nil
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithNilOrderID")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithBlankOrderID() {
        mockOrderDetail.orderID = ""
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithBlankOrderID")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        ECSConfiguration.shared.appInfra = nil
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithNilAppInfra")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithNilSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithNilSiteID")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithoutOAuth() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithoutOAuth")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithInvalidToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithInvalidToken")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForNonHybris() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForNonHybris")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsListInvalidJson")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithInvalidJson")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 333, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsWithUncaughtError")
        ecsService.fetchOrderDetailsFor(orderDetail: mockOrderDetail) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 333)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderSuccess() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["DIS363/03"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderSuccess")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order?.orderDetails)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderSuccessEntries() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderSuccessEntries")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(error)
            XCTAssertEqual(order?.orderDetails?.entries?.count, 1)
            XCTAssertNotNil(order?.orderDetails?.entries?.first?.product)
            XCTAssertEqual(order?.orderDetails?.orderID, self.mockOrderID)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithBlankOrderHistory() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistoryDetailsEmptyOrder")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithBlankOrderHistory")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order?.orderDetails)
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails?.entries)
            XCTAssertNil(error)
            XCTAssertEqual(order?.orderDetails?.orderID, "24003376629")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithProductSummaryFetchFailure() {
        let mock = PRXRequestManagerMock()
        mock.error =  NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey: "Provide Proper CTNs"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockRestClient.secondErrorData = NSError(domain: "", code: 333, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithProductSummaryFetchFailure")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNotNil(order?.orderDetails)
            XCTAssertNotNil(order?.orderDetails?.entries?.first?.product)
            XCTAssertNil(order?.orderDetails?.entries?.first?.product?.productPRXSummary)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Provide Proper CTNs")
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithNilCTN() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsListWithNilEntryCTN")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithNilCTN")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order?.orderDetails)
            XCTAssertNotNil(order?.orderDetails?.entries?.first?.product)
            XCTAssertNil(order?.orderDetails?.entries?.first?.product?.productPRXSummary)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithInvalidOrderID() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsInvalidIdError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithInvalidOrderID")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithNilOrderID() {
        mockOrder.orderID = nil
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithNilOrderID")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithBlankOrderID() {
        mockOrder.orderID = ""
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithBlankOrderID")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        ECSConfiguration.shared.appInfra = nil
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithNilAppInfra")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithNilSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithNilSiteID")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithoutOAuth() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithoutOAuth")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithInvalidToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithInvalidToken")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderForNonHybris() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderForNonHybris")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsListInvalidJson")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithInvalidJson")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 333, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderWithUncaughtError")
        ecsService.fetchOrderDetailsFor(order: mockOrder) { (order, error) in
            XCTAssertNotNil(order)
            XCTAssertNil(order?.orderDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 333)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDSuccess() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDSuccess")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDSuccessEntries() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDSuccessEntries")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertNil(error)
            XCTAssertEqual(orderDetail?.entries?.count, 1)
            XCTAssertNotNil(orderDetail?.entries?.first?.product)
            XCTAssertEqual(orderDetail?.orderID, self.mockOrderID)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithBlankOrderHistory() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistoryDetailsEmptyOrder")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithBlankOrderHistory")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertNil(error)
            XCTAssertNil(orderDetail?.entries)
            XCTAssertNil(orderDetail?.entries?.first?.product)
            XCTAssertEqual(orderDetail?.orderID, "24003376629")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithProductSummaryFetchFailure() {
        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey: "Provide Proper CTNs"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockRestClient.secondErrorData = NSError(domain: "", code: 333, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        let prxManager = PRXRequestManagerMock()
        prxManager.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey: "Provide Proper CTNs"])
        //ECSConfiguration.shared.prxRequestManager = prxManager
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithProductSummaryFetchFailure")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertNotNil(orderDetail?.entries?.first?.product)
            XCTAssertNil(orderDetail?.entries?.first?.product?.productPRXSummary)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Provide Proper CTNs")
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithNilCTN() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsListWithNilEntryCTN")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithNilCTN")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertNotNil(orderDetail?.entries?.first?.product)
            XCTAssertNil(orderDetail?.entries?.first?.product?.productPRXSummary)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithInvalidOrderID() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsInvalidIdError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithInvalidOrderID")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithBlankOrderID() {
        mockOrderID = ""
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithBlankOrderID")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Requested resource is not available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        ECSConfiguration.shared.appInfra = nil
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithNilAppInfra")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithNilSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithNilSiteID")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithoutOAuth() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithoutOAuth")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithInvalidToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithInvalidToken")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDForNonHybris() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDForNonHybris")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsListInvalidJson")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithInvalidJson")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryDetailsForOrderIDWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 333, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryDetailsForOrderIDWithUncaughtError")
        ecsService.fetchOrderDetailsFor(orderID: mockOrderID) { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 333)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetUpProductDataMethodWithCorrectEntry() {
        let testMicro = ECSFetchOrderHistoryDetailsMicroService()
        var mockEntries = [ECSEntry]()
        let mockEntry = ECSEntry()
        let mockProduct = ECSProduct()
        let mockProductSummary = PRXSummaryData()
        mockProductSummary.ctn = "HX1234/04"
        
//        var mockProductDetails = [ECSProductDetails]()
//        let mockProductDetail = ECSProductDetails()
//
//        mockProductDetail.ctn = "HX1234/04"
//        mockProductDetails.append(mockProductDetail)
//        mockProductSummary.data = mockProductDetails
        
        mockProduct.ctn = "HX1234/04"
        mockEntry.product = mockProduct
        mockEntries.append(mockEntry)
        
        testMicro.setUpProductData(for: mockEntries, with: [mockProductSummary])
        XCTAssertNotNil(mockProduct.productPRXSummary)
        XCTAssertEqual(mockProduct.ctn, mockProduct.productPRXSummary?.ctn)
    }
    
    func testSetUpProductDataMethodWithInvalidProductCTNEntry() {
        let testMicro = ECSFetchOrderHistoryDetailsMicroService()
        var mockEntries = [ECSEntry]()
        let mockEntry = ECSEntry()
        let mockProduct = ECSProduct()
        let mockProductSummary = PRXSummaryData()
        
        mockEntry.product = mockProduct
        mockEntries.append(mockEntry)
        
        testMicro.setUpProductData(for: mockEntries, with: [mockProductSummary])
        XCTAssertNil(mockProduct.productPRXSummary)
    }
    
    func testSetUpProductDataMethodWithUnmatchingCTNEntry() {
        let testMicro = ECSFetchOrderHistoryDetailsMicroService()
        var mockEntries = [ECSEntry]()
        let mockEntry = ECSEntry()
        let mockProduct = ECSProduct()
        let mockProductSummary = PRXSummaryData()
        mockProductSummary.ctn = "HX1234/04"
        
        mockProduct.ctn = "HX1234/05"
        mockEntry.product = mockProduct
        mockEntries.append(mockEntry)
        
        testMicro.setUpProductData(for: mockEntries, with: [mockProductSummary])
        XCTAssertNil(mockProduct.productPRXSummary)
    }
}

extension ECSFetchOrderHistoryDetailsTests {
    
    func getSummaryResponse(ctnList: [String]) -> PRXSummaryListResponse {
        let response = PRXSummaryListResponse()
        for ctn in ctnList {
            let data = PRXSummaryData()
            data.ctn = ctn
            response.data.append(data)
        }
        response.success = true
        return response
    }
    
    func swizzleGetPRXRequestManagerMethod() {
        let originalSelector = #selector(ECSUtility.getPRXRequestManager)
        let swizzledSelector = #selector(ECSUtilityMock.getRequestManager)
        if let originalMethod = class_getClassMethod(ECSUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(ECSUtilityMock.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func deSwizzleGetPRXRequestManagerMethod() {
        let originalSelector = #selector(ECSUtility.getPRXRequestManager)
        let swizzledSelector = #selector(ECSUtilityMock.getRequestManager)
        if let originalMethod = class_getClassMethod(ECSUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(ECSUtilityMock.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
}
