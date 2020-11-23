/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSSetPaymentTests: XCTestCase {

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

    func testSetPaymentSuccess() {
        let expectation = self.expectation(description: "testSetPaymentSuccess")
        let payment = ECSPayment()
        payment.paymentId = "123"
        sut.setPaymentDetail(paymentDetail:payment ) { (result, error) in
            XCTAssertTrue(result)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetPaymentFailedPaymentIdNotAvailable() {
        let expectation = self.expectation(description: "testSetPaymentFailedPaymentIdNotAvailable")
        
        sut.setPaymentDetail(paymentDetail:ECSPayment()) { (result, error) in
            XCTAssertFalse(result)
            XCTAssert(error?.localizedDescription == "Please provide valid payment details")
            XCTAssert((error as NSError?)?.code == 5025)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetPaymentFailedPaymentIdInvalid() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidPaymentInformation")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: [:])
        let expectation = self.expectation(description: "testSetPaymentFailedPaymentIdInvalid")
        let payment = ECSPayment()
        payment.paymentId = "123"
        sut.setPaymentDetail(paymentDetail: payment) { (result, error) in
            XCTAssertFalse(result)
            XCTAssert(error?.localizedDescription == "Please provide valid payment details")
            XCTAssert((error as NSError?)?.code == 5025)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetPaymentFailedNoBaseURL() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchPaymentSuccess")
        ECSConfiguration.shared.baseURL = nil
        let expectation = self.expectation(description: "testSetPaymentFailedNoBaseURL")
        sut.setPaymentDetail(paymentDetail: ECSPayment()) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertTrue(error?.localizedDescription == "Base URL not found")
            XCTAssertTrue((error as NSError?)?.code == 5050)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetPaymentFailedNotLoggedIn() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchPaymentSuccess")
        ECSConfiguration.shared.hybrisToken = nil
        let expectation = self.expectation(description: "testSetPaymentFailedNotLoggedIn")
        sut.setPaymentDetail(paymentDetail: ECSPayment()) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertTrue(error?.localizedDescription == "User authorization is required for this action")
            XCTAssertTrue((error as NSError?)?.code == 5057)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetPaymentFailedNoSiteId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchPaymentSuccess")
        ECSConfiguration.shared.siteId = nil
        let expectation = self.expectation(description: "testSetPaymentFailedNoSiteId")
        sut.setPaymentDetail(paymentDetail: ECSPayment()) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertTrue(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssertTrue((error as NSError?)?.code == 5054)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetPaymentFailedHybrisTokenExpired() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisTokenExpired")
        restClient.errorData = NSError(domain: "sample", code: 100, userInfo: [:])
        let expectation = self.expectation(description: "testSetPaymentFailedHybrisTokenExpired")
        let payment = ECSPayment()
        payment.paymentId = "123"
        sut.setPaymentDetail(paymentDetail: payment) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertTrue(error?.localizedDescription == "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            XCTAssertTrue((error as NSError?)?.code == 5009)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetPaymentFailedRandomError() {
        restClient.responseData = nil
        restClient.errorData = NSError(domain: "sample", code: 100, userInfo: [NSLocalizedDescriptionKey: "Random error"])
        let expectation = self.expectation(description: "testSetPaymentFailedRandomError")
        let payment = ECSPayment()
        payment.paymentId = "123"
        sut.setPaymentDetail(paymentDetail: payment) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertTrue(error?.localizedDescription == "Random error")
            XCTAssertTrue((error as NSError?)?.code == 100)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetPaymentFailedNoCartCreated() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartNotCreatedError")
        restClient.errorData = NSError(domain: "sample", code: 100, userInfo: [:])
        let expectation = self.expectation(description: "testSetPaymentFailedNoCartCreated")
        let payment = ECSPayment()
        payment.paymentId = "123"
        sut.setPaymentDetail(paymentDetail: payment) { (result, error) in
            XCTAssertFalse(result)
            XCTAssertTrue(error?.localizedDescription == "No cart created yet")
            XCTAssertTrue((error as NSError?)?.code == 5004)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
