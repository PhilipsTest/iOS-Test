/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
@testable import PhilipsEcommerceSDKDev

class ECSFetchOrderHistoryDetailsRequestTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockSiteID = "testSiteID"
    var mockAccessToken = "Test token"
    var mockBaseURL = "https://www.testecs.com"
    var mockLocale = "en_US"
    var mockOrder: ECSOrder!
    var mockOrderDetail: ECSOrderDetail!
    var mockOrderID: String!
    var serviceDiscoveryMock: ServiceDiscoveryMock!
    var currentValue = "current"

    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        serviceDiscoveryMock = ServiceDiscoveryMock()
        mockOrderID = "24003330178"
        mockOrder = ECSOrder()
        mockOrder.orderID = mockOrderID
        mockOrderDetail = ECSOrderDetail()
        mockOrderDetail.orderID = mockOrderID
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
        mockOrder = nil
        mockOrderDetail = nil
        serviceDiscoveryMock = nil
    }
    
    func testOrderHistoryDetailsWithOrderRequest() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSFetchOrderHistoryDetailsMicroService()
        testMicro.fetchOrderDetailFor(order: mockOrder) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.components(separatedBy: "/current/").count == 2)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockSiteID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockOrderID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockBaseURL) == true)
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString, String(format: "%@/pilcommercewebservices/v2/%@/users/%@/orders/%@", mockBaseURL, mockSiteID, currentValue, mockOrderID))
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), mockAccessToken)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.GET.rawValue)
        
        XCTAssertEqual(queryParams?.count, 2)
        XCTAssertEqual(queryParams["fields"] as? String, "FULL")
        XCTAssertEqual(queryParams["lang"] as? String, mockLocale)
    }
    
    func testOrderHistoryDetailsWithOrderDetailRequest() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSFetchOrderHistoryDetailsMicroService()
        testMicro.fetchOrderDetailFor(orderDetail: mockOrderDetail) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.components(separatedBy: "/current/").count == 2)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockSiteID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockOrderID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockBaseURL) == true)
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString, String(format: "%@/pilcommercewebservices/v2/%@/users/%@/orders/%@", mockBaseURL, mockSiteID, currentValue, mockOrderID))
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), mockAccessToken)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.GET.rawValue)
        
        XCTAssertEqual(queryParams?.count, 2)
        XCTAssertEqual(queryParams["fields"] as? String, "FULL")
        XCTAssertEqual(queryParams["lang"] as? String, mockLocale)
    }
    
    func testOrderHistoryDetailsWithOrderIDRequest() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "OrderHistoryDetailsList")
        mockAppInfra.restClient = mockRestClient
        mockAppInfra.serviceDiscovery = serviceDiscoveryMock
        
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSFetchOrderHistoryDetailsMicroService()
        testMicro.fetchOrderDetailFor(orderID: mockOrderID) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.components(separatedBy: "/current/").count == 2)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockSiteID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockOrderID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockBaseURL) == true)
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString, String(format: "%@/pilcommercewebservices/v2/%@/users/%@/orders/%@", mockBaseURL, mockSiteID, currentValue, mockOrderID))
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), mockAccessToken)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.GET.rawValue)
        
        XCTAssertEqual(queryParams?.count, 2)
        XCTAssertEqual(queryParams["fields"] as? String, "FULL")
        XCTAssertEqual(queryParams["lang"] as? String, mockLocale)
    }
    
    func testOrderHistoryDetailsWithOrderRequestFailure() {
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        mockOrder.orderID = ""
        
        let testMicro = ECSFetchOrderHistoryDetailsMicroService()
        testMicro.fetchOrderDetailFor(order: mockOrder) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        XCTAssertNil(request)
        XCTAssertNil(url)
        XCTAssertNil(ECSTestUtility.fetchQueryParameterFor(url: url))
        XCTAssertNil(request?.httpBody)
        XCTAssertNil(request?.allHTTPHeaderFields)
        XCTAssertNil(request?.httpMethod)
    }
    
    func testOrderHistoryDetailsWithOrderIDRequestFailure() {
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        mockOrderID = ""
        
        let testMicro = ECSFetchOrderHistoryDetailsMicroService()
        testMicro.fetchOrderDetailFor(orderID: mockOrderID) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        XCTAssertNil(request)
        XCTAssertNil(url)
        XCTAssertNil(ECSTestUtility.fetchQueryParameterFor(url: url))
        XCTAssertNil(request?.httpBody)
        XCTAssertNil(request?.allHTTPHeaderFields)
        XCTAssertNil(request?.httpMethod)
    }
    
    func testOrderHistoryDetailsWithOrderDetailsRequestFailure() {
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        mockOrderDetail.orderID = ""
        
        let testMicro = ECSFetchOrderHistoryDetailsMicroService()
        testMicro.fetchOrderDetailFor(orderDetail: mockOrderDetail) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        XCTAssertNil(request)
        XCTAssertNil(url)
        XCTAssertNil(ECSTestUtility.fetchQueryParameterFor(url: url))
        XCTAssertNil(request?.httpBody)
        XCTAssertNil(request?.allHTTPHeaderFields)
        XCTAssertNil(request?.httpMethod)
    }
}
