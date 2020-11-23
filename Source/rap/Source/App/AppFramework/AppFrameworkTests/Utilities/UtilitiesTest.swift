//
//  UtilitiesTest.swift
//  AppFramework
//
//  Created by Philips on 1/17/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework
@testable import AppInfra

class UtilitiesTest: XCTestCase {
    
    func testReadFromFile(){
       let CTNArray =  Utilites.readDataFromFile(Constants.HAMBURGER_MENU_SCREEN_KEY) as? [[String:String]]
        XCTAssertNotNil(CTNArray)
    }
    
    func testGetCartIcon(){
        XCTAssertNotNil (Utilites.getCartIcon())
    }
    
    func testAssociatedObject(){
         var key: UInt8 = 0
         let errorHandler : ()->Bool = boolTest
        XCTAssertNotNil(Utilites.associatedObject(self, key: &key,initialiser: errorHandler))
    }
    func boolTest() -> Bool{
        return false
       }
    func testDefaultViewController(){
        let viewController = Utilites.getDefaultViewController()
        XCTAssertNotNil(viewController)
    }
    
    func testAFLocalizedString(){
        let value =
            AppInfraSharedInstance.sharedInstance.appInfraHandler?.languagePack.localizedString(forKey: "BA_You_are_not_LoggedIn")
        XCTAssertNotNil(value)
    }
    
    func testHandlePropertyForKey(){
        let value = Utilites.handlePropertyForKey(UserRegistrationState(), typeOfAccessor: .get, key: Constants.APPINFRA_APPIDENTITY_STATE, group: Constants.APPINFRA_TEXT, value: nil)
        XCTAssertNotNil(value)
    }
}
