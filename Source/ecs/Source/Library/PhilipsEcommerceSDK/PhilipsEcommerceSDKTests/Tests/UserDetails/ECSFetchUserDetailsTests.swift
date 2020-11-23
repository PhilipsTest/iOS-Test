/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchUserDetailsTests: XCTestCase {
    
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
    
    func testFetchUserDetailsSuccess() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchUserDetailsSuccess")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchUserDetailsSuccess")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNotNil(userDetails)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchUserDetailsEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchUserDetailsSuccess")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchUserDetailsEntries")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNotNil(userDetails)
            XCTAssertNil(error)
            XCTAssertNotNil(userDetails?.defaultAddress)
            XCTAssertNotNil(userDetails?.janrainUUID)
            XCTAssertNotNil(userDetails?.fullName)
            XCTAssertNotNil(userDetails?.lastName)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchUserDetailsForNewUser() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchUserDetailsSuccess")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchUserDetailsEntries")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNotNil(userDetails)
            XCTAssertNil(error)
            XCTAssertNotNil(userDetails?.defaultAddress)
            XCTAssertNotNil(userDetails?.janrainUUID)
            XCTAssertNotNil(userDetails?.fullName)
            XCTAssertNotNil(userDetails?.lastName)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchUserDetailsWithNilAppInfra() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchUserDetailsWithNilAppInfra")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNil(userDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchUserDetailsWithoutLogin() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchUserDetailsWithoutLogin")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNil(userDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "User authorization is required for this action")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchUserDetailsWithInvalidHybrisToken() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "InvalidHybrisToken")
        mockRestClient.errorData = NSError(domain: "", code: 123, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchUserDetailsWithInvalidHybrisToken")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNil(userDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid access token). Please do Hybris Re-Auth")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchUserDetailsWithInvalidJson() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchUserDetailsInvalid")
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchUserDetailsWithInvalidJson")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNil(userDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchUserDetailsWithUncaughtError() {
        mockRestClient.errorData = NSError(domain: "", code: 333, userInfo: [NSLocalizedDescriptionKey:""])
        mockAppInfra.restClient = mockRestClient
        
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.hybrisToken = "test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchUserDetailsWithUncaughtError")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNil(userDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError?)?.code, 333)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchUserDetailsWithNilSiteID() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = "https://test.com"
        
        let expectation = self.expectation(description: "testFetchUserDetailsWithNilSiteID")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNil(userDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchUserDetailsForNonHybris() {
        let ecsService = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = "Test token"
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testFetchUserDetailsForNonHybris")
        ecsService.fetchUserProfile { (userDetails, error) in
            XCTAssertNil(userDetails)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}

