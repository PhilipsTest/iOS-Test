/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSNotifyProductAvailibilityTests: XCTestCase {
    
    var mockEmail = "test@test.com"
    var mockCTN = "HX3631/06"

    override func setUp() {
        super.setUp()
        ECSConfiguration.shared.baseURL = "https://test.com"
    }

    override func tearDown() {
        super.tearDown()
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.apiKey = nil
    }
    
    func testRegisterForProductAvailabilitySuccess() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccess")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilitySuccess")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilitySuccessWith_InCTN() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccess")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilitySuccessWith_InCTN")
        serivces.registerForProductAvailability(email: mockEmail, ctn: "HX3631_06") { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilitySuccessResponseWithFalse() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccessFalse")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilitySuccessResponseWithFalse")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityFailure() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityFailure")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityFailureWithInvalidJson() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccessInvalidJson")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityFailureWithInvalidJson")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithNilSiteId() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithNilSiteId")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithBlankSiteId() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoSiteIDError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = ""
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithBlankSiteId")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithWrongSiteId() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidSiteIDError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithWrongSiteId")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithNilAPIKey() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.apiKey = nil
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithNilAPIKey")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithBlankAPIKey() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithBlankAPIKey")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithWrongAPIKey() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithWrongAPIKey")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithNilLanguage() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.language = nil
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithNilLanguage")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_language.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithBlankLanguage() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccess")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.language = ""
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithBlankLanguage")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithNilCountry() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.country = nil
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithNilCountry")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithBlankCountry() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccess")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.country = ""
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithBlankCountry")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithNilAppInfra() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.appInfra = nil
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithNilAppInfra")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSAppInfraNotFound.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithBlankEmailId() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithNilAppInfra")
        serivces.registerForProductAvailability(email: "", ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_Email.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithInvalidEmailId() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithNilAppInfra")
        serivces.registerForProductAvailability(email: "abcd", ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_Email.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithInvalidEmailIdFromPIL() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationInvalidEmail")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithInvalidEmailIdFromPIL")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_Email.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithInvalidCTNLocalCheck() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithInvalidCTNLocalCheck")
        serivces.registerForProductAvailability(email: mockEmail, ctn: "  ABCD/  EF") { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_NOT_FOUND_productId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithBlankCTN() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithBlankCTN")
        serivces.registerForProductAvailability(email: mockEmail, ctn: "   ") { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_NOT_FOUND_productId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithInvalidCTN() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "CartInvalidProductId")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithInvalidCTN")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_productId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityForNonHybris() {
        let mockAppInfra = MockAppInfra()
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        ECSConfiguration.shared.baseURL = nil
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityForNonHybris")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSBaseURLNotFound.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithServiceDiscoveryError() {
        let mockAppInfra = MockAppInfra()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithServiceDiscoveryError")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithServiceDiscoveryServiceError() {
        let mockAppInfra = MockAppInfra()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = nil
        serviceDiscovery.service?.error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithServiceDiscoveryServiceError")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithServiceDiscoveryNilURL() {
        let mockAppInfra = MockAppInfra()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = nil
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithServiceDiscoveryNilURL")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithNilDataAndNoError() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithNilDataAndNoError")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithBlankData() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccessWithBlankData")
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithBlankData")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRegisterForProductAvailabilityWithBlankError() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccessWithBlankData")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let serivces = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "test"
        
        let expectation = self.expectation(description: "testRegisterForProductAvailabilityWithBlankError")
        serivces.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (success, error) in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testIsValidEmail() {
        var email = mockEmail
        XCTAssertTrue(email.isValidEmail())
        
        email = "   \(mockEmail)   "
        XCTAssertTrue(email.isValidEmail())
        
        email = ""
        XCTAssertFalse(email.isValidEmail())
        
        email = "   "
        XCTAssertFalse(email.isValidEmail())
        
        email = "test   @test.com"
        XCTAssertFalse(email.isValidEmail())
        
        email = "test@."
        XCTAssertFalse(email.isValidEmail())
        
        email = "test@abcd."
        XCTAssertFalse(email.isValidEmail())
        
        email = "test_abcd@ab.com"
        XCTAssertTrue(email.isValidEmail())
        
        email = "test@abcd@ab.com"
        XCTAssertFalse(email.isValidEmail())
    }
}
