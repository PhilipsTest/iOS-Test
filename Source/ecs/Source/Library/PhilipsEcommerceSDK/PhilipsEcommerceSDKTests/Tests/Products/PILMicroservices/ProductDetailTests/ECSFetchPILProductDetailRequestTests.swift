/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
@testable import PhilipsEcommerceSDKDev

class ECSFetchPILProductDetailRequestTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockSiteID = "testSiteID"
    var mockBaseURL = "https://www.testecs.com"
    var mockLocale = "en_US"
    var mockCountry = "US"
    var mockLanguage = "en"
    var serviceDiscoveryMock: ServiceDiscoveryMock!
    var mockProductCTN = "HX3631/06"
    var mockProductDetailURL = ""

    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        serviceDiscoveryMock = ServiceDiscoveryMock()
        mockProductDetailURL = "https://acc.eu-west-1.api.philips.com/commerce-service/product/\(mockProductCTN)?siteId=\(mockSiteID)&language=\(mockLanguage)&country=\(mockCountry)"
    }

    override func tearDown() {
        super.tearDown()
        mockProductDetailURL = ""
        mockAppInfra = nil
        mockRestClient = nil
        serviceDiscoveryMock = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.apiKey = nil
    }
    
    func testFetchPILProductWithCTNRequest() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
//        serviceDiscoveryMock.summaryServiceURL = "https://ecsprxtest.com/PRXSingleProductSuccess"
        serviceDiscoveryMock.microserviceURL = mockProductDetailURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        ECSConfiguration.shared.apiKey = "TestAPIKey"
        
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSProductMicroServices()
        testMicro.fetchECSProductFor(ctn: mockProductCTN) { (_, _) in }
        
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
        
        XCTAssertEqual(queryParams?.count, 3)
        XCTAssertEqual(queryParams["language"] as? String, mockLanguage)
        XCTAssertEqual(queryParams["country"] as? String, mockCountry)
        XCTAssertEqual(queryParams["siteId"] as? String, mockSiteID)
    }

    func testFetchPILProductsWithCTNRequestWithError() {
        serviceDiscoveryMock.microserviceURL = mockProductDetailURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.appInfra = mockAppInfra

        let testMicro = ECSProductMicroServices()
        testMicro.fetchECSProductFor(ctn: mockProductCTN) { (_, _) in }

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
    
    func testFetchPILProductsWithCTNServiceDiscoveryEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "fetchProductPILCTNSuccess")
        serviceDiscoveryMock.microserviceURL = mockProductDetailURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        ECSConfiguration.shared.apiKey = "TestAPIKey"
        
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSProductMicroServices()
        testMicro.fetchECSProductFor(ctn: mockProductCTN) { (_, _) in }
        
        XCTAssertEqual(serviceDiscoveryMock.pilServiceIds?.count, 1)
        XCTAssertEqual(serviceDiscoveryMock.pilServiceIds?.first as? String, "ecs.productDetails")
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?.count, 4)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["siteId"] as? String, mockSiteID)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["language"] as? String, mockLanguage)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["country"] as? String, mockCountry)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["ctn"] as? String, "HX3631_06")
    }
}
