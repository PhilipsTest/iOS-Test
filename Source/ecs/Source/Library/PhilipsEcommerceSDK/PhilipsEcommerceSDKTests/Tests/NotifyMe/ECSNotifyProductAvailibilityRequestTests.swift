/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSNotifyProductAvailibilityRequestTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var serviceDiscoveryMock: ServiceDiscoveryMock!
    var mockSiteID = "testSiteID"
    var mockBaseURL = "https://www.testecs.com"
    var mockLocale = "en_US"
    var mockCountry = "US"
    var mockLanguage = "en"
    var mockNotifyMeURL = ""
    var mockEmail = "test@test.com"
    var mockCTN = "HX3631/06"

    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        serviceDiscoveryMock = ServiceDiscoveryMock()
        mockNotifyMeURL = "https://acc.eu-west-1.api.philips.com/commerce-service/product/notifyMe?siteId=\(mockSiteID)"
    }

    override func tearDown() {
        super.tearDown()
        mockNotifyMeURL = ""
        mockAppInfra = nil
        mockRestClient = nil
        serviceDiscoveryMock = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
        ECSConfiguration.shared.apiKey = nil
    }
    
    func testRegisterForProductAvailabilitySuccessRequest() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccess")
        serviceDiscoveryMock.microserviceURL = mockNotifyMeURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        ECSConfiguration.shared.apiKey = "TestAPIKey"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra

        let testMicro = ECSNotifyProductAvailibilityMicroservices()
        testMicro.registerForProductAvailability(email: mockEmail, ctn: mockCTN) { (_, _) in }

        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)

        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNotNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)

        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 4)
        XCTAssertNil(request?.value(forHTTPHeaderField: ECSConstant.authorization.rawValue))
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(request?.value(forHTTPHeaderField: ECSConstant.apiKey.rawValue), "TestAPIKey")
        XCTAssertEqual(request?.value(forHTTPHeaderField: ECSConstant.apiVersion.rawValue), ECSConstant.apiVersionValue.rawValue)
        
        XCTAssertNotNil(ECSTestUtility.requestBodyDict(request: request))
        XCTAssertEqual(ECSTestUtility.requestBodyDict(request: request)["email"] as? String, "\(mockEmail)")
        XCTAssertEqual(ECSTestUtility.requestBodyDict(request: request)["productId"] as? String, "\(mockCTN)")

        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.POST.rawValue)

        XCTAssertEqual(queryParams?.count, 1)
        XCTAssertNil(queryParams["language"] as? String)
        XCTAssertNil(queryParams["country"] as? String)
        XCTAssertEqual(queryParams["siteId"] as? String, mockSiteID)
    }
    
    func testRegisterForProductAvailabilityRequestForError() {
        serviceDiscoveryMock.microserviceURL = mockNotifyMeURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock

        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.appInfra = mockAppInfra

        let testMicro = ECSNotifyProductAvailibilityMicroservices()
        testMicro.registerForProductAvailability(email: mockEmail, ctn: mockCTN, completionHandler: { (_, _) in })

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
    
    func testRegisterForProductAvailabilityServiceDiscoveryEntries() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "RegisterNotificationSuccess")
        serviceDiscoveryMock.microserviceURL = mockNotifyMeURL
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        ECSConfiguration.shared.apiKey = "TestAPIKey"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSNotifyProductAvailibilityMicroservices()
        testMicro.registerForProductAvailability(email: mockEmail, ctn: mockCTN, completionHandler: { (_, _) in })
        
        XCTAssertEqual(serviceDiscoveryMock.pilServiceIds?.count, 1)
        XCTAssertEqual(serviceDiscoveryMock.pilServiceIds?.first as? String, "ecs.notifyMe")
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?.count, 1)
        XCTAssertEqual(serviceDiscoveryMock.pilReplacementDict?["siteId"] as? String, mockSiteID)
    }
}
