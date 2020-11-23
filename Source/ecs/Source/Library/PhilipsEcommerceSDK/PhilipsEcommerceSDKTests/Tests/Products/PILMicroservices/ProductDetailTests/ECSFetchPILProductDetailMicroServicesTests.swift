/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev
import PhilipsPRXClient

class ECSFetchPILProductDetailsMicroServicesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        ECSConfiguration.shared.baseURL = "https://test.com"
    }

    override func tearDown() {
        super.tearDown()
        ECSConfiguration.shared.baseURL = nil
        ECSUtilityMock.requestManager = nil
    }
    
    func testFetchECSProductForSuccess() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HX3631_06"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchECSProductForSuccess")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNotNil(product)
            XCTAssertEqual(product?.ctn, "HX3631/06")
            XCTAssertNotNil(product?.attributes)
            XCTAssertNotNil(product?.productPRXSummary)
            XCTAssertNotNil(product?.productPRXSummary?.ctn)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductForNonHybrisSuccess() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HX3631/06"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchECSProductForNonHybrisSuccess")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        
        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNotNil(product)
            XCTAssertNil(product?.ctn)
            XCTAssertNil(product?.attributes)
            XCTAssertNotNil(product?.productPRXSummary)
            XCTAssertNotNil(product?.productPRXSummary?.ctn)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductForFailure() {
        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "error", code: ECSHybrisErrorType.ECSsomethingWentWrong.rawValue, userInfo: [NSLocalizedDescriptionKey: "error"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchECSProductForFailure")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductForFailureNonHybris() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HX3631_06"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchECSProductForFailureNonHybris")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNotNil(product)
            XCTAssertNil(error)
            XCTAssertNotNil(product?.productPRXSummary)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductForNoBaseURL() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HX3631_06"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchECSProductForNoBaseURL")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.baseURL = nil
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNotNil(product)
            XCTAssertNil(product?.ctn)
            XCTAssertNil(product?.attributes)
            XCTAssertNotNil(product?.productPRXSummary)
            XCTAssertNotNil(product?.productPRXSummary?.ctn)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductForNoAppInfra() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchECSProductForNoAppInfra")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.appInfra = nil
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSAppInfraNotFound.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductForNoCountry() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HX3631_06"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchECSProductForNoCountry")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.country = nil
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNotNil(product)
            XCTAssertNil(product?.ctn)
            XCTAssertNil(product?.attributes)
            XCTAssertNotNil(product?.productPRXSummary)
            XCTAssertNotNil(product?.productPRXSummary?.ctn)
            XCTAssertNil(error)
            
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductForNoLanguage() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HX3631_06"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchECSProductForNoLanguage")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.language = nil
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNotNil(product)
            XCTAssertNil(product?.ctn)
            XCTAssertNil(product?.attributes)
            XCTAssertNotNil(product?.productPRXSummary)
            XCTAssertNotNil(product?.productPRXSummary?.ctn)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductForNoQueryParams() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoQueryParamsError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductForNoQueryParams")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureForNoLanguageParam() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureForNoLanguageParam")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_language.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureForNoCountryParam() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoCountryError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureForNoCountryParam")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureForNoSiteIDParam() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoSiteIDError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureForNoSiteIDParam")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureForNoAPIKeyHeader() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureForNoAPIKeyHeader")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureForNoAPIVersionHeader() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoVersionError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureForNoAPIVersionHeader")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_VERSION.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWrongSiteIDParam() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidSiteIDError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWrongSiteIDParam")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_siteId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWrongCountryParam() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWrongCountryParam")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWrongLanguageParam() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWrongLanguageParam")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWrongAPIKeyHeader() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWrongAPIKeyHeader")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631_06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_KEY.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWrongAPIVersionHeader() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidVersionError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWrongAPIVersionHeader")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_VERSION.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWithUnavailableCTN() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNotFoundError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWithUnavailableCTN")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631/09") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_NOT_FOUND_productId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWithInvalidCTNRequest() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNWrongFormatError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWithInvalidCTNRequest")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWithBlankCTN() {
        let mockAppInfra = MockAppInfra()
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWithBlankCTN")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_NOT_FOUND_productId.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWithServiceIDNotFound() {
        let mockAppInfra = MockAppInfra()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWithServiceIDNotFound")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWithServiceURLAndServiceErrorNotFound() {
        let mockAppInfra = MockAppInfra()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = nil
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWithServiceURLAndServiceErrorNotFound")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWithServiceURLNotFound() {
        let mockAppInfra = MockAppInfra()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.microserviceURL = nil
        serviceDiscovery.service?.error = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let expectation = self.expectation(description: "testFetchECSProductFailureWithServiceURLNotFound")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"
        
        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), 123)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWithProductSummaryFetchFailure() {
        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey:"Provide Proper CTNs"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let expectation = self.expectation(description: "testFetchECSProductFailureWithProductSummaryFetchFailure")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"

        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Provide Proper CTNs")
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchECSProductFailureWithInvalidProductJson() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidJson")
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let expectation = self.expectation(description: "testFetchECSProductFailureWithInvalidProductJson")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"

        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductFailureWithInvalidErrorJson() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoCountryErrorInvalidJson")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let expectation = self.expectation(description: "testFetchECSProductFailureWithInvalidErrorJson")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"

        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPILProductSummariesForSuccess() {
        let mock = PRXRequestManagerMock()
        let response = getSummaryResponse(ctnList: ["SCF251/02", "S5370/81", "SCF553/23", "SCF792/22", "SCF782/10",
        "SCF782/28", "QP2520/70", "SCF190/01", "SCF190/02", "SCF184/13", "SCF170/22", "DIS363/03"])
        response.invalidCTNs = ["SCF170/22, DIS363/03"]
        mock.response = response
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchProductSummariesForSuccess")
        
        sut.fetchECSProductSummariesFor(ctns: ["SCF251/02", "S5370/81", "SCF553/23", "SCF792/22", "SCF782/10",
        "SCF782/28", "QP2520/70", "SCF190/01", "SCF190/02", "SCF184/13", "SCF170/22", "DIS363/03"]) { (products, ctnList, error) in
            XCTAssertNil(error, "Error")
            XCTAssert(products?.count == 12)
            XCTAssert(ctnList?.first == "SCF170/22, DIS363/03")
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPILProductSummariesWithNoProducts() {
        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "error", code: ECSHybrisErrorType.ECSsomethingWentWrong.rawValue, userInfo: [:])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        
        let expectation = self.expectation(description: "testFetchPILProductSummariesWithNoProducts")
        
        sut.fetchECSProductSummariesFor(ctns: ["SCF251/02", "S5370/81", "SCF553/23", "SCF792/22", "SCF782/10",
        "SCF782/28", "QP2520/70", "SCF190/01", "SCF190/02", "SCF184/13", "SCF170/22", "DIS363/03"]) { (products, ctnList, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(products)
            XCTAssertNil(ctnList)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPILProductForWithNoAPIKeyInConfig() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HX3631_06"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        mockAppInfra.mockConfig?.apiKey = nil
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchPILProductForWithNoAPIKeyInConfig")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        
        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNotNil(product)
            XCTAssertNil(product?.ctn)
            XCTAssertNil(product?.attributes)
            XCTAssertNotNil(product?.productPRXSummary)
            XCTAssertNotNil(product?.productPRXSummary?.ctn)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPILProductForWithBlankAPIKeyInConfig() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HX3631_06"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        let serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        mockAppInfra.mockConfig?.apiKey = ""
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        
        let expectation = self.expectation(description: "testFetchPILProductForWithBlankAPIKeyInConfig")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = nil
        
        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNotNil(product)
            XCTAssertNil(product?.ctn)
            XCTAssertNil(product?.attributes)
            XCTAssertNotNil(product?.productPRXSummary)
            XCTAssertNotNil(product?.productPRXSummary?.ctn)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchPILProductForWithPRXResponseSuccessNilData() {
        let mock = PRXRequestManagerMock()
        let response = PRXSummaryListResponse()
        let data = PRXSummaryData()
        data.ctn = "HX3631_06"
        response.success = false
        mock.response = response
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        mockAppInfra.restClient = restClient
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
        mockAppInfra.serviceDiscovery = serviceDiscovery

        let expectation = self.expectation(description: "testFetchPILProductForWithPRXResponseSuccessNilData")
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.siteId = "testSite"

        sut.fetchECSProductFor(ctn: "HX3631/06") { (product, error) in
            XCTAssertNil(product)
            XCTAssertNil(error)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCommaSeparatedInvalidCTNs() {
        let productDetailMicroService = ECSProductDetailsMicroServices()
        XCTAssertEqual(productDetailMicroService.commaSeparatedInvalidCTNs(invalidCTNs: ["Test1", "Test2"]), "Test1,Test2")
        
        XCTAssertEqual(productDetailMicroService.commaSeparatedInvalidCTNs(invalidCTNs: ["Test1", "  Test2", "Test123   /34"]), "Test1,  Test2,Test123   /34")
        
        XCTAssertEqual(productDetailMicroService.commaSeparatedInvalidCTNs(invalidCTNs: []), "")
        
        XCTAssertEqual(productDetailMicroService.commaSeparatedInvalidCTNs(invalidCTNs: [""]), "")
        
        XCTAssertEqual(productDetailMicroService.commaSeparatedInvalidCTNs(invalidCTNs: [123, 245]), "")
        
        XCTAssertEqual(productDetailMicroService.commaSeparatedInvalidCTNs(invalidCTNs: ["", "ABCD"]), "ABCD")
        
        XCTAssertEqual(productDetailMicroService.commaSeparatedInvalidCTNs(invalidCTNs: ["ABCD", ""]), "ABCD")
        
        XCTAssertEqual(productDetailMicroService.commaSeparatedInvalidCTNs(invalidCTNs: ["   ", "ABCD"]), "ABCD")
    }
}

extension ECSFetchPILProductDetailsMicroServicesTests {
    
    func getSummaryResponse(ctnList: [String]) -> PRXSummaryListResponse {
        let response = PRXSummaryListResponse()
        for ctn in ctnList {
            let data = PRXSummaryData()
            data.ctn = ctn
            response.data.append(data)
        }
        response.success = true
        return response
    }
    
    func swizzleGetPRXRequestManagerMethod() {
        let originalSelector = #selector(ECSUtility.getPRXRequestManager)
        let swizzledSelector = #selector(ECSUtilityMock.getRequestManager)
        if let originalMethod = class_getClassMethod(ECSUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(ECSUtilityMock.self, swizzledSelector) {
                method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func deSwizzleGetPRXRequestManagerMethod() {
        let originalSelector = #selector(ECSUtility.getPRXRequestManager)
        let swizzledSelector = #selector(ECSUtilityMock.getRequestManager)
        if let originalMethod = class_getClassMethod(ECSUtility.self, originalSelector),
            let swizzledMethod = class_getClassMethod(ECSUtilityMock.self, swizzledSelector) {
                method_exchangeImplementations(swizzledMethod, originalMethod)
        }
    }
}

extension Error {
    
    func getErrorCode() -> Int? {
        return (self as NSError).code
    }
}
