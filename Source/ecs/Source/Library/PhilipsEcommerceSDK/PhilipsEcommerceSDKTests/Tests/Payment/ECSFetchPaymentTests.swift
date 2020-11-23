/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev


class ECSFetchPaymentTests: XCTestCase {

    var mockAppInfra: MockAppInfra!
    var restClient: RESTClientMock!
    var sut: ECSServices!
    
    override func setUp() {
        super.setUp()
        
        mockAppInfra = MockAppInfra()
        restClient = RESTClientMock()
        mockAppInfra.restClient = restClient
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test_rootCategory"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.hybrisToken = "testHybrisToken"
        ECSConfiguration.shared.baseURL = "testCaseURL"
    }
    
    override func tearDown() {
        mockAppInfra = nil
        restClient = nil
        sut = nil
        
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
        super.tearDown()
    }

    func testFetchPaymentSuccess() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchPaymentSuccess")
        let expectation = self.expectation(description: "testFetchPaymentSuccess")
        sut.fetchPaymentDetails { (paymentList, error) in
            XCTAssertEqual(paymentList?.count, 1)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPaymentSuccessEmptyList() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchPaymentSuccessEmptyList")
        let expectation = self.expectation(description: "testFetchPaymentSuccessEmptyList")
        sut.fetchPaymentDetails { (paymentList, error) in
            XCTAssertNil(paymentList)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchPaymentFailedNoBaseURL() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchPaymentSuccess")
        ECSConfiguration.shared.baseURL = nil
        let expectation = self.expectation(description: "testFetchPaymentFailedNoBaseURL")
        sut.fetchPaymentDetails { (paymentList, error) in
            XCTAssertNil(paymentList)
            XCTAssertTrue(error?.localizedDescription == "Base URL not found")
            XCTAssertTrue((error as NSError?)?.code == 5050)
            expectation.fulfill()
        }
    
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPaymentFailedNotLoggedIn() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchPaymentSuccess")
        ECSConfiguration.shared.hybrisToken = nil
        let expectation = self.expectation(description: "testFetchPaymentFailedNotLoggedIn")
        sut.fetchPaymentDetails { (paymentList, error) in
            XCTAssertNil(paymentList)
            XCTAssertTrue(error?.localizedDescription == "User authorization is required for this action")
            XCTAssertTrue((error as NSError?)?.code == 5057)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPaymentFailedNoSiteId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchPaymentSuccess")
        ECSConfiguration.shared.siteId = nil
        let expectation = self.expectation(description: "testFetchPaymentFailedNoSiteId")
        sut.fetchPaymentDetails { (paymentList, error) in
            XCTAssertNil(paymentList)
            XCTAssertTrue(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssertTrue((error as NSError?)?.code == 5054)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPaymentFailedHybrisTokenExpired() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisTokenExpired")
        restClient.errorData = NSError(domain: "sample", code: 100, userInfo: [:])
        let expectation = self.expectation(description: "testFetchPaymentFailedHybrisTokenExpired")
        
        sut.fetchPaymentDetails { (paymentList, error) in
            XCTAssertNil(paymentList)
            XCTAssertTrue(error?.localizedDescription == "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            XCTAssertTrue((error as NSError?)?.code == 5009)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPaymentFailedRandomError() {
        restClient.responseData = nil
        restClient.errorData = NSError(domain: "sample", code: 100, userInfo: [NSLocalizedDescriptionKey: "Random error"])
        let expectation = self.expectation(description: "testFetchPaymentFailedRandomError")
        sut.fetchPaymentDetails { (paymentList, error) in
            XCTAssertNil(paymentList)
            XCTAssertTrue(error?.localizedDescription == "Random error")
            XCTAssertTrue((error as NSError?)?.code == 100)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPaymentInvalidJson() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchPaymentSuccessInvalidJson")
        let expectation = self.expectation(description: "testMakePaymentFailedNoSiteId")
        sut.fetchPaymentDetails { (paymentList, error) in
            XCTAssertNil(paymentList)
            XCTAssertTrue(error?.localizedDescription == "We have encountered technical glitch. Please try after some time")
            XCTAssertTrue((error as NSError?)?.code == 5999)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}


