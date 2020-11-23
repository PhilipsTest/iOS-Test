//
//  PIMOIDCConfigurationTests.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 5/8/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev
@testable import AppAuth

class PIMOIDCConfigurationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testGetOIDCConfigObject() {
        let oidServiceDiscoveryConfig = OIDServiceConfiguration(authorizationEndpoint: URL(string: "https://www.authendpoint.com")!, tokenEndpoint: URL(string: "https://www.tokenendpoint.com")!)
        let oidcConfig = PIMOIDCConfiguration(oidServiceDiscoveryConfig)
        XCTAssertNotNil(oidcConfig.oidcConfiguration())
    }

}
