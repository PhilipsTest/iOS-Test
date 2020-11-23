/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSOauthRequestTests: XCTestCase {

    var mockAppInfra: MockAppInfra!
    var mockRestClient: RESTClientMock!
    var mockSiteID = "testSiteID"
    var mockAccessToken = "Test token"
    var mockBaseURL = "https://www.testecs.com"
    
    var janrainToken = "janrainToken"
    var grantType = "testType"
    var clientID = "inApp_client"
    var clientSecret = "acc_inapp_12345"
    var refreshToken = "refreshToken"
    
    override func setUp() {
        super.setUp()
        mockAppInfra = MockAppInfra()
        mockRestClient = RESTClientMock()
        ECSConfiguration.shared.appInfra = mockAppInfra
    }
    
    override func tearDown() {
        super.tearDown()
        mockAppInfra = nil
        mockRestClient = nil
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.appInfra = nil
    }

    func testOAuthRequestMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        let testMicro = ECSHybrisAuthenticationMicroService()
        let outhProvider = ECSOAuthProvider(token: janrainToken, clientID: ECSOAuthClientID.JANRAIN, clientSecret: clientSecret)
        testMicro.authenticateWithHybrisWith(hybrisOAuthData: outhProvider) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertNil(queryParams["janrain"] as? Int)
        XCTAssertNotNil(queryParams["grant_type"] as? String)
        XCTAssertNil(queryParams["client_id"] as? Int)
        XCTAssertNotNil(queryParams["client_id"] as? String)
        XCTAssertNotNil(queryParams["client_secret"] as? String)
        
        XCTAssertEqual(queryParams?.count, 4)
        XCTAssertEqual(queryParams["janrain"] as? String, janrainToken)
        XCTAssertEqual(queryParams["client_id"] as? String, clientID)
        XCTAssertEqual(queryParams["client_secret"] as? String, clientSecret)
        XCTAssertEqual(queryParams["grant_type"] as? String, "janrain")
    }
    
    func testOAuthRequestDefaultMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        let testMicro = ECSHybrisAuthenticationMicroService()
        let outhProvider = ECSOAuthProvider(token: janrainToken)
        testMicro.authenticateWithHybrisWith(hybrisOAuthData: outhProvider) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertNil(queryParams["janrain"] as? Int)
        XCTAssertNotNil(queryParams["grant_type"] as? String)
        XCTAssertNil(queryParams["client_id"] as? Int)
        XCTAssertNotNil(queryParams["client_id"] as? String)
        XCTAssertNotNil(queryParams["client_secret"] as? String)
        
        XCTAssertEqual(queryParams?.count, 4)
        XCTAssertEqual(queryParams["janrain"] as? String, janrainToken)
        XCTAssertEqual(queryParams["client_id"] as? String, "inApp_client")
        XCTAssertEqual(queryParams["client_secret"] as? String, "acc_inapp_12345")
        XCTAssertEqual(queryParams["grant_type"] as? String, "janrain")
    }
    
    func testOAuthRequestMethodError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        let testMicro = ECSHybrisAuthenticationMicroService()
        let outhProvider = ECSOAuthProvider(token: "", clientID: ECSOAuthClientID.JANRAIN, clientSecret: "")
        testMicro.authenticateWithHybrisWith(hybrisOAuthData: outhProvider) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        XCTAssertNil(request)
        XCTAssertNil(url)
        XCTAssertNil(ECSTestUtility.fetchQueryParameterFor(url: url))
        XCTAssertNil(request?.httpBody)
        XCTAssertNil(request?.allHTTPHeaderFields)
        XCTAssertNil(request?.httpMethod)
    }
    
    func testRefreshOAuthRequestMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = mockRestClient

        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        let testMicro = ECSHybrisAuthenticationMicroService()
        let outhProvider = ECSOAuthProvider(token: refreshToken, clientID: ECSOAuthClientID.JANRAIN, clientSecret: clientSecret)
        testMicro.refreshHybrisLoginWith(hybrisOAuthData: outhProvider) { (_, _) in }

        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)

        XCTAssertNil(queryParams["janrain"] as? String)
        XCTAssertNotNil(queryParams["refresh_token"] as? String)
        XCTAssertNotNil(queryParams["grant_type"] as? String)
        XCTAssertNotNil(queryParams["client_id"] as? String)
        XCTAssertNotNil(queryParams["client_secret"] as? String)

        XCTAssertEqual(queryParams?.count, 4)
        XCTAssertEqual(queryParams["refresh_token"] as? String, refreshToken)
        XCTAssertNotEqual(queryParams["refresh_token"] as? String, janrainToken)
        XCTAssertEqual(queryParams["client_id"] as? String, clientID)
        XCTAssertEqual(queryParams["client_secret"] as? String, clientSecret)
        XCTAssertEqual(queryParams["grant_type"] as? String, "refresh_token")
    }
    
    func testRefreshOAuthRequestDefaultMethod() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = mockRestClient
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        let testMicro = ECSHybrisAuthenticationMicroService()
        let outhProvider = ECSOAuthProvider(token: refreshToken)
        testMicro.refreshHybrisLoginWith(hybrisOAuthData: outhProvider) { (_, _) in }
        
        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        let queryParams = ECSTestUtility.fetchQueryParameterFor(url: url)
        XCTAssertNotNil(url)
        XCTAssertNotNil(queryParams)
        XCTAssertNil(request?.httpBody)
        XCTAssertNotNil(request?.allHTTPHeaderFields)
        
        XCTAssertNil(queryParams["janrain"] as? String)
        XCTAssertNotNil(queryParams["refresh_token"] as? String)
        XCTAssertNotNil(queryParams["grant_type"] as? String)
        XCTAssertNotNil(queryParams["client_id"] as? String)
        XCTAssertNotNil(queryParams["client_secret"] as? String)
        
        XCTAssertEqual(queryParams?.count, 4)
        XCTAssertEqual(queryParams["refresh_token"] as? String, refreshToken)
        XCTAssertEqual(queryParams["client_id"] as? String, "inApp_client")
        XCTAssertEqual(queryParams["client_secret"] as? String, "acc_inapp_12345")
        XCTAssertEqual(queryParams["grant_type"] as? String, "refresh_token")
    }

    func testRefreshOAuthRequestMethodError() {
        mockRestClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = mockRestClient

        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = mockBaseURL
        ECSConfiguration.shared.appInfra = mockAppInfra
        let testMicro = ECSHybrisAuthenticationMicroService()
        let outhProvider = ECSOAuthProvider(token: "", clientID: ECSOAuthClientID.JANRAIN, clientSecret: "")
        testMicro.refreshHybrisLoginWith(hybrisOAuthData: outhProvider) { (_, _) in }

        let request = testMicro.hybrisRequest?.urlRequest
        let url = request?.url
        XCTAssertNil(request)
        XCTAssertNil(url)
        XCTAssertNil(ECSTestUtility.fetchQueryParameterFor(url: url))
        XCTAssertNil(request?.httpBody)
        XCTAssertNil(request?.allHTTPHeaderFields)
        XCTAssertNil(request?.httpMethod)
    }
    
    func testConstructOauthParameters() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        let outhProvider = ECSOAuthProvider(token: janrainToken, clientID: ECSOAuthClientID.JANRAIN, clientSecret: clientSecret)
        let oauthParmas: [String: String] = testMicro.constructOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(oauthParmas)
        XCTAssertEqual(oauthParmas.count, 4)
        XCTAssertEqual(oauthParmas["client_id"], "inApp_client")
        XCTAssertEqual(oauthParmas["janrain"], janrainToken)
        XCTAssertEqual(oauthParmas["client_secret"], "acc_inapp_12345")
        XCTAssertEqual(oauthParmas["grant_type"], "janrain")
    }
    
    func testConstructRefreshOauthParameters() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        let outhProvider = ECSOAuthProvider(token: refreshToken, clientID: ECSOAuthClientID.JANRAIN, clientSecret: clientSecret)
        let refreshOauthParmas: [String: String] = testMicro.constructRefreshOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(refreshOauthParmas)
        XCTAssertEqual(refreshOauthParmas.count, 4)
        XCTAssertEqual(refreshOauthParmas["client_id"], "inApp_client")
        XCTAssertEqual(refreshOauthParmas["refresh_token"], refreshToken)
        XCTAssertEqual(refreshOauthParmas["client_secret"], "acc_inapp_12345")
        XCTAssertEqual(refreshOauthParmas["grant_type"], "refresh_token")
    }
    
    func testConstructOauthParametersForProduction() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        mockAppInfra.mockIdentity.appState = .PRODUCTION
        let outhProvider = ECSOAuthProvider(token: janrainToken, clientID: ECSOAuthClientID.JANRAIN)
        let oauthParmas: [String: String] = testMicro.constructOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(oauthParmas)
        XCTAssertEqual(oauthParmas.count, 4)
        XCTAssertEqual(oauthParmas["client_id"], "inApp_client")
        XCTAssertEqual(oauthParmas["janrain"], janrainToken)
        XCTAssertEqual(oauthParmas["client_secret"], "prod_inapp_54321")
        XCTAssertEqual(oauthParmas["grant_type"], "janrain")
    }
    
    func testConstructOauthParametersForAcceptance() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        mockAppInfra.mockIdentity.appState = .ACCEPTANCE
        let outhProvider = ECSOAuthProvider(token: janrainToken, clientID: ECSOAuthClientID.JANRAIN, clientSecret: clientSecret)
        let oauthParmas: [String: String] = testMicro.constructOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(oauthParmas)
        XCTAssertEqual(oauthParmas.count, 4)
        XCTAssertEqual(oauthParmas["client_id"], "inApp_client")
        XCTAssertEqual(oauthParmas["janrain"], janrainToken)
        XCTAssertEqual(oauthParmas["client_secret"], "acc_inapp_12345")
        XCTAssertEqual(oauthParmas["grant_type"], "janrain")
    }
    
    func testConstructRefreshOauthParametersForProduction() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        mockAppInfra.mockIdentity.appState = .PRODUCTION
        let outhProvider = ECSOAuthProvider(token: refreshToken, clientID: ECSOAuthClientID.JANRAIN)
        let refreshOauthParmas: [String: String] = testMicro.constructRefreshOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(refreshOauthParmas)
        XCTAssertEqual(refreshOauthParmas.count, 4)
        XCTAssertEqual(refreshOauthParmas["client_id"], "inApp_client")
        XCTAssertEqual(refreshOauthParmas["refresh_token"], refreshToken)
        XCTAssertEqual(refreshOauthParmas["client_secret"], "prod_inapp_54321")
        XCTAssertEqual(refreshOauthParmas["grant_type"], "refresh_token")
    }
    
    func testConstructRefreshOauthParametersForAcceptance() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        mockAppInfra.mockIdentity.appState = .ACCEPTANCE
        let outhProvider = ECSOAuthProvider(token: refreshToken, clientID: ECSOAuthClientID.JANRAIN, clientSecret: clientSecret)
        let refreshOauthParmas: [String: String] = testMicro.constructRefreshOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(refreshOauthParmas)
        XCTAssertEqual(refreshOauthParmas.count, 4)
        XCTAssertEqual(refreshOauthParmas["client_id"], "inApp_client")
        XCTAssertEqual(refreshOauthParmas["refresh_token"], refreshToken)
        XCTAssertEqual(refreshOauthParmas["client_secret"], "acc_inapp_12345")
        XCTAssertEqual(refreshOauthParmas["grant_type"], "refresh_token")
    }
    
    func testConstructRefreshOauthParametersWithCustomValues() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        mockAppInfra.mockIdentity.appState = .PRODUCTION
        let outhProvider = ECSOAuthProvider(token: refreshToken, clientID: .JANRAIN, clientSecret: "Test", grantType: .OIDC)
        let refreshOauthParmas: [String: String] = testMicro.constructRefreshOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(refreshOauthParmas)
        XCTAssertEqual(refreshOauthParmas.count, 4)
        XCTAssertEqual(refreshOauthParmas["client_id"], "inApp_client")
        XCTAssertEqual(refreshOauthParmas["refresh_token"], refreshToken)
        XCTAssertEqual(refreshOauthParmas["client_secret"], "Test")
        XCTAssertEqual(refreshOauthParmas["grant_type"], "refresh_token")
    }
    
    func testConstructRefreshOauthParametersWithCustomValuesForAcceptance() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        mockAppInfra.mockIdentity.appState = .ACCEPTANCE
        let outhProvider = ECSOAuthProvider(token: refreshToken, clientID: .JANRAIN, clientSecret: "Test123", grantType: .JANRAIN)
        let refreshOauthParmas: [String: String] = testMicro.constructRefreshOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(refreshOauthParmas)
        XCTAssertEqual(refreshOauthParmas.count, 4)
        XCTAssertEqual(refreshOauthParmas["client_id"], "inApp_client")
        XCTAssertNil(refreshOauthParmas["oidc"])
        XCTAssertNil(refreshOauthParmas["janrain"])
        XCTAssertEqual(refreshOauthParmas["refresh_token"], refreshToken)
        XCTAssertEqual(refreshOauthParmas["client_secret"], "Test123")
        XCTAssertEqual(refreshOauthParmas["grant_type"], "refresh_token")
    }
    
    func testConstructOauthParametersForAcceptanceWithCustomValues() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        mockAppInfra.mockIdentity.appState = .ACCEPTANCE
        let outhProvider = ECSOAuthProvider(token: janrainToken, clientID: .JANRAIN, clientSecret: "Test", grantType: .OIDC)
        let oauthParmas: [String: String] = testMicro.constructOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(oauthParmas)
        XCTAssertEqual(oauthParmas.count, 4)
        XCTAssertEqual(oauthParmas["client_id"], "inApp_client")
        XCTAssertNil(oauthParmas["janrain"])
        XCTAssertEqual(oauthParmas["oidc"], janrainToken)
        XCTAssertEqual(oauthParmas["client_secret"], "Test")
        XCTAssertEqual(oauthParmas["grant_type"], "oidc")
    }
    
    func testConstructOauthParametersForProductionWithCustomValues() {
        let testMicro = ECSHybrisAuthenticationMicroService()
        mockAppInfra.mockIdentity.appState = .PRODUCTION
        let outhProvider = ECSOAuthProvider(token: janrainToken, clientID: .JANRAIN, clientSecret: "Test", grantType: .JANRAIN)
        let oauthParmas: [String: String] = testMicro.constructOauthParameters(oauthData: outhProvider)
        
        XCTAssertNotNil(oauthParmas)
        XCTAssertEqual(oauthParmas.count, 4)
        XCTAssertEqual(oauthParmas["client_id"], "inApp_client")
        XCTAssertNil(oauthParmas["oidc"])
        XCTAssertEqual(oauthParmas["janrain"], janrainToken)
        XCTAssertEqual(oauthParmas["client_secret"], "Test")
        XCTAssertEqual(oauthParmas["grant_type"], "janrain")
    }
}
