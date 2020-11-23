/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchVoucherTests: XCTestCase {
    
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
    
    func testFetchVoucherSuccess() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchVoucherSuccess")
        ecsService.fetchAppliedVouchers { (vouchers, error) in
            XCTAssertNotNil(vouchers)
            XCTAssertNil(error)
            XCTAssertEqual(vouchers?.count, 2)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchVoucherBeforeCartCreation() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartNotCreatedError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchVoucherBeforeCartCreation")
        ecsService.fetchAppliedVouchers { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "No cart created yet")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchVoucherWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchVoucherWithNilAppInfra")
        ecsService.fetchAppliedVouchers { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchVoucherWithoutOAuth() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchVoucherWithoutOAuth")
        ecsService.fetchAppliedVouchers { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchVoucherWithInvalidHybrisToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchVoucherWithInvalidHybrisToken")
        ecsService.fetchAppliedVouchers { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchVoucherWithNilSiteId() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchVoucherWithNilSiteId")
        ecsService.fetchAppliedVouchers { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchVoucherWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherListInvalid")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchVoucherWithInvalidJson")
        ecsService.fetchAppliedVouchers { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchVoucherWithUncaughtError() {
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchVoucherWithUncaughtError")
        ecsService.fetchAppliedVouchers { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
