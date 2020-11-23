//
//  PIMSettingsManagerTests.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 4/30/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev
@testable import AppAuth

class PIMSettingsManagerTests: XCTestCase {
    
    let sharedInstance = PIMSettingsManager.sharedInstance
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
    }
    
    override func tearDown() {
        super.tearDown()
        Bundle.deSwizzle()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sharedInstance)
    }
    
    func testGetClientId() {
        let appClientId = sharedInstance.getClientID()
        XCTAssertNotNil(appClientId)
    }
    
    func testGetredirectURL() {
        sharedInstance.isUserMigrating = true
        let redirectURL = sharedInstance.getRedirectURL()
        XCTAssertNotNil(redirectURL, "Redirect url should not be nil")
    }
    
    func testUpdateDependenciesWithAppinfra() {
        setDependencies()
        XCTAssertNotNil(sharedInstance.appInfraInstance())
        XCTAssertNotNil(sharedInstance.loggingInterface())
        XCTAssertNotNil(sharedInstance.taggingInterface())
        XCTAssertNotNil(sharedInstance.restClientInterface())
    }
    
    func testNetworkReachable() {
        let isReachable = sharedInstance.isNetworkReachable()
        XCTAssertFalse(isReachable)
    }
    
    func testGetUserManagerInstance() {
        setDependencies()
        let userManager = PIMUserManager(sharedInstance.appinfra!)
        sharedInstance.userManager(userManager)
        XCTAssertNotNil(sharedInstance.pimUserManagerInstance())
    }
    
    func testGetPIMOIDCConfiguration() {
        let oidServiceDiscoveryConfig = OIDServiceConfiguration(authorizationEndpoint: URL(string: "https://www.authendpoint.com")!, tokenEndpoint: URL(string: "https://www.tokenendpoint.com")!)
        let oidcConfig = PIMOIDCConfiguration(oidServiceDiscoveryConfig)
        sharedInstance.pimOIDCConfiguration(oidcConfig)
        XCTAssertNotNil(sharedInstance.pimOIDCConfig())
    }
    
    func testGetLocale() {
        sharedInstance.setLocale("en_US")
        let locale = sharedInstance.getLocale()
        XCTAssertTrue(locale == "en-US")
    }
    
    func testGetPIMSDURLSuccess() {
        setDependencies()
        sharedInstance.getPIMSDURL(forKey: "userreg.janrainoidc.issuer", completionHandler: { (inUrl, inError) in
            XCTAssertNotNil(inUrl)
            XCTAssertNil(inError)
            XCTAssertTrue(inUrl == "https://stg.accounts.philips.com/c2a48310-9715-3beb-895e-000000000000/login", "Issuer url is not matching")
        }, replacement: nil)
    }
    
    func testGetPIMSDURLWithEmptyresponse() {
        setDependencies()
        sharedInstance.getPIMSDURL(forKey: "userreg.janrainoidc.invalidissuer", completionHandler: { (inUrl, inError) in
            XCTAssertTrue(inUrl == "")
            XCTAssertNil(inError)
        }, replacement: nil)
    }
    
    func testGetPimConsents() {
        sharedInstance.setPIMConsents(consents: [PIMConsent.ABTestingConsent.rawValue])
        let consents = sharedInstance.getPIMConsents()
        XCTAssertNotNil(consents)
        XCTAssertTrue(consents.count == 1)
        XCTAssertTrue(consents.first == PIMConsent.ABTestingConsent.rawValue, "Consents are not matching")
    }
    
    func testComponentVersion() {
        let version = sharedInstance.componentVersion()
        XCTAssertNotNil(version)
    }
}

extension PIMSettingsManagerTests {
    func setDependencies() {
        let dependencies = PIMDependencies()
        dependencies.appInfra = PIMAppInfraMock()
        sharedInstance.updateDependencies(dependencies)
    }
}
