/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSSubmitOrderTests: XCTestCase {

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

    func testSubmitOrderSuccess() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "SubmitOrderSuccess")
        let expectation = self.expectation(description: "testFetchPaymentSuccess")
        sut.submitOrder(cvvCode: "123") { (orderDetail, error) in
            XCTAssertNotNil(orderDetail)
            XCTAssertTrue(orderDetail?.orderID == "24013388542")
            XCTAssertTrue(orderDetail?.deliveryAddress?.addressID == "9334682091543")
            XCTAssertEqual(orderDetail?.deliveryMode?.deliveryModeId, "UPS_COLLECTION_POINT")
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSubmitOrderFailedBaseURLNil() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "SubmitOrderSuccess")
        ECSConfiguration.shared.baseURL = nil
        let expectation = self.expectation(description: "testSubmitOrderFailedBaseURLNil")
        sut.submitOrder { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertTrue(error?.localizedDescription == "Base URL not found")
            XCTAssertTrue((error as NSError?)?.code == 5050)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSubmitOrderFailedNotLoggedIn() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "SubmitOrderSuccess")
        ECSConfiguration.shared.hybrisToken = nil
        let expectation = self.expectation(description: "testSubmitOrderFailedNotLoggedIn")
        sut.submitOrder { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertTrue(error?.localizedDescription == "User authorization is required for this action")
            XCTAssertTrue((error as NSError?)?.code == 5057)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSubmitOrderFailedNoSiteId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "SubmitOrderSuccess")
        ECSConfiguration.shared.siteId = nil
        let expectation = self.expectation(description: "testSubmitOrderFailedNoSiteId")
        sut.submitOrder { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertTrue(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssertTrue((error as NSError?)?.code == 5054)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testSubmitOrderFailedHybrisTokenExpired() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisTokenExpired")
        restClient.errorData = NSError(domain: "sample", code: 100, userInfo: [:])
        let expectation = self.expectation(description: "testSubmitOrderFailedNoSiteId")
        sut.submitOrder { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertTrue(error?.localizedDescription == "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            XCTAssertTrue((error as NSError?)?.code == 5009)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSubmitOrderFailedRandomError() {
        restClient.responseData = nil
        restClient.errorData = NSError(domain: "sample", code: 100, userInfo: [NSLocalizedDescriptionKey: "Random error"])
        let expectation = self.expectation(description: "testSubmitOrderFailedNoSiteId")
        sut.submitOrder { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertTrue(error?.localizedDescription == "Random error")
            XCTAssertTrue((error as NSError?)?.code == 100)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSubmitOrderFailedDeliveryModeNotSet() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "SubmitOrderFailedDeliveryModeNotSet")
        restClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let expectation = self.expectation(description: "testSubmitOrderFailedDeliveryModeNotSet")
        sut.submitOrder { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertTrue(error?.localizedDescription == "Please select your delivery address, delivery mode and payment method before submitting an order")
            XCTAssertTrue((error as NSError?)?.code == 5022)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSubmitOrderFailedInvalidJsonData() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "SubmitOrderSuccessInvalidJson")
        let expectation = self.expectation(description: "testSubmitOrderFailedNoSiteId")
        sut.submitOrder { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertTrue(error?.localizedDescription == "We have encountered technical glitch. Please try after some time")
            XCTAssertTrue((error as NSError?)?.code == 5999)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSubmitOrderFailedPaymentAuthorizationFailed() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "submitOrderFailedPaymentAuthorizationFailed")
        restClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let expectation = self.expectation(description: "testSubmitOrderFailedPaymentAuthorizationFailed")
        sut.submitOrder { (orderDetail, error) in
            XCTAssertNil(orderDetail)
            XCTAssertTrue(error?.localizedDescription == "Payment authorization was not successful")
            XCTAssertTrue((error as NSError?)?.code == 5026)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
