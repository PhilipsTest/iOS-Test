/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSMakePaymentTests: XCTestCase {

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

    func testMakePaymentSuccess() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "makePaymentSuccess")
        let expectation = self.expectation(description: "testMakePaymentSuccess")

        let order = ECSOrderDetail()
        order.orderID = "123"
        sut.makePaymentFor(order: order, billingAddress: ECSAddress()) { (paymentDetail, error) in
            XCTAssertNotNil(paymentDetail)
            XCTAssertEqual(paymentDetail?.paymentProviderURL,
                           "https://payments-test.worldpay.com/app/hpp/integration/wpg/corporate?OrderKey=PHILIPSUSPUB%5E24013390789-001&Ticket=00156621571712802Ar415ja-_twdu51PisBG2g")
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testMakePaymentFailedBaseURLNil() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "MakePaymentSuccess")
        ECSConfiguration.shared.baseURL = nil
        let expectation = self.expectation(description: "testMakePaymentFailedBaseURLNil")
        
        sut.makePaymentFor(order: ECSOrderDetail(), billingAddress: ECSAddress()) { (paymentDetail, error) in
            XCTAssertNil(paymentDetail)
            XCTAssertTrue(error?.localizedDescription == "Base URL not found")
            XCTAssertTrue((error as NSError?)?.code == 5050)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testMakePaymentFailedNotLoggedIn() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "MakePaymentSuccess")
        ECSConfiguration.shared.hybrisToken = nil
        let expectation = self.expectation(description: "testMakePaymentFailedNotLoggedIn")
        sut.makePaymentFor(order: ECSOrderDetail(), billingAddress: ECSAddress()) { (paymentDetail, error) in
            XCTAssertNil(paymentDetail)
            XCTAssertTrue(error?.localizedDescription == "User authorization is required for this action")
            XCTAssertTrue((error as NSError?)?.code == 5057)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testMakePaymentFailedNoSiteId() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "MakePaymentSuccess")
        ECSConfiguration.shared.siteId = nil
        let expectation = self.expectation(description: "testMakePaymentFailedNoSiteId")
        sut.makePaymentFor(order: ECSOrderDetail(), billingAddress: ECSAddress()) { (paymentDetail, error) in
            XCTAssertNil(paymentDetail)
            XCTAssertTrue(error?.localizedDescription == "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssertTrue((error as NSError?)?.code == 5054)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testMakePaymentFailedOrderIdNil() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "MakePaymentSuccess")
        let expectation = self.expectation(description: "testMakePaymentFailedBaseURLNil")
        
        sut.makePaymentFor(order: ECSOrderDetail(), billingAddress: ECSAddress()) { (paymentDetail, error) in
            XCTAssertNil(paymentDetail)
            XCTAssertTrue(error?.localizedDescription == "Please provide valid order")
            XCTAssertTrue((error as NSError?)?.code == 5060)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testMakePaymentFailedHybrisTokenExpired() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisTokenExpired")
        restClient.errorData = NSError(domain: "sample", code: 100, userInfo: [:])
        let expectation = self.expectation(description: "testMakePaymentFailedNoSiteId")
        let order = ECSOrderDetail()
        order.orderID = "123"
        sut.makePaymentFor(order: order, billingAddress: ECSAddress()) { (paymentDetail, error) in
            XCTAssertNil(paymentDetail)
            XCTAssertTrue(error?.localizedDescription == "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            XCTAssertTrue((error as NSError?)?.code == 5009)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testMakePaymentFailedRandomError() {
        restClient.responseData = nil
        restClient.errorData = NSError(domain: "sample",
                                       code: 100,
                                       userInfo: [NSLocalizedDescriptionKey: "Random error"])
        let expectation = self.expectation(description: "testMakePaymentFailedNoSiteId")
        let order = ECSOrderDetail()
        order.orderID = "123"
        sut.makePaymentFor(order: order, billingAddress: ECSAddress()) { (paymentDetail, error) in
            XCTAssertNil(paymentDetail)
            XCTAssertTrue(error?.localizedDescription == "Random error")
            XCTAssertTrue((error as NSError?)?.code == 100)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testMakePaymentInvalidJson() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "makePaymentSuccessInvalidJson")
        let expectation = self.expectation(description: "testMakePaymentFailedNoSiteId")
        let order = ECSOrderDetail()
        order.orderID = "123"
        sut.makePaymentFor(order: order, billingAddress: ECSAddress()) { (paymentDetail, error) in
            XCTAssertNil(paymentDetail)
            XCTAssertTrue(error?.localizedDescription == "We have encountered technical glitch. Please try after some time")
            XCTAssertTrue((error as NSError?)?.code == 5999)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testMakePaymentOrderCompleted() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "payFailedOrderCompleted")
        restClient.errorData = NSError(domain: "", code: 100, userInfo: [:])
        let expectation = self.expectation(description: "testMakePaymentOrderCompleted")
        let order = ECSOrderDetail()
        order.orderID = "123"
        sut.makePaymentFor(order: order, billingAddress: ECSAddress()) { (paymentDetail, error) in
            XCTAssertNil(paymentDetail)
            XCTAssertTrue(error?.localizedDescription == "Order is already in a paid/completed state")
            XCTAssertTrue((error as NSError?)?.code == 5023)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
