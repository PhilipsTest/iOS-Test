//
//  PIMUserManagerTests.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 5/14/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev
@testable import AppAuth
@testable import AppInfra

class PIMUserManagerTests: XCTestCase {
    var userManager:PIMUserManager?
    var appInfra:AIAppInfra?
    var mockClient:PIMRESTClientMock?
    
    override func setUp() {
        if appInfra == nil {
            Bundle.loadSwizzler()
            mockClient = PIMRESTClientMock()
            appInfra = AIAppInfra(builder: nil)
        }
        appInfra?.setValue(mockClient, forKeyPath: "RESTClient")
        let dependency = PIMDependencies()
        dependency.appInfra = appInfra
        PIMSettingsManager.sharedInstance.updateDependencies(dependency)
        PIMDefaults.saveSubUUID("Some")
        userManager = FakeUserManager(appInfra!)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        Bundle.deSwizzle()
        appInfra = nil;
        PIMDefaults.clearSubUUID()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRefreshSession() {
        (userManager?.authState as! FakeAuthState as FakeAuthState).makeSuccess = true
        userManager?.refreshAccessToken({ (status, error) in
            XCTAssert(status == true, "Status has to be true for no issues")
            XCTAssert(error == nil, "Error has to be nil")
        })
       
    }
    
    func testRefreshSessionOIDCNetworkError() {
        (userManager?.authState as! FakeAuthState as FakeAuthState).makeSuccess = false
        (userManager?.authState as! FakeAuthState as FakeAuthState).refreshCount = 0;
        let error = NSError(domain: "someerror", code: OIDErrorCode.networkError.rawValue, userInfo: [NSLocalizedDescriptionKey:"Some error"])
        (userManager?.authState as! FakeAuthState as FakeAuthState).error = error
        userManager?.refreshAccessToken({ (status, error) in
            XCTAssert(status == false, "Status has to be true for no issues")
            XCTAssert(error != nil, "Error has to be present")
            XCTAssert((error! as NSError).code == PIMMappedError.PIMOIDErrorCodeNetworkError.rawValue, "Error has to be present")
            XCTAssert((self.userManager?.authState as! FakeAuthState as FakeAuthState).refreshCount == 3,"Refresh try was supposed to be thrice")
        })
    }
    
    func testRefreshSessionOIDCServerError() {
        (userManager?.authState as! FakeAuthState as FakeAuthState).makeSuccess = false
        (userManager?.authState as! FakeAuthState as FakeAuthState).refreshCount = 0;
        let error = NSError(domain: "someerror", code: OIDErrorCode.serverError.rawValue, userInfo: [NSLocalizedDescriptionKey:"Some error"])
        (userManager?.authState as! FakeAuthState as FakeAuthState).error = error
        userManager?.refreshAccessToken({ (status, error) in
            XCTAssert(status == false, "Status has to be true for no issues")
            XCTAssert(error != nil, "Error has to be present")
            XCTAssert((error! as NSError).code == PIMMappedError.PIMOIDErrorCodeServerError.rawValue, "Error has to be present")
            XCTAssert((self.userManager?.authState as! FakeAuthState as FakeAuthState).refreshCount == 3,"Refresh try was supposed to be thrice")
        })
    }

}

class FakeUserManager : PIMUserManager {
    
    override func fetchAuthStateFromStorage(_ sub: String) -> OIDAuthState? {
        let scopesList = [OIDScopeOpenID, OIDScopeProfile, OIDScopeEmail, OIDScopePhone, OIDScopeAddress]
        let appClientID = PIMSettingsManager.sharedInstance.getClientID()
        let appRedirectURI = PIMSettingsManager.sharedInstance.getRedirectURL()
        let oidServiceDiscoveryConfig = OIDServiceConfiguration(authorizationEndpoint: URL(string: "https://www.authendpoint.com")!, tokenEndpoint: URL(string: "https://www.tokenendpoint.com")!)
        let parameters = [PIMConstants.Parameters.CLAIMS:PIMLoginManager(PIMOIDCConfiguration(oidServiceDiscoveryConfig)).getCustomClaims(),"prompt":"none"]
        let request = PIMOIDAuthorizationRequest(configuration:
                                                    oidServiceDiscoveryConfig,
                                                     clientId: appClientID,
                                                     scopes: scopesList,
                                                     redirectURL: URL(string: appRedirectURI)!,
                                                     responseType: OIDResponseTypeCode,
                                                     additionalParameters: parameters)
        return FakeAuthState(authorizationResponse: OIDAuthorizationResponse(request: request, parameters: ["":NSString(format: "asd")]))
    }
    
}

class FakeAuthState : OIDAuthState {
    
    var makeSuccess = true
    var error:NSError?
    var refreshCount:Int = 0
    
    override func performAction(freshTokens action: @escaping OIDAuthStateAction) {
        if makeSuccess == true {
            action( "accessToken","idToken",nil)
        } else {
            refreshCount += 1;
            action(nil,nil,error)
        }
    }
}
