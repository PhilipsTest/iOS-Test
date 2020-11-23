//
//  NSBundleTest.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 24/02/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest

@testable import PhilipsProductRegistrationDev

class NSBundleTests: XCTestCase {
    
   func testLocalBundle() {
        let bundle = Bundle.localBundle()
        XCTAssertNotNil(bundle)
    }
    
    func testApplicationVersionNumber() {
        let version = Bundle.applicationVersionNumber
        XCTAssertNotNil(version)
    }
    
    func testApplicationBuildNumber() {
        let build = Bundle.applicationBuildNumber
        XCTAssertNotNil(build)
    }
}
