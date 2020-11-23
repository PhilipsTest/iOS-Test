/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchRegionRequestTests: XCTestCase {

    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockBaseURL = "https://www.testecs.com"
    var mockCountryISO = "US"
    
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

    func testDeleteAddressRequestMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "testSetDeliveryAddressSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let micro = ECSFetchRegionMicroServices()
        micro.fetchRegions(for: mockCountryISO) { (_, _) in }
        
        let request = micro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.GET.rawValue)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(mockCountryISO) == true)
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString, String(format:"%@/pilcommercewebservices/v2/metainfo/regions/%@",mockBaseURL, mockCountryISO))
        
        XCTAssertEqual(queryParams?.count, 1)
        XCTAssertEqual(queryParams["lang"] as? String, "en_US")
    }
    
    func testDeleteAddressRequestMethodError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "testSetDeliveryAddressSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let micro = ECSFetchRegionMicroServices()
        micro.fetchRegions(for: "") { (_, _) in }
        
        let request = micro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNil(url)
        XCTAssertNil(queryParams)
    }
}
