/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
import AppInfra
@testable import PhilipsEcommerceSDKDev

class ECSApplyVoucherRequestTests: XCTestCase {
    
    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockSiteID = "testSiteID"
    var mockBaseURL = "https://www.testecs.com"
    var mockLocale = "de_DE"
    var mockRootCategory = "testRootCategory"
    var mockAccessToken = "Test token"
    var currentValue = "current"
    var mockVoucherID = "MockVoucher"

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
    
    func testApplyVoucherRequest() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockRestClient.secondResponseData = ECSTestUtility.getResponseFrom(jsonFile: "VoucherList")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.rootCategory = mockRootCategory
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSApplyVoucherMicroServices()
        testMicro.applyVoucher(voucherID: mockVoucherID) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        
        XCTAssertNotNil(request)
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNotNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertEqual(ECSTestUtility.requestBodyString(request: request), "voucherId=\(mockVoucherID)")
        XCTAssertEqual(request?.allHTTPHeaderFields?.count, 3)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Authorization"), mockAccessToken)
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request?.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertEqual(ECSTestUtility.stripQueryParametersFor(url: url)?.absoluteString, String(format: "%@/pilcommercewebservices/v2/%@/users/%@/carts/%@/vouchers", mockBaseURL, mockSiteID, currentValue, currentValue))
        
        XCTAssertEqual(request?.httpMethod, ECSHTTPMethod.POST.rawValue)
        
        XCTAssertEqual(queryParams?.count, 1)
        XCTAssertEqual(queryParams["lang"] as? String, mockLocale)
    }
    
    func testApplyVoucherRequestWithError() {
        ECSConfiguration.shared.locale = mockLocale
        ECSConfiguration.shared.rootCategory = mockRootCategory
        ECSConfiguration.shared.siteId = mockSiteID
        ECSConfiguration.shared.hybrisToken = mockAccessToken
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = mockAppInfra
        
        let testMicro = ECSApplyVoucherMicroServices()
        testMicro.applyVoucher(voucherID: mockVoucherID) { (_, _) in }
        
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
