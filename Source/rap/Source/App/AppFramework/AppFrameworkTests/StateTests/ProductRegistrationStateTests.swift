//
//  ProductRegistrationStateTests.swift
//  AppFramework
//
//  Created by Philips on 1/12/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest

@testable import  PhilipsRegistration
@testable import AppFramework
@testable import PhilipsProductRegistration

class ProductRegistrationStateTests: XCTestCase {
    var productRegistrationStateObj = ProductRegistrationState()
    
    override func setUp() {
        super.setUp()
        DIUserMock.sharedInstance.swizzleDIUserInstance()
    }
    
    func testControllerNilCheck(){
        
        // Testing Catalogue,Order, History Controller when user is logged in
        
        //Catalogue
        var nextState : BaseState?
        do {
            nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.ConsumerCare), forEventId:UnitTestConstants.CONSUMERCARE_MAIN_MENU_SELECTION_PR)
        } catch { }
        
        XCTAssertNotNil(nextState)
        if let prstate = nextState as? ProductRegistrationState {
            let dependency = PPRInterfaceDependency()
            dependency.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
            dependency.userDataInterface = UserDataInterfaceInstance.sharedInstance.userDataInterface
            let pprInterface = PPRInterfaceMock.init(dependencies: dependency, andSettings: nil)
            pprInterface.shouldreturn = true
            prstate.productRegistrationHandler = pprInterface
            XCTAssertNotNil(prstate.getViewController())
        }
    }
    
    func testPRErrorHandler(){
        
        // Testing Catalogue,Order, History Controller when user is logged in
        
        //Catalogue
        var nextState : BaseState?
        do {
            nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.ConsumerCare), forEventId: UnitTestConstants.CONSUMERCARE_MAIN_MENU_SELECTION_PR)
        } catch { }
        
        XCTAssertNotNil(nextState)
        if let prstate = nextState as? ProductRegistrationState {
            let dependency = PPRInterfaceDependency()
            dependency.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
            let pprInterface = PPRInterfaceMock.init(dependencies: dependency, andSettings: nil)
            prstate.productRegistrationHandler = pprInterface
            XCTAssertNil(prstate.getViewController())
        }
    }
}

class PPRInterfaceMock : PPRInterface {

    let ret = UIViewController.init()
    public var shouldreturn  = false
    
    override func instantiateViewController(_ launchInput: UAPPLaunchInput, withErrorHandler completionHandler: ((Error?) -> Void)?) -> UIViewController? {
        if shouldreturn == true {
            return ret
        } else {
            return nil
        }
    }
}
