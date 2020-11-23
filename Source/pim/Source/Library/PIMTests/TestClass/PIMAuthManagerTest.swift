//
//  PIMAuthManagerTest.swift
//  PIMTests
//
//  Created by Philips on 4/2/19.
//  Copyright © 2019 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev
@testable import AppAuth


class PIMAuthManagerTest: XCTestCase {
    
    var authManager: PIMAuthManager?
    var pimOIDCDiscoveryManager: PIMOIDCDiscoveryManager?

    override func setUp() {
        OIDAuthorizationService.loadSwizzler()
        authManager = PIMAuthManager()
    }
    
    override func tearDown() {
        OIDAuthorizationService.deSwizzle()
    }

    func testAuthManagerInit() {
        XCTAssertNotNil(authManager);
        pimOIDCDiscoveryManager = PIMOIDCDiscoveryManager()
    }
    
    func testFetchOIDCConfigAvailableWithDiscovery() {
//        XCTAssertTrue(PIMTestHelper.sharedInstance.testBool!)
        authManager?.fetchAuthWellKnowConfiguration("https://www.philips.com", completion: { (oidcService, error) in
            XCTAssertNotNil(oidcService?.authorizationEndpoint)
            XCTAssertNil(oidcService?.discoveryDocument)
        })
    }
    
    func testFetchOIDCConfigNotAvailable() {
        
        authManager?.fetchAuthWellKnowConfiguration("https://www.philips.com/pim", completion: { (oidcService, error) in
            XCTAssertNil(oidcService)
            XCTAssertNotNil(error)
        })
    }
    
    func testFetchOIDCConfigWithConfigAvailable() {
        authManager?.fetchAuthWellKnowConfiguration("https://www.philips.com/pim/available", completion: { (oidcService, error) in
            XCTAssertNotNil(oidcService?.issuer)
            XCTAssertNotNil(oidcService?.discoveryDocument)
        })
    }

}
