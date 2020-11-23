/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev
import PhilipsPRXClient

class ECSFetchPILProductsMicroServicesTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var restClient: RESTClientMock!
    var serviceDiscovery: ServiceDiscoveryMock!
    
    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        restClient = RESTClientMock()
        serviceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.restClient = restClient
        mockAppInfra.serviceDiscovery = serviceDiscovery
        serviceDiscovery.microserviceURL = "https://test.com/microservices"
    }
    
    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        restClient = nil
        serviceDiscovery = nil
        ECSUtilityMock.requestManager = nil
    }

    func testFetchECSProductsForBadRequest() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILSearchProductBadRequest")
        restClient.errorData = NSError(domain: "", code: 1, userInfo: [:])
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchECSProductsForBadRequest")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: filter) { (products, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(products)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            XCTAssertEqual(error?.getErrorCode(), 6013)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForSuccess() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30", "HR2052/00", "HR2199/00", "HR3865/00"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
    
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchECSProductsForSuccess")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: filter) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 5)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsFailedInvalidJson() {
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch_invalidJSON")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchECSProductsFailedInvalidJson")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: filter) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            XCTAssertEqual(error?.getErrorCode(), 5999)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForSuccessEmptyProductList() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearchEmptyResponse")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        let expectation = self.expectation(description: "testFetchECSProductsForSuccessEmptyProductList")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: nil) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 0)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForFailureNoInternet() {
        restClient.errorData = NSError(domain: "no internet", code: 100, userInfo: [NSLocalizedDescriptionKey: "No internet error"])
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        let expectation = self.expectation(description: "testFetchECSProductsForFailureNoInternet")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: nil) { (products, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(products)
            XCTAssertEqual(error?.localizedDescription, "No internet error")
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForFailureSomethingWentWrong() {
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        let expectation = self.expectation(description: "testFetchECSProductsForFailureSomethingWentWrong")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: nil) { (products, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(products)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForSuccessPRXSummaryAPIFails() {

        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "error", code: 100, userInfo: [NSLocalizedDescriptionKey: "error occured"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        let expectation = self.expectation(description: "testFetchECSProductsForSuccessPRXSummaryAPIFails")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: nil) { (products, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(products)
            XCTAssertNil(products?.products?.first?.productPRXSummary)
            XCTAssertEqual((error as NSError?)?.localizedDescription, "error occured")
            self.deSwizzleGetPRXRequestManagerMethod()

            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForSuccessPRXSummaryAPIFailsPartialErrorJson() {
        let mock = PRXRequestManagerMock()
        mock.error = NSError(domain: "error", code: 404, userInfo: [NSLocalizedDescriptionKey: "Provide Proper CTNs"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        let expectation = self.expectation(description: "testFetchECSProductsForSuccessPRXSummaryAPIFailsPartialErrorJson")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertEqual(error?.localizedDescription, "Provide Proper CTNs")
            XCTAssertEqual(error?.getErrorCode(), 404)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsAppinfraIsNil() {
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.appInfra = nil
        let expectation = self.expectation(description: "testFetchECSProductsAppinfraIsNil")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertEqual(error?.localizedDescription, "Please provide app infra object")
            XCTAssertEqual(error?.getErrorCode(), 5051)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsServiceDiscoveryWithoutURL() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "testsite"
        ECSConfiguration.shared.country = "testCountry"
        serviceDiscovery.microserviceURL = nil
        let expectation = self.expectation(description: "testFetchECSProductsServiceDiscoveryWithoutURL")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSsomethingWentWrong.rawValue)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsHybrisNotAvailable() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchECSProductsHybrisNotAvailable")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: filter) { (products, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(products)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            XCTAssertEqual(error?.getErrorCode(), 5055)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsSiteIdEmpty() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = ""
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoSiteIDError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsSiteIdEmpty")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_siteId.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsSiteIdInvalid() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = ""
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidSiteIDError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsSiteIdInvalid")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_siteId.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Philips shop is not available for the selected country, only retailer mode is available")
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsCountryCodeEmpty() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = ""
        ECSConfiguration.shared.country = nil
        ECSConfiguration.shared.language = "testLanguage"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoCountryError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsCountryCodeEmpty")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_country.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Please set the locale")
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsLanguageCodeEmpty() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = ""
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = nil
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsLanguageCodeEmpty")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_PARAMETER_language.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Please set the locale")
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsLanguageCodeInvalid() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "testSiteID"
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsLanguageCodeInvalid")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Please set the locale")
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsCountryCodeInvalid() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "testSiteID"
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidCountryLanguageError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsCountryCodeInvalid")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_locale.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Please set the locale")
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsCategoryIsInvalid() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearchEmptyResponse")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        let expectation = self.expectation(description: "testFetchECSProductsCategoryIsInvalid")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: nil) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 0)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsCategoryIsEmpty() {
        
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30", "HR2052/00", "HR2199/00", "HR3865/00"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchECSProductsCategoryIsEmpty")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: filter) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 5)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    func testFetchECSProductsOffsetTooBig() {
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearchEmptyResponse")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        let expectation = self.expectation(description: "testFetchECSProductsOffsetTooBig")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: nil) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 0)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsOffsetEmtpy() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30", "HR2052/00", "HR2199/00", "HR3865/00"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchECSProductsOffsetEmtpy")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: filter) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 5)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsLimitTooBig() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30", "HR2052/00", "HR2199/00", "HR3865/00"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchECSProductsLimitTooBig")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: filter) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 5)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsLimitEmpty() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30", "HR2052/00", "HR2199/00", "HR3865/00"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchECSProductsLimitEmpty")
        sut.fetchECSProducts(category: nil, limit: 4, offset: 4, filterParameter: filter) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 5)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForNoAPIKeyConfig() {
        mockAppInfra.mockConfig.apiKey = nil
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        let expectation = self.expectation(description: "testFetchECSProductsForNoAPIKeyConfig")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForBlankAPIKeyConfig() {
        mockAppInfra.mockConfig.apiKey = ""
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNNoAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsForBlankAPIKeyConfig")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_KEY.rawValue)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForInvalidAPIKeyConfig() {
        mockAppInfra.mockConfig.apiKey = "2o93hr2l3"
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidAPIKeyError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsForInvalidAPIKeyConfig")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Invalid API key")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_KEY.rawValue)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForEmptyVersion() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "searchProductMissingAPIVersion")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsForEmptyVersion")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "The required API version header is missing")
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_MISSING_API_VERSION.rawValue)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForInvalidVersion() {
        mockAppInfra.mockConfig.apiKey = ""
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNInvalidVersionError")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsForInvalidVersion")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_API_VERSION.rawValue)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForInvalidLimit() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch_InvalidLimit")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsForInvalidLimit")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_limit.rawValue)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsForInvalidOffset() {
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.baseURL = "test.com"
        ECSConfiguration.shared.siteId = "TestSiteID"
        ECSConfiguration.shared.country = "testCountry"
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch_InvalidOffset")
        restClient.errorData = NSError(domain: "", code: 123, userInfo: nil)
        let expectation = self.expectation(description: "testFetchECSProductsForInvalidOffset")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertNil(products)
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PARAMETER_VALUE_offset.rawValue)
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchECSProductsLimitMoreThanThreashold() {
        let sut = ECSServices(appInfra: mockAppInfra)
        let expectation = self.expectation(description: "testFetchECSProductsLimitMoreThanThreashold")
        sut.fetchECSProducts(category: nil, limit: 60, offset: 0, filterParameter: nil) { (products, error) in
            XCTAssertEqual(error?.getErrorCode(), ECSHybrisErrorType.ECSPIL_INVALID_PRODUCT_SEARCH_LIMIT.rawValue)
            XCTAssertEqual(error?.localizedDescription, "Product search limit cannot be more than 50")
            expectation.fulfill()
        }
         waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchProductsWithBlankCTNsInResponse() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30", "HR2052/00", "HR2199/00", "HR3865/00", "HR3865/40", "HR3865/10"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
    
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch_BlankCTN")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchProductsWithBlankCTNsInResponse")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: filter) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 5)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchProductsWithBlankSummary() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2098/30"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
    
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchProductsWithBlankSummary")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: filter) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 2)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchProductsWithBlankSummaryAndBlankSummary() {
        let mock = PRXRequestManagerMock()
        mock.response = getSummaryResponse(ctnList: ["HR3657/90", "HR2199/00", "HR3865/00", "HR3865/40"])
        ECSUtilityMock.requestManager = mock
        swizzleGetPRXRequestManagerMethod()
    
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch_BlankCTN")
        
        let sut = ECSServices(appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "de_DE"
        ECSConfiguration.shared.siteId = "testSite"
        ECSConfiguration.shared.country = "testCountry"
        ECSConfiguration.shared.language = "TestLanguage"
        ECSConfiguration.shared.baseURL = "test.com"
        
        let filter = ECSPILProductFilter()
        filter.sortType = .discountPriceAscending
        filter.stockLevels = [.inStock]
        let expectation = self.expectation(description: "testFetchProductsWithBlankSummaryAndBlankSummary")
        sut.fetchECSProducts(category: nil, limit: 10, offset: 0, filterParameter: filter) { (products, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(products)
            XCTAssertEqual(products?.products?.count, 3)
            self.deSwizzleGetPRXRequestManagerMethod()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSetUpECSProductData() {
        let productMicroService = ECSProductMicroServices()
        var mockProductSummaries = getSummaryResponse(ctnList: ["CTN1", "CTN2", "CTN3"]).data as? [PRXSummaryData] ?? []
        
        let mockProducts = ECSPILProducts()
        
        let mockProduct1 = ECSPILProduct()
        mockProduct1.ctn = "CTN1"
        
        let mockProduct2 = ECSPILProduct()
        mockProduct2.ctn = "CTN2"
        
        let mockProduct3 = ECSPILProduct()
        mockProduct3.ctn = "CTN3"
        
        mockProducts.products = [mockProduct1, mockProduct2, mockProduct3]
        productMicroService.setUpECSProductData(for: mockProducts, with: mockProductSummaries)
        
        XCTAssertEqual(mockProducts.products?.count, 3)
        
        mockProduct3.ctn = ""
        mockProducts.products = [mockProduct1, mockProduct2, mockProduct3]
        productMicroService.setUpECSProductData(for: mockProducts, with: mockProductSummaries)
        XCTAssertEqual(mockProducts.products?.count, 2)
        XCTAssertEqual(mockProducts.products?.contains(mockProduct3), false)
        
        mockProduct3.ctn = nil
        mockProducts.products = [mockProduct1, mockProduct2, mockProduct3]
        productMicroService.setUpECSProductData(for: mockProducts, with: mockProductSummaries)
        XCTAssertEqual(mockProducts.products?.count, 2)
        XCTAssertEqual(mockProducts.products?.contains(mockProduct3), false)
        
        mockProduct3.ctn = "CTN3"
        mockProducts.products = [mockProduct1, mockProduct2, mockProduct3]
        mockProductSummaries = getSummaryResponse(ctnList: ["CTN1", "CTN2", "CTN3", "CTN5"]).data as? [PRXSummaryData] ?? []
        productMicroService.setUpECSProductData(for: mockProducts, with: mockProductSummaries)
        XCTAssertEqual(mockProducts.products?.count, 3)
        XCTAssertEqual(mockProducts.products?.contains(mockProduct3), true)
        XCTAssertEqual(mockProducts.products?.contains(where: { $0.ctn == "CTN5" }), false)
        
        mockProduct3.ctn = nil
        mockProducts.products = [mockProduct1, mockProduct2, mockProduct3]
        mockProductSummaries = getSummaryResponse(ctnList: ["CTN1", "CTN5"]).data as? [PRXSummaryData] ?? []
        productMicroService.setUpECSProductData(for: mockProducts, with: mockProductSummaries)
        XCTAssertEqual(mockProducts.products?.count, 1)
        XCTAssertEqual(mockProducts.products?.contains(mockProduct3), false)
        XCTAssertEqual(mockProducts.products?.contains(mockProduct2), false)
        XCTAssertEqual(mockProducts.products?.contains(mockProduct1), true)
        XCTAssertEqual(mockProducts.products?.contains(where: { $0.ctn == "CTN5" }), false)
        XCTAssertNotNil(mockProduct1.productPRXSummary)
        
        mockProducts.products = nil
        productMicroService.setUpECSProductData(for: mockProducts, with: mockProductSummaries)
        XCTAssertNil(mockProducts.products)
    }
}

extension ECSFetchPILProductsMicroServicesTests {
    
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
