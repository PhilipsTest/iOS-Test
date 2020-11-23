//
//  AIConsentManagerInitialisationTests.swift
//  AppInfraTests
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest

@testable import AppInfra

class AIConsentManagerInitialisationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
    }
    
    func testConsentManagerBuilderWithNil() {
        let appInfra = AIAppInfra.build(nil)
        XCTAssertNotNil(appInfra?.consentManager, "Consent Manager is not initialised")
    }
    
    func testConsentManagerBuilderWithoutNil() {
        let asyncExpectation = expectation(description: "longRunningFunction")
        let consentManager = AIConsentManager()
        let appInfra = AIAppInfra.build { (builder) in
            builder?.consentManager = consentManager
            asyncExpectation.fulfill()
        }
        waitForExpectationsFullfillment() {
            XCTAssertNotNil(appInfra?.consentManager, "Consent Manager is not initialised")
            XCTAssert(appInfra?.consentManager === consentManager)
        }
    }
    
    private func waitForExpectationsFullfillment(completionHandler: @escaping ()->()) {
        self.waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                self.recordFailure(withDescription: "Failed to complete Fetching after 5 seconds.", inFile: #file, atLine: #line, expected: true)
            } else {
                completionHandler()
            }
        }
    }
    
}
