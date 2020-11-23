//
//  MYALaunchInputTest.swift
//  MyAccountTests
//
//  Created by Philips on 14/02/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import XCTest
@testable import MyAccountDev


class MYALaunchInputTest: XCTestCase {
    var launchInput : MYALaunchInput?
    override func setUp() {
        super.setUp()
         launchInput = MYALaunchInput()
    }
    
    func testProfileMenu() {
        launchInput?.profileMenuList = ["TestProfile"]
        XCTAssertEqual(launchInput?.profileMenuList?.count, 1,"The menu is not set properly")
         launchInput?.profileMenuList = []
         XCTAssertEqual(launchInput?.profileMenuList?.count, 0,"The menu is not set properly")
    }
    
    func testSettingMenu() {
        launchInput?.settingMenuList = ["TestSetting"]
        XCTAssertEqual(launchInput?.settingMenuList?.count, 1,"The menu is not set properly")
       launchInput?.settingMenuList = []
        XCTAssertEqual(launchInput?.settingMenuList?.count, 0,"The menu is not set properly")
    }
    
    func testAdditonalTab(){
        var tab = MYATabConfig(tabName: "Test", controller: UIViewController())
       launchInput?.additionalTabConfiguration = tab
        XCTAssertEqual(launchInput?.additionalTabConfiguration, tab,"The tab is not generated")
    }
    
    
}
