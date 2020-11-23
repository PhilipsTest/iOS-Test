//
//  MYAInterfaceTests.swift
//  MyAccountTests
//
//  Created by leslie on 22/11/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import MyAccountDev
import AppInfra

class MYAInterfaceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Bundle.loadSwizzler()
    }
    
    func testInterface() {
        let appinfra = AIAppInfra.init(builder: nil)
        let myaDependencies = MYADependencies()
        myaDependencies.appInfra = appinfra
        let _ = MYAData.setup(myaDependencies)
        let myaInterface = MYAInterface(dependencies: myaDependencies, andSettings: MYASettings())
        let launchInput = MYALaunchInput()
        launchInput.userDataProvider = UserDataInterfaceMock()

        let vc  = myaInterface.instantiateViewController(launchInput, withErrorHandler: nil)
        XCTAssertNotNil(vc)
        
        launchInput.userDataProvider = UserDataInterfaceMockNotLoggindIn()
        let vc1  = myaInterface.instantiateViewController(launchInput, withErrorHandler: nil)
        XCTAssertNil(vc1)

    }
}
