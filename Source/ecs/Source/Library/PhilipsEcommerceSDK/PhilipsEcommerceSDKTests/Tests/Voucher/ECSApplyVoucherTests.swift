/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSApplyVoucherTests: XCTestCase {
    
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
    
    func testApplyVoucherSuccess() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockRestClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherSuccess")
        ecsService.applyVoucher(voucherID: "test Voucher") { (vouchers, error) in
            XCTAssertNotNil(vouchers)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherSuccessEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockRestClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherSuccessEntries")
        ecsService.applyVoucher(voucherID: "test Voucher") { (vouchers, error) in
            XCTAssertNotNil(vouchers)
            XCTAssertNil(error)
            XCTAssertEqual(vouchers?.count, 2)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherBeforeCartCreation() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartNotCreatedError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherBeforeCartCreation")
        ecsService.applyVoucher(voucherID: "test Voucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "No cart created yet")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithBlankCart() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "MaximumDiscountError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherWithBlankCart")
        ecsService.applyVoucher(voucherID: "test Voucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "Sorry, this voucher can\'t be redeemed")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithoutOAuth() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherWithoutOAuth")
        ecsService.applyVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherWithNilAppInfra")
        ecsService.applyVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithNilSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherWithNilSiteID")
        ecsService.applyVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithInvalidHybrisToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherWithInvalidHybrisToken")
        ecsService.applyVoucher(voucherID: "testVoucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithInvalidVoucherID() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidVoucher")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherWithInvalidVoucherID")
        ecsService.applyVoucher(voucherID: "invalid Voucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "Sorry, this voucher can\'t be redeemed")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithDiscountValueCrossingThresholdValue() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "MaximumDiscountError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherWithDiscountValueCrossingThresholdValue")
        ecsService.applyVoucher(voucherID: "test Voucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "Sorry, this voucher can\'t be redeemed")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithFetchVoucherFailure() {
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
        
        let expectation = self.expectation(description: "testApplyVoucherWithFetchVoucherFailure")
        ecsService.applyVoucher(voucherID: "test Voucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 999, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherWithUncaughtError")
        ecsService.applyVoucher(voucherID: "test Voucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertNil(vouchers)
            XCTAssertEqual((error as NSError?)?.code, 999)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testApplyVoucherWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherListInvalid")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testApplyVoucherWithInvalidJson")
        ecsService.applyVoucher(voucherID: "test Voucher") { (vouchers, error) in
            XCTAssertNil(vouchers)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
