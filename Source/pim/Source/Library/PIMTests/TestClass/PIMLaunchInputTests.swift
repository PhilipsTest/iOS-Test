//
//  PIMLaunchInputTests.swift
//  PIMTests
//
//  Created by Chittaranjan Sahu on 4/30/20.
//  Copyright © 2020 Philips. All rights reserved.
//

import XCTest
@testable import PIMDev

class PIMLaunchInputTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultInitialization() {
        let launchInput = PIMLaunchInput()
        XCTAssertNotNil(launchInput, "Launch input object is not initialized")
    }
    
    func testInitializationWithConsent() {
        let launchInput = PIMLaunchInput(consents: [PIMConsent.ABTestingConsent])
        XCTAssertNotNil(launchInput, "Launch input object is not initialized with consent")
        
        let consentList:[String] = PIMSettingsManager.sharedInstance.getPIMConsents()
        XCTAssertTrue(consentList.count == 1)
        XCTAssertEqual(consentList.first, PIMConsent.ABTestingConsent.rawValue, "Consents are not matching")
    }
    
    func testInitializationFailWithEmptyConsent() {
        let launchInput = PIMLaunchInput(consents: [])
        XCTAssertNil(launchInput, "Launch input object intitialization should fail")
    }
    
}
