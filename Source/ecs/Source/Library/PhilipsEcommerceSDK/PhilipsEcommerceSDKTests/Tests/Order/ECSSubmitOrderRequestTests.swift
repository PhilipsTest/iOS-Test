/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSSubmitOrderRequestTests: XCTestCase {

    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockSiteID = "testSiteID"
    var mockAccessToken = "Test token"
    var mockBaseURL = "https://www.testecs.com"
    
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
        ECSConfiguration.shared.appInfra = nil
    }
    
    func testSubmitOrderRequestMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSSubmitOrderMicroServices()
        testMicro.submitOrder { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNil(queryParams)
        XCTAssertNotNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.components(separatedBy: "/current/").count == 2)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockSiteID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockBaseURL) == true)
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString,
                       String(format:"%@/pilcommercewebservices/v2/%@/users/current/orders", mockBaseURL, mockSiteID))
            
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), mockAccessToken)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("cartId=current"))
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.POST.rawValue)
    }
    
    func testSubmitOrderRequestMethodWithPayment() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSSubmitOrderMicroServices()
        testMicro.submitOrder(cvvCode: "123") { (_, _) in }
    
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNil(queryParams)
        XCTAssertNotNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.components(separatedBy: "/current/").count == 2)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockSiteID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockBaseURL) == true)
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString,
                       String(format:"%@/pilcommercewebservices/v2/%@/users/current/orders", mockBaseURL, mockSiteID))
        
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), mockAccessToken)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("cartId=current"))
        XCTAssertTrue(ECSTestUtility.requestBodyString(request: request).contains("securityCode=123"))
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.POST.rawValue)
    }
    
    func testSubmitOrderRequestMethodWithPaymentError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSSubmitOrderMicroServices()
        testMicro.submitOrder(cvvCode: "123") { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNil(url)
        XCTAssertNil(queryParams)
    }
    
    func testSubmitOrderRequestMethodError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSSubmitOrderMicroServices()
        testMicro.submitOrder { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNil(url)
        XCTAssertNil(queryParams)
    }
}
