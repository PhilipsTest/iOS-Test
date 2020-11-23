//
//  DemoTeleHealthStateTests.swift
//  AppFrameworkTests
//
//  Created by sumit prasad on 15/02/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import XCTest
@testable import AppFramework
@testable import TeleHealthServicesDemoUApp


class DemoTeleHealthStateTests: XCTestCase {
    
    private var state: DemoTeleHealthServicesState?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.state = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.DemoTeleHealthServices) as? DemoTeleHealthServicesState
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetViewController() {
        let controller1 = self.state?.getViewController()
        XCTAssertNotNil(controller1, "Controller returned is nil")
    }
    
}
