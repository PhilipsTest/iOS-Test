/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSPILCreateShoppingCartRequestTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockSiteID = "testSiteID"
    var mockBaseURL = "https://www.testecs.com"
    var mockLocale = "en_US"
    var mockCountry = "US"
    var mockLanguage = "en"
    var serviceDiscoveryMock: ServiceDiscoveryMock!
    var mockProductCTN = "HX3631/06"
    var quantity = 1
    
    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        serviceDiscoveryMock = ServiceDiscoveryMock()
    }

    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        mockRestClient = nil
        serviceDiscoveryMock = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.apiKey = nil
        ECSConfiguration.shared.hybrisToken = nil
    }
    
    func testCreateCartRequest() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUS")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        ECSConfiguration.shared.apiKey = "TestAPIKey"
        
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra
        ECSConfiguration.shared.hybrisToken = "abcd"
        ECSConfiguration.shared.country = mockCountry
        ECSConfiguration.shared.language = mockLanguage
        
        serviceDiscoveryMock.microserviceURL = "https://acc.eu-west-1.api.philips.com/commerce-service/cart?siteId=\(ECSConfiguration.shared.siteId ?? "")&language=\(ECSConfiguration.shared.language ?? "")&country=\(ECSConfiguration.shared.country ?? "")&quantity=\(quantity)&productId=\(mockProductCTN)"
        
        let testMicro = ECSCreateShoppingCartMicroServices()
        testMicro.createECSShoppingCart(ctn: mockProductCTN, quantity: quantity) { (cart, error) in }
        
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 5)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), "abcd")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(request?.value(forHTTPHeaderField: ECSConstant.apiKey.rawValue), "TestAPIKey")
        XCTAssertEqual(request?.value(forHTTPHeaderField: ECSConstant.apiVersion.rawValue), ECSConstant.apiVersionValue.rawValue)
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.POST.rawValue)
        XCTAssertEqual(queryParams["country"] as? String, "US")
        XCTAssertEqual(queryParams["siteId"] as? String, "testSiteID")
        XCTAssertEqual(queryParams["language"] as? String, "en")
        XCTAssertEqual(queryParams["productId"] as? String, "HX3631/06")
        XCTAssertEqual(queryParams["quantity"] as? String, "1")
    }
    
    func testCreateCartRequestWithoutOauth() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUS")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        ECSConfiguration.shared.apiKey = "TestAPIKey"
        
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra
        ECSConfiguration.shared.country = mockCountry
        ECSConfiguration.shared.language = mockLanguage
        
        serviceDiscoveryMock.microserviceURL = "https://acc.eu-west-1.api.philips.com/commerce-service/cart?siteId=\(ECSConfiguration.shared.siteId ?? "")&language=\(ECSConfiguration.shared.language ?? "")&country=\(ECSConfiguration.shared.country ?? "")&quantity=\(quantity)&productId=\(mockProductCTN)"
        
        let testMicro = ECSCreateShoppingCartMicroServices()
        testMicro.createECSShoppingCart(ctn: mockProductCTN, quantity: quantity) { (cart, error) in }
        
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNil(url)
        XCTAssertNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNil(request?.allHTTPHeaderFields)
        XCTAssertNil(request?.httpMethod)
    }
    
    func testCreateCartServiceDiscoveryEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUS")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        ECSConfiguration.shared.apiKey = "TestAPIKey"
        
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra
        ECSConfiguration.shared.hybrisToken = "abcd"
        ECSConfiguration.shared.country = mockCountry
        ECSConfiguration.shared.language = mockLanguage
        
        serviceDiscoveryMock.microserviceURL = "https://acc.eu-west-1.api.philips.com/commerce-service/cart?siteId=\(ECSConfiguration.shared.siteId ?? "")&language=\(ECSConfiguration.shared.language ?? "")&country=\(ECSConfiguration.shared.country ?? "")&quantity=\(quantity)&productId=\(mockProductCTN)"
        
        let testMicro = ECSCreateShoppingCartMicroServices()
        testMicro.createECSShoppingCart(ctn: mockProductCTN, quantity: quantity) { (_, _) in }
        
        XCTAssertEqual(serviceDiscoveryMock.pilServiceIds?.count, 1)
        XCTAssertEqual(serviceDiscoveryMock.pilServiceIds?.first as? String, "ecs.createCart")
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?.count, 5)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["siteId"] as? String, mockSiteID)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["language"] as? String, mockLanguage)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["country"] as? String, mockCountry)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["ctn"] as? String, mockProductCTN)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["quantity"] as? String, "\(quantity)")
    }
}
