//
//  PPRUIConfigurationTests.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek Chatterjee on 02/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import PhilipsProductRegistrationDev

class PPRUIConfigurationTests: XCTestCase {
    
   func testUIConfiguartionObjectAllocation() {
        let configObject = PPRUIConfiguration()
        XCTAssertNotNil(configObject)
    }
}
