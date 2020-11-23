/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
import AppInfra
@testable import PhilipsEcommerceSDKDev

class ECSFetchPILProductsRequestTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockSiteID = "testSiteID"
    var mockBaseURL = "https://www.testecs.com"
    var mockLocale = "en_US"
    var mockCountry = "US"
    var mockLanguage = "en"
    var serviceDiscoveryMock: ServiceDiscoveryMock!
    var mockRootCategory = "testRootCategory"
    var mockProductCTN = "HX3631/06"
    var mockProductSearchURL = ""
    
    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        serviceDiscoveryMock = ServiceDiscoveryMock()
        mockProductSearchURL =
        "https://acc.eu-west-1.api.philips.com/commerce-service/product/search?siteId=\(mockSiteID)&language=\(mockLanguage)&country=\(mockCountry)"
    }
    
    override func tearDown() {
        super.tearDown()
        mockProductSearchURL = ""
        mockAppInfra = nil
        mockRestClient = nil
        serviceDiscoveryMock = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.apiKey = nil
    }
    
    func testSearchProductWithoutFilterParameter() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        serviceDiscoveryMock.microserviceURL = mockProductSearchURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        ECSConfiguration.shared.apiKey = "TestAPIKey"
        
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSProductMicroServices()
        let filter = ECSPILProductFilter()
        filter.sortType = .priceAscending
        filter.stockLevels = [.inStock, .outOfStock, .lowStock, .inStock, .lowStock]
        testMicro.fetchECSAllProducts(category: "TestCategory", limit: 1, offset: 1, filterParameter: filter) { (_, _) in}
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
     
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 4)
        XCTAssertNil(request?.value(forHTTPHeaderField: "Authorization"))
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(request?.value(forHTTPHeaderField: ECSConstant.apiKey.rawValue), "TestAPIKey")
        XCTAssertEqual(request?.value(forHTTPHeaderField: ECSConstant.apiVersion.rawValue), ECSConstant.apiVersionValue.rawValue)
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.GET.rawValue)
        XCTAssertEqual(queryParams["country"] as? String, "US")
        XCTAssertEqual(queryParams["category"] as? String, "TestCategory")
        XCTAssertEqual(queryParams["offset"] as? String, "1")
        XCTAssertEqual(queryParams["limit"] as? String, "1")
        XCTAssertEqual(queryParams["siteId"] as? String, "testSiteID")
        XCTAssertEqual(queryParams["language"] as? String, "en")
        XCTAssertEqual((queryParams["stockLevel"] as? String)?.components(separatedBy: ",").count, 3)
        XCTAssertEqual(queryParams["sort"] as? String, "price")
    }
    
    func testSearchProductWithoutFilterParameterWithError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "PILProductSearch")
        serviceDiscoveryMock.microserviceURL = mockProductSearchURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        ECSConfiguration.shared.apiKey = "TestAPIKey"
        
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSProductMicroServices()
        let filter = ECSPILProductFilter()
        filter.sortType = .priceAscending
        filter.stockLevels = [.inStock]
        testMicro.fetchECSAllProducts(category: "TestCategory", limit: 1, offset: 1, filterParameter: filter) { (_, _) in}
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNil(request)
        XCTAssertNil(url)
        XCTAssertNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNil(request?.allHTTPHeaderFields)
        XCTAssertNil(request?.httpMethod)
    }
}

