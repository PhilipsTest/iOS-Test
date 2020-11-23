/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSSetDeliveryAddressTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockAddress: ECSAddress!

    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        mockAddress = ECSAddress()
        mockAddress.addressID = "1234"
    }

    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        mockRestClient = nil
        mockAddress = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
    }
    
    func testSetDeliveryAddressSuccess() {
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressSuccess")
        ecsService.setDeliveryAddress(deliveryAddress: mockAddress) { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressBeforeCartCreation() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartNotCreatedError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressBeforeCartCreation")
        ecsService.setDeliveryAddress(deliveryAddress: mockAddress) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "No cart created yet")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithoutOAuth() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithoutOAuth")
        ecsService.setDeliveryAddress(deliveryAddress: mockAddress) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithExpiredHybrisToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testDeleteAddressWithExpiredHybrisToken")
        ecsService.setDeliveryAddress(deliveryAddress: mockAddress) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithNilAppInfra")
        ecsService.setDeliveryAddress(deliveryAddress: mockAddress) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithNilSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithNilSiteID")
        ecsService.setDeliveryAddress(deliveryAddress: mockAddress) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithInvalidAddressID() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "SetDeliveryAddressWrongAddressID")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithInvalidAddressID")
        ecsService.setDeliveryAddress(deliveryAddress: mockAddress) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithNilAddressID() {
        mockAddress.addressID = nil
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithNilAddressID")
        ecsService.setDeliveryAddress(deliveryAddress: mockAddress) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Given address doesn't exist or belong to another user")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 555, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "Test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithUncaughtError")
        ecsService.setDeliveryAddress(deliveryAddress: mockAddress) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 555)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressFetchAllSuccess() {
        mockRestClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressFetchAllSuccess")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertEqual(addresses?.count, 2)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressFetchAllEntries() {
        mockRestClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchAddressSuccess")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressFetchAllEntries")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNotNil(addresses)
            XCTAssertNil(error)
            XCTAssertEqual(addresses?.count, 2)
            XCTAssertNotNil(addresses?.first?.shippingAddress)
            XCTAssertEqual(addresses?.first?.shippingAddress, true)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressBeforeCartCreationForFetchAll() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartNotCreatedError")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressBeforeCartCreationForFetchAll")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "No cart created yet")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithoutOAuthForFetchAll() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithoutOAuthForFetchAll")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithExpiredHybrisTokenForFetchAll() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithExpiredHybrisTokenForFetchAll")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithNilAppInfraForFetchAll() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithNilAppInfraForFetchAll")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithNilSiteIDForFetchAll() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithNilSiteIDForFetchAll")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithInvalidAddressIDForFetchAll() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "SetDeliveryAddressWrongAddressID")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithInvalidAddressIDForFetchAll")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithNilAddressIDForFetchAll() {
        mockAddress.addressID = nil
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithNilAddressIDForFetchAll")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Given address doesn't exist or belong to another user")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithUncaughtErrorForFetchAll() {
        mockRestClient.errorData = NSError(domain: "", code: 555, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "Test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithUncaughtErrorForFetchAll")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 555)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetDeliveryAddressWithFetchFailure() {
        mockRestClient.secondErrorData = NSError(domain: "", code: 555, userInfo: nil)
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testSetDeliveryAddressWithFetchFailure")
        ecsService.setDeliveryAddress(address: mockAddress) { (addresses, error) in
            XCTAssertNil(addresses)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 555)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}
