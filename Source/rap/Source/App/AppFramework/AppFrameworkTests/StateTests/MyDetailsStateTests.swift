//
//  MyDetailsStateTests.swift
//  AppFrameworkTests
//
//  Created by Nikilesh on 4/2/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework

class MyDetailsStateTests: XCTestCase {
    
    var myDetailsState : MyDetailsState?
    var returnedViewController: UIViewController?
    
    override func setUp() {
        super.setUp()
        returnedViewController = nil
    }
    
    func testMyDetailsState() {
        myDetailsState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.MyDetails) as? MyDetailsState
        returnedViewController = myDetailsState?.getViewController()
        XCTAssertNotNil(returnedViewController)
    }
    
    func testMyDetailsGetViewControllerNil() {
        myDetailsState?.userRegistrationState = nil
        returnedViewController = myDetailsState?.getViewController()
        XCTAssertNil(returnedViewController)
    }
    
}
