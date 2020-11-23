/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchRetailerRequestTests: XCTestCase {

    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockServiceDiscovery: ServiceDiscoveryMock!
    var mockProductCTN = "HX3631/06"
    var mockRetailerURL = ""
    var mockLocale = "en_US"
    
    override func setUp() {
        super.setUp()
        
        mockAppInfra = MockAppInfra()
        ECSConfiguration.shared.appInfra = mockAppInfra
        mockRestClient = RESTClientMock()
        mockServiceDiscovery = ServiceDiscoveryMock()
        mockAppInfra.serviceDiscovery = mockServiceDiscovery
        
        mockRetailerURL = "https://www.philips.com/api/wtb/v1/B2C/\(mockLocale)/online-retailers?product=\(mockProductCTN)"
    }

    override func tearDown() {
        super.tearDown()
        mockRetailerURL = ""
        mockAppInfra = nil
        mockRestClient = nil
        mockServiceDiscovery = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.rootCategory = nil
        ECSConfiguration.shared.siteId = nil
        ECSConfiguration.shared.hybrisToken = nil
        ECSConfiguration.shared.baseURL = nil
    }
    
    func testFetchRetailerForProductCTN() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        mockServiceDiscovery.microserviceURL = mockRetailerURL
        
        ECSConfiguration.shared.locale = mockLocale
        let micro = ECSFetchRetailersMicroService()
        micro.fetchRetailerDetailsFor(productCtn: mockProductCTN) { (_, _) in}
        
        let request = micro.retailerRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.GET.rawValue)
        
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString, String(format:"https://www.philips.com/api/wtb/v1/B2C/en_US/online-retailers"))
        
        XCTAssertEqual(queryParams?.count, 1)
        XCTAssertEqual(queryParams["product"] as? String, mockProductCTN)
    }
    
    func testFetchRetailerForProductCTNError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "FetchOrderHistory")
        mockAppInfra.restClient = mockRestClient
        mockServiceDiscovery.microserviceURL = mockRetailerURL
        
        ECSConfiguration.shared.locale = mockLocale
        let micro = ECSFetchRetailersMicroService()
        micro.fetchRetailerDetailsFor(productCtn: "") { (_, _) in}
        
        let request = micro.retailerRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNil(url)
        XCTAssertNil(queryParams)
    }
}
