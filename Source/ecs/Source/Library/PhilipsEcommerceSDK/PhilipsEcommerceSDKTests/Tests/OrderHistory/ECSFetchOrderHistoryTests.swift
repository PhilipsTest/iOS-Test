/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchOrderHistoryTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!

    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
    }

    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        mockRestClient = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
    }
    
    func testFetchOrderHistorySuccess() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistorySuccess")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNotNil(orderHistory)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistorySuccessEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistorySuccessEntries")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNotNil(orderHistory)
            XCTAssertNil(error)
            XCTAssertNotNil(orderHistory?.orders)
            XCTAssertEqual(orderHistory?.orders?.contains(where: { $0.orderID == "24003560112" }), true)
            XCTAssertEqual(orderHistory?.orders?.count, 18)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithPagination() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithPagination")
        ecsService.fetchOrderHistory(pageSize: 20, currentPage: 0) { (orderHistory, error) in
            XCTAssertNotNil(orderHistory)
            XCTAssertNil(error)
            XCTAssertNotNil(orderHistory?.orders)
            XCTAssertEqual(orderHistory?.pagination?.pageSize, 20)
            XCTAssertEqual(orderHistory?.pagination?.currentPage, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithNewUserWithPagination() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistoryBlank")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithNewUserWithPagination")
        ecsService.fetchOrderHistory(pageSize: 20, currentPage: 0) { (orderHistory, error) in
            XCTAssertNotNil(orderHistory)
            XCTAssertNil(error)
            XCTAssertNil(orderHistory?.orders)
            XCTAssertEqual(orderHistory?.pagination?.pageSize, 20)
            XCTAssertEqual(orderHistory?.pagination?.currentPage, 0)
            XCTAssertEqual(orderHistory?.pagination?.totalPages, 0)
            XCTAssertEqual(orderHistory?.pagination?.totalResults, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithNewUserWithoutPagination() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistoryBlank")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithNewUserWithoutPagination")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNotNil(orderHistory)
            XCTAssertNil(error)
            XCTAssertNil(orderHistory?.orders)
            XCTAssertEqual(orderHistory?.pagination?.pageSize, 20)
            XCTAssertEqual(orderHistory?.pagination?.currentPage, 0)
            XCTAssertEqual(orderHistory?.pagination?.totalPages, 0)
            XCTAssertEqual(orderHistory?.pagination?.totalResults, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithNegativePageSize() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderNegativePageSize")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithNegativePageSize")
        ecsService.fetchOrderHistory(pageSize: -100, currentPage: 0) { (orderHistory, error) in
            XCTAssertNotNil(orderHistory)
            XCTAssertNil(error)
            XCTAssertNotNil(orderHistory?.orders)
            XCTAssertEqual(orderHistory?.pagination?.pageSize, -100)
            XCTAssertEqual(orderHistory?.pagination?.currentPage, 0)
            XCTAssertEqual(orderHistory?.pagination?.totalPages, 0)
            XCTAssertNotEqual(orderHistory?.pagination?.totalResults, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithNegativeCurrentPage() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistoryNegativeCurrentSize")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithNegativeCurrentPage")
        ecsService.fetchOrderHistory(pageSize: 20, currentPage: -1) { (orderHistory, error) in
            XCTAssertNil(orderHistory)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide valid input data")
            XCTAssertEqual((error as NSError?)?.code, 5024)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithBlankOrderHistory() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistoryBlank")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithBlankOrderHistory")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNotNil(orderHistory)
            XCTAssertNil(error)
            XCTAssertNil(orderHistory?.orders)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        ECSConfiguration.shared.appInfra = nil
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithNilAppInfra")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNil(orderHistory)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithNilSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithNilSiteID")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNil(orderHistory)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithoutLoggingIn() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithoutLoggingIn")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNil(orderHistory)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithInvalidToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithInvalidToken")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNil(orderHistory)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistoryInvalid")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithInvalidJson")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNil(orderHistory)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 333, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchOrderHistoryWithUncaughtError")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNil(orderHistory)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 333)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchOrderHistoryForNonHybris() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testFetchOrderHistoryForNonHybris")
        ecsService.fetchOrderHistory { (orderHistory, error) in
            XCTAssertNil(orderHistory)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
