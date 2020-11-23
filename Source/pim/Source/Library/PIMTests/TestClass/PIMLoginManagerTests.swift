//
//  PIMLoginManagerTests.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 5/14/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev
@testable import AppAuth

class PIMLoginManagerTests: XCTestCase {
    
    var loginManager: PIMLoginManager!
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
        let oidServiceDiscoveryConfig = OIDServiceConfiguration(authorizationEndpoint: URL(string: "https://www.authendpoint.com")!, tokenEndpoint: URL(string: "https://www.tokenendpoint.com")!)
        let oidcConfig = PIMOIDCConfiguration(oidServiceDiscoveryConfig)
        loginManager = PIMLoginManager(oidcConfig)
    }
    
    override func tearDown() {
        super.tearDown()
        Bundle.deSwizzle()
    }
    
    func testLoginManagerInitialization() {
        XCTAssertNotNil(loginManager)
    }
    
    func testAdditionalPrameterForLogin() {
        let appInfraMock = PIMAppInfraMock()
        PIMSettingsManager.sharedInstance.appinfra = appInfraMock
        let parametersWithoutPrompt:[String: String] = loginManager.createAdditionalParameterForLogin()
        XCTAssertNotNil(parametersWithoutPrompt)
        XCTAssertTrue(parametersWithoutPrompt.keys.count == 4)
        
        let launchInput: PIMLaunchInput = PIMLaunchInput()
        launchInput.pimLaunchFlow = PIMLaunchFlow.login
        let parametersWithPrompt:[String: String] = loginManager.createAdditionalParameterForLogin()
        XCTAssertTrue(parametersWithPrompt.keys.count == 5)
                
        let parametersKeys = Array(parametersWithPrompt.keys)
        let expectedKeys = [PIMConstants.AuthorizationKeys.ANALYTICS_REPORT_SUITE,
                            PIMConstants.AuthorizationKeys.CONSENTS,
                            PIMConstants.AuthorizationKeys.UI_LOCALE,
                            PIMConstants.AuthorizationKeys.CLAIMS,
                            PIMConstants.AuthorizationKeys.PROMPT]
        XCTAssertTrue(parametersKeys.containsSameElements(as: expectedKeys))
    }
    
    func testGetCustomClaims() {
        let customClaimsReceived = loginManager.getCustomClaims()
        XCTAssertNotNil(customClaimsReceived)
        
        let claimsJson = covertStringToJson(inString: customClaimsReceived)
        if let claimsDict = claimsJson {
            let userinfoDict:[String:Any] = claimsDict["userinfo"] as! [String : Any]
            XCTAssertNotNil(userinfoDict)
            XCTAssertTrue(userinfoDict.keys.count == 4)
            
            let userInfoKeys:[String] = Array(userinfoDict.keys)
            let expectedkeys:[String] = ["uuid", "social_profiles", "consent_email_marketing.opted_in", "consent_email_marketing.timestamp"]
            XCTAssertTrue(userInfoKeys.containsSameElements(as: expectedkeys))
        }
    }
    
    func testValidAuthorizedConsents() {
        let appInfraMock = PIMAppInfraMock()
        appInfraMock.tagging.setPrivacyConsent(.optIn)
        PIMSettingsManager.sharedInstance.appinfra = appInfraMock
        PIMSettingsManager.sharedInstance.setPIMConsents(consents: [PIMConsent.ABTestingConsent.rawValue])
        let authorizedConsents = loginManager.getAuthorizationConsents()
        XCTAssertNotNil(authorizedConsents)
        
        let consentList = authorizedConsents.components(separatedBy: ",")
        XCTAssertTrue(consentList.count == 2)
        XCTAssertTrue(consentList.containsSameElements(as: ["ab_testing", "analytics"]))
    }
}

extension PIMLoginManagerTests {
    func covertStringToJson(inString: String) -> [String: Any]? {
        if let data = inString.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
