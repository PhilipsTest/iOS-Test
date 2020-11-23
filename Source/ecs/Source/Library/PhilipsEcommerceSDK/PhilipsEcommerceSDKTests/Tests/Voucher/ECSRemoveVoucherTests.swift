/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSRemoveVoucherTests: XCTestCase {
    
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
    
    func testRemoveVoucherSuccess() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockRestClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherSuccess")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNotNil(vouchers)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherSuccessEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockRestClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherSuccessEntries")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNotNil(vouchers)
            XCTAssertNil(error)
            XCTAssertEqual(vouchers?.count, 2)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherBeforeCartCreation() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartNotCreatedError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherBeforeCartCreation")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "No cart created yet")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherBeforeVoucherApplication() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockRestClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherBeforeVoucherApplication")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNotNil(vouchers)
            XCTAssertNil(error)
            XCTAssertEqual(vouchers?.count, 2)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherWithInvalidVoucherID() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherWithInvalidVoucherID")
        ecsService.removeVoucher(voucherID: "test Voucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherWithFetchFailure() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "MaximumDiscountError")
        mockRestClient.secondResponseData = nil
        mockRestClient.secondErrorData = NSError(domain: "", code: 999, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherWithFetchFailure")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherWithBlankCartEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherWithBlankCartEntries")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherWithNilAppInfra")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherWithNilSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherWithNilSiteID")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherWithoutOAuth() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherWithoutOAuth")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherWithInvalidHybrisToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherWithInvalidHybrisToken")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherListInvalid")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherWithInvalidJson")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRemoveVoucherWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 999, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testRemoveVoucherWithUncaughtError")
        ecsService.removeVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual((error as NSError?)?.code, 999)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
