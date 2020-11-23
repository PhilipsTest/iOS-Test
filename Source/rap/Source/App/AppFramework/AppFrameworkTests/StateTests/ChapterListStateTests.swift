//
//  ChapterListStateTests.swift
//  AppFramework
//
//  Created by Philips on 7/5/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework

class ChapterListStateTests: XCTestCase {
    
    func testNavigateCheckNil() {
        XCTAssertNotNil(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.TestDemoApps)?.getViewController())
    }
}
