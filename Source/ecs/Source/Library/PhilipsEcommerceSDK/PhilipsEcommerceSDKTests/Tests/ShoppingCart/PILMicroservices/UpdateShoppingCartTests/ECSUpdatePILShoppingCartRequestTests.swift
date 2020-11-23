/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSUpdatePILShoppingCartRequestTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var serviceDiscoveryMock: ServiceDiscoveryMock!
    var mockSiteID = "testSiteID"
    var mockBaseURL = "https://www.testecs.com"
    var mockLocale = "en_US"
    var mockCountry = "US"
    var mockLanguage = "en"
    var mockAccessToken = "Test token"
    var mockCartId = "current"
    var mockUpdateShoppingCartURL = ""
    var mockProductEntry: ECSPILItem!
    var mockProductEntryNumber = "0"
    var mockQuantity = "2"

    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        serviceDiscoveryMock = ServiceDiscoveryMock()
        mockProductEntry = ECSPILItem()
        mockProductEntry.entryNumber = mockProductEntryNumber

        mockUpdateShoppingCartURL = "https://acc.eu-west-1.api.philips.com/commerce-service/cart/\(mockCartId)/\(mockProductEntryNumber)?siteId=\(mockSiteID)&language=\(mockLanguage)&country=\(mockCountry)&quantity=\(mockQuantity)"
    }

    override func tearDown() {
        super.tearDown()
        mockUpdateShoppingCartURL = ""
        mockProductEntryNumber = ""
        mockCartId = ""
        mockQuantity = ""
        mockAppInfra = nil
        mockRestClient = nil
        serviceDiscoveryMock = nil
        mockProductEntry = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.apiKey = nil
    }
    
    func testUpdateECSShoppingCartSuccessRequest() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUSWithoutVoucher")
        serviceDiscoveryMock.microserviceURL = mockUpdateShoppingCartURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        ECSConfiguration.shared.apiKey = "TestAPIKey"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        
        let testMicro = ECSUpdateShoppingCartMicroServices()
        testMicro.updateECSShoppingCart(cartItem: mockProductEntry, quantity: Int(mockQuantity) ?? 0) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 5)
        XCTAssertNotNil(request?.value(forHTTPHeaderField: ECSConstant.authorization.rawValue))
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(request?.value(forHTTPHeaderField: ECSConstant.apiKey.rawValue), "TestAPIKey")
        XCTAssertEqual(request?.value(forHTTPHeaderField: ECSConstant.authorization.rawValue), mockAccessToken)
        XCTAssertEqual(request?.value(forHTTPHeaderField: ECSConstant.apiVersion.rawValue), ECSConstant.apiVersionValue.rawValue)
        XCTAssertEqual(url?.absoluteString.contains(mockCartId), true)
        XCTAssertEqual(url?.absoluteString.contains(mockProductEntryNumber), true)
        
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.PUT.rawValue)
        
        XCTAssertEqual(queryParams?.count, 4)
        XCTAssertEqual(queryParams["language"] as? String, mockLanguage)
        XCTAssertEqual(queryParams["country"] as? String, mockCountry)
        XCTAssertEqual(queryParams["siteId"] as? String, mockSiteID)
        XCTAssertEqual(queryParams["quantity"] as? String, mockQuantity)
    }
    
    func testUpdateECSShoppingCartRequestForError() {
        serviceDiscoveryMock.microserviceURL = mockUpdateShoppingCartURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.appInfra = mockAppInfra
        ECSConfiguration.shared.hybrisToken = mockAccessToken

        let testMicro = ECSUpdateShoppingCartMicroServices()
        testMicro.updateECSShoppingCart(cartItem: mockProductEntry, quantity: Int(mockQuantity) ?? 0) { (_, _) in }

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
    
    func testUpdateECSShoppingCartServiceDiscoveryEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchCartUSWithoutVoucher")
        serviceDiscoveryMock.microserviceURL = mockUpdateShoppingCartURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        ECSConfiguration.shared.apiKey = "TestAPIKey"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra
        ECSConfiguration.shared.hybrisToken = mockAccessToken

        let testMicro = ECSUpdateShoppingCartMicroServices()
        testMicro.updateECSShoppingCart(cartItem: mockProductEntry, quantity: Int(mockQuantity) ?? 0) { (_, _) in }

        XCTAssertEqual(serviceDiscoveryMock.pilServiceIds?.count, 1)
        XCTAssertEqual(serviceDiscoveryMock.pilServiceIds?.first as? String, "ecs.updateCart")
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?.count, 6)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["cartId"] as? String, mockCartId)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["siteId"] as? String, mockSiteID)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["language"] as? String, mockLanguage)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["country"] as? String, mockCountry)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["entryNumber"] as? String, mockProductEntryNumber)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["quantity"] as? String, mockQuantity)
    }
}
