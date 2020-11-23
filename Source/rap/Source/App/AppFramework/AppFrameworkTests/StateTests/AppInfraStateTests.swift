//
//  AppInfraStateTests.swift
//  AppFrameworkTests
//
//  Created by Philips on 5/15/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework
@testable import AppInfraMicroApp

class AppInfraStateTests: BaseXCTestCase {
    var appInfraState : DemoAppInfraState?
    var viewController : UIViewController?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewControllerNil(){
        
        appInfraState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.DemoAppInfraState) as? DemoAppInfraState
        viewController = appInfraState?.getViewController()
        XCTAssertNotNil(viewController)
        
        doAssertion(.xctAssertNotNil, assertObject:appInfraState?.getViewController() , derivedState: nil, originalState: nil)
    }

    
}
