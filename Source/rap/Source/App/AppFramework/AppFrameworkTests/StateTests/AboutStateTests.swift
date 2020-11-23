//
//  AboutStateTests.swift
//  AppFramework
//
//  Created by Philips on 1/17/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework

class AboutStateTests: XCTestCase {
    
    func testNavigateCheckNil() {
        XCTAssertNotNil(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.About)?.getViewController())
    }
}
