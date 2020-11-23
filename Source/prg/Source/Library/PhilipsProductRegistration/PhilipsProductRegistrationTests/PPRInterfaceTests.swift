//
//  PPRInterfaceTests.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 25/01/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
import PhilipsPRXClient
import PhilipsRegistration


@testable import PhilipsProductRegistrationDev

class PPRInterfaceTests: PPRBaseClassTests {
    
    func testAllocInterfaceObject() {
        let dependency: PPRInterfaceDependency = PPRInterfaceDependency()
        dependency.appInfra = self.appInfra
        dependency.userDataInterface = self.userDataInterface
        let productRegistrationInterface = PPRInterface(dependencies: dependency, andSettings: nil)
        XCTAssertNotNil(productRegistrationInterface)
    }
    
    func testInstantiateViewController() {
        let launchInput: PPRLaunchInput = PPRLaunchInput()
        let dependency: PPRInterfaceDependency = PPRInterfaceDependency()
        dependency.appInfra = self.appInfra
        dependency.userDataInterface = self.userDataInterface
        let productRegistrationInterface = PPRInterface(dependencies: dependency, andSettings: nil)
        XCTAssertNotNil(productRegistrationInterface)
        
        let viewController = productRegistrationInterface.instantiateViewController(launchInput, withErrorHandler: { ( error) in })
        
        if DIUser.getInstance().userLoggedInState.rawValue == UserLoggedInState.userLoggedIn.rawValue {
            XCTAssertNotNil(viewController)
        }
        else {
            XCTAssertNil(viewController)
        }
    }
}
