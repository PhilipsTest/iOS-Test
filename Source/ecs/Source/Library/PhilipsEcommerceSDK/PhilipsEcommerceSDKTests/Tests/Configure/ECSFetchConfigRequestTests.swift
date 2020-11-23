/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSFetchConfigRequestTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockBaseURL = "https://www.testecs.com"
    var propositionID = "Test"
    var locale = "en_US"
    
    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        let serviceDiscovery = ServiceDiscoveryMock()
        serviceDiscovery.hybrisURL = mockBaseURL
        mockAppInfra.serviceDiscovery = serviceDiscovery
        
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
    
    func testFetchConfigRequestMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = locale
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        ECSConfiguration.shared.propositionId = propositionID
        
        let testMicro = ECSFetchConfigMicroService()
        testMicro.configureECSWithConfiguration { (_, _) in }
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(url)
        let urlString = String(format:"%@/pilcommercewebservices/v2/inAppConfig/%@/%@",mockBaseURL, locale, propositionID)
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString, urlString)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        XCTAssertNil(queryParams["lang"] as? Int)
        XCTAssertNotNil(queryParams["lang"] as? String)
        XCTAssertEqual(queryParams["lang"] as? String, locale)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(propositionID) == true)
        XCTAssertTrue(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString.contains(locale) == true)
        
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.GET.rawValue)
        
    }
    
    
    func testFetchConfigRequestMethodError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "GetConfigSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = locale
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        ECSConfiguration.shared.propositionId = nil
        
        let testMicro = ECSFetchConfigMicroService()
        testMicro.configureECSWithConfiguration { (_, _) in }
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        
        XCTAssertNil(url)        
    }
}
