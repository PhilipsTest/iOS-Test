/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchDeliveryModesTests: XCTestCase {
    
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
    
    func testFetchDeliveryModeSuccess() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchDeliveryModeList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeSuccess")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNotNil(deliveryModes)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDeliveryModeSuccessEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchDeliveryModeList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeSuccessEntries")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNotNil(deliveryModes)
            XCTAssertNil(error)
            XCTAssertEqual(deliveryModes?.count, 3)
            XCTAssertNotNil(deliveryModes?.first?.deliveryModeId)
            XCTAssertNil(deliveryModes?.first?.deliveryCost)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDeliveryModeRequestLogging() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchDeliveryModeList")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        ecsService.fetchDeliveryModes { (_, _) in }
        XCTAssertEqual(mockAppInfra.mockLogger.logLevel, .verbose)
        XCTAssertEqual(mockAppInfra.mockLogger.logEventID, "ECSRequest")
        XCTAssertEqual(mockAppInfra.mockLogger.logMessage?.contains("https://test.com"), true)
    }
    
    func testFetchDeliveryModeRequestCatchLogging() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchDeliveryModeListInvalid")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        ecsService.fetchDeliveryModes { (_, _) in }
        XCTAssertEqual(mockAppInfra.mockLogger.logLevel, .verbose)
        XCTAssertEqual(mockAppInfra.mockLogger.logEventID, "ECSParsingError")
        XCTAssertEqual(mockAppInfra.mockLogger.logMessage?.contains("The data couldn’t be read because it isn’t in the correct format."), true)
    }
    
    func testFetchDeliveryModeBeforeCartCreation() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartNotCreatedError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeBeforeCartCreation")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNil(deliveryModes)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "No cart created yet")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDeliveryModeBeforeOAuth() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeBeforeOAuth")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNil(deliveryModes)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDeliveryModeWithExpiredToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeWithExpiredToken")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNil(deliveryModes)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDeliveryModeWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeWithNilAppInfra")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNil(deliveryModes)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDeliveryModeWithNilSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeWithNilSiteID")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNil(deliveryModes)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDeliveryModeWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchDeliveryModeListInvalid")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeWithInvalidJson")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNil(deliveryModes)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDeliveryModeWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 333, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeWithUncaughtError")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNil(deliveryModes)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 333)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchDeliveryModeWithPickupPoint() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchDeliveryModeListWithPickupPoint")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchDeliveryModeWithPickupPoint")
        ecsService.fetchDeliveryModes { (deliveryModes, error) in
            XCTAssertNotNil(deliveryModes)
            XCTAssertEqual(deliveryModes?.count, 2)
            XCTAssertEqual(deliveryModes?.contains(where: { $0.pickupPoint == true }), false)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchNonPickupDeliveryModes() {
        let deliveryModes = ECSDeliveryModes()
        let deliveryMode1 = ECSDeliveryMode()
        deliveryMode1.deliveryModeId = "Collection Point"
        deliveryMode1.pickupPoint = true
        let deliveryMode2 = ECSDeliveryMode()
        deliveryMode2.deliveryModeId = "Collection Point New"
        deliveryMode2.pickupPoint = true
        let deliveryMode3 = ECSDeliveryMode()
        deliveryMode3.deliveryModeId = "Delivery Mode"
        let deliveryMode4 = ECSDeliveryMode()
        deliveryMode4.deliveryModeId = "Home Delivery"
        deliveryMode4.pickupPoint = false
        
        deliveryModes.deliveryModes = [deliveryMode1, deliveryMode3, deliveryMode2, deliveryMode4]
        
        var fetchedDeliveryModes: [ECSDeliveryMode]? = deliveryModes.fetchNonPickupDeliveryModes()
        XCTAssertNotNil(fetchedDeliveryModes)
        XCTAssertEqual(fetchedDeliveryModes?.count, 2)
        XCTAssertEqual(fetchedDeliveryModes?.contains(where: { $0.pickupPoint == true }), false)
        XCTAssertEqual(fetchedDeliveryModes?.first, deliveryMode3)
        
        deliveryModes.deliveryModes = [deliveryMode3]
        fetchedDeliveryModes = deliveryModes.fetchNonPickupDeliveryModes()
        XCTAssertNotNil(fetchedDeliveryModes)
        XCTAssertEqual(fetchedDeliveryModes?.count, 1)
        XCTAssertEqual(fetchedDeliveryModes?.first, deliveryMode3)
        
        deliveryModes.deliveryModes = [deliveryMode1, deliveryMode2]
        fetchedDeliveryModes = deliveryModes.fetchNonPickupDeliveryModes()
        XCTAssertNotNil(fetchedDeliveryModes)
        XCTAssertEqual(fetchedDeliveryModes?.count, 0)
        
        deliveryModes.deliveryModes = []
        fetchedDeliveryModes = deliveryModes.fetchNonPickupDeliveryModes()
        XCTAssertNotNil(fetchedDeliveryModes)
        XCTAssertEqual(fetchedDeliveryModes?.count, 0)
        
        deliveryModes.deliveryModes = nil
        fetchedDeliveryModes = deliveryModes.fetchNonPickupDeliveryModes()
        XCTAssertNil(fetchedDeliveryModes)
    }

}
