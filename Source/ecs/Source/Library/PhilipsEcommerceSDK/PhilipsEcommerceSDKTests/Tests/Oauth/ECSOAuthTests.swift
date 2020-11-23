
/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import PhilipsEcommerceSDKDev

class ECSOAuthTests: XCTestCase {

    var sut: ECSServices?
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        ECSConfiguration.shared.locale = nil
        ECSConfiguration.shared.baseURL = nil
        ECSConfiguration.shared.hybrisToken = nil
        super.tearDown()
    }
    
    func testHybrisOAuthAuthenticationSuccess() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()

        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationSuccess")
        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                             clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(hybrisOAuthData)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHybrisOAuthAuthenticationSuccessEntries() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationSuccessEntries")
        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(hybrisOAuthData)
            XCTAssertEqual(ECSConfiguration.shared.hybrisToken, "bearer c8a2cc8e-4fa5-41a0-9fbd-a1092cbd7344")
            XCTAssertEqual(hybrisOAuthData?.accessToken, "c8a2cc8e-4fa5-41a0-9fbd-a1092cbd7344")
            XCTAssertEqual(hybrisOAuthData?.refreshToken, "1ebbc48b-1478-48eb-939e-228abd6ed3c0")
            XCTAssertEqual(hybrisOAuthData?.expiresIn, 43199)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHybrisOAuthAuthenticationSuccessDataNil() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccessDataNil")
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationSuccessDataNil")
        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            XCTAssertEqual((error as NSError?)?.code, 5999)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertNil(ECSConfiguration.shared.hybrisToken)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHybrisOAuthAuthenticationInvalidToken() {
        
        let mockAppInfra = MockAppInfra()
        
        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthFailure")
        restClient.errorData = NSError(domain: "error", code: 400, userInfo: nil)
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationInvalidToken")
        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                             clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5000)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid Janrain Token). Please re-login")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHybrisOAuthAuthenticationInvalidOAuthProviderData() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.errorData = NSError(domain: "error", code: 400, userInfo: nil)
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisInvalidClient")
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationInvalidOAuthProviderData")

        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "", clientID: ECSOAuthClientID.JANRAIN, clientSecret: ""), completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5058)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "Please provide complete OAuth detials")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHybrisOAuthAuthenticationEmptyResponse() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.errorData = nil
        restClient.responseData = nil
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationEmptyResponse")
        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                             clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5999)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHybrisOAuthAuthenticationInvalidClientId() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.errorData = NSError(domain: "error", code: 400, userInfo: nil)
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisInvalidClient")
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationInvalidClientId")
        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                             clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5001)
            XCTAssertNil(hybrisOAuthData)
            XCTAssert(error?.localizedDescription == "We have encountered technical glitch (Bad client credentials). Please re-login")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHybrisOAuthAuthenticationUnsupportedGrantType() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.errorData = NSError(domain: "error", code: 400, userInfo: nil)
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisUnSupportedGrant")
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationUnsupportedGrantType")
        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                             clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5002)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Unsupported grant type). Please re-login")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHybrisOAuthAuthenticationWithoutBaseURL() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationWithoutBaseURL")
        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                             clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5050)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testHybrisOAuthAuthenticationWithInvalidJson() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccessInvalidJson")
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testHybrisOAuthAuthenticationWithInvalidJson")
        sut?.hybrisOAuthAuthenticationWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                             clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRefreshHybrisSuccess() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()

        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = restClient

        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testRefreshHybrisSuccess")
        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                      clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(hybrisOAuthData)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRefreshHybrisSuccessEntries() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()

        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccess")
        mockAppInfra.restClient = restClient

        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testRefreshHybrisSuccessEntries")
        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(hybrisOAuthData)
            XCTAssertEqual(ECSConfiguration.shared.hybrisToken, "bearer c8a2cc8e-4fa5-41a0-9fbd-a1092cbd7344")
            XCTAssertEqual(hybrisOAuthData?.accessToken, "c8a2cc8e-4fa5-41a0-9fbd-a1092cbd7344")
            XCTAssertEqual(hybrisOAuthData?.refreshToken, "1ebbc48b-1478-48eb-939e-228abd6ed3c0")
            XCTAssertEqual(hybrisOAuthData?.expiresIn, 43199)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRefreshHybrisSuccessDataNil() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()

        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccessDataNil")
        mockAppInfra.restClient = restClient

        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testRefreshHybrisSuccessDataNil")
        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            XCTAssertEqual((error as NSError?)?.code, 5999)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertNil(ECSConfiguration.shared.hybrisToken)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRefreshHybrisInvalidToken() {

        let mockAppInfra = MockAppInfra()

        let restClient = RESTClientMock()
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthFailure")
        restClient.errorData = NSError(domain: "error", code: 400, userInfo: nil)
        mockAppInfra.restClient = restClient

        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)

        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testRefreshHybrisInvalidToken")
        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                      clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5000)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Invalid Janrain Token). Please re-login")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRefreshHybrisOAuthProviderData() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.errorData = NSError(domain: "error", code: 400, userInfo: nil)
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisInvalidClient")
        mockAppInfra.restClient = restClient

        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testRefreshHybrisOAuthProviderData")

        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "", clientID: ECSOAuthClientID.JANRAIN, clientSecret: ""), completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5058)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "Please provide complete OAuth detials")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRefreshHybrisEmptyResponse() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.errorData = nil
        restClient.responseData = nil
        mockAppInfra.restClient = restClient

        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testRefreshHybrisEmptyResponse")
        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                      clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5999)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRefreshHybrisInvalidClientId() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.errorData = NSError(domain: "error", code: 400, userInfo: nil)
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisInvalidClient")
        mockAppInfra.restClient = restClient

        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testRefreshHybrisInvalidClientId")
        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                      clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5001)
            XCTAssertNil(hybrisOAuthData)
            XCTAssert(error?.localizedDescription == "We have encountered technical glitch (Bad client credentials). Please re-login")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRefreshHybrisUnsupportedGrantType() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        restClient.errorData = NSError(domain: "error", code: 400, userInfo: nil)
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisUnSupportedGrant")
        mockAppInfra.restClient = restClient

        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)

        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testRefreshHybrisUnsupportedGrantType")
        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                      clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5002)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch (Unsupported grant type). Please re-login")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testRefreshHybrisOAuthWithoutBaseURL() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        mockAppInfra.restClient = restClient

        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        let expectation = self.expectation(description: "testRefreshHybrisOAuthWithoutBaseURL")
        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                      clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertEqual((error as NSError?)?.code, 5050)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "Base URL not found")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testRefreshHybrisOAuthWithInvalidJson() {
        let mockAppInfra = MockAppInfra()
        let restClient = RESTClientMock()
        
        restClient.responseData = ECSTestUtility.getResponseFrom(jsonFile: "HybrisOauthSuccessInvalidJson")
        mockAppInfra.restClient = restClient
        
        sut = ECSServices(propositionId: "IAP_MOB_TEST", appInfra: mockAppInfra)
        ECSConfiguration.shared.locale = "en_US"
        ECSConfiguration.shared.baseURL = "abc"
        let expectation = self.expectation(description: "testRefreshHybrisOAuthWithInvalidJson")
        sut?.hybrisRefreshOAuthWith(hybrisOAuthData: ECSOAuthProvider(token: "jyrd9e6kbyehjy5x",
                                                                      clientID: ECSOAuthClientID.JANRAIN,
                                                              clientSecret: "secret"),
                                       completionHandler: { (hybrisOAuthData, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(hybrisOAuthData)
            XCTAssertEqual(error?.localizedDescription, "We have encountered technical glitch. Please try after some time")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 2, handler: nil)
    }
}
