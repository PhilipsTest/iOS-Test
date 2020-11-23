/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
@testable import PhilipsEcommerceSDKDev

class ECSFetchOrderHistoryRequestTests: XCTestCase {
    
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
    
    func testOrderHistoryRequestMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSFetchOrderHistoryMicroService()
        testMicro.fetchOrderHistory(pageSize: 0, currentPage: 20) {_,_ in }
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        XCTAssertNil(queryParams["pageSize"] as? Int)
        XCTAssertNotNil(queryParams["pageSize"] as? String)
        XCTAssertNil(queryParams["currentPage"] as? Int)
        XCTAssertNotNil(queryParams["currentPage"] as? String)
        
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.components(separatedBy: "/current/").count == 2)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockSiteID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockBaseURL) == true)
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), mockAccessToken)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.GET.rawValue)
        
        XCTAssertEqual(queryParams?.count, 2)
        XCTAssertEqual(queryParams["pageSize"] as? String, "0")
        XCTAssertEqual(queryParams["currentPage"] as? String, "20")
    }
    
    func testOrderHistoryRequestForErrorScenario() {
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.appInfra = mockAppInfra
        ECSConfiguration.shared.baseURL = nil
        
        let testMicro = ECSFetchOrderHistoryMicroService()
        testMicro.fetchOrderHistory(pageSize: 0, currentPage: 20) {_,_ in }
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        XCTAssertNil(request)
        XCTAssertNil(url)
        XCTAssertNil(ECSTestUtility.fetchQueryParameterFor(url: url))
        XCTAssertNil(request?.httpBody)
        XCTAssertNil(request?.allHTTPHeaderFields)
        XCTAssertNil(request?.httpMethod)
    }
    
    func testOrderHistoryRequestGetsQueryParamsAccordingToInputs() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.rootCategory = "test"
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSFetchOrderHistoryMicroService()
        testMicro.fetchOrderHistory(pageSize: -10, currentPage: 200) {_,_ in }
        XCTAssertNil(testMicro.hybrisRequest?.urlRequest?.httpBody)
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        
        XCTAssertNil(queryParams["pageSize"] as? Int)
        XCTAssertNotNil(queryParams["pageSize"] as? String)
        XCTAssertNil(queryParams["currentPage"] as? Int)
        XCTAssertNotNil(queryParams["currentPage"] as? String)
        
        XCTAssertEqual(queryParams?.count, 2)
        XCTAssertEqual(queryParams["pageSize"] as? String, "-10")
        XCTAssertEqual(queryParams["currentPage"] as? String, "200")
    }
}
