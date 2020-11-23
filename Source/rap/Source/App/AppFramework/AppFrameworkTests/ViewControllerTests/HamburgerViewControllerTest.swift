//
//  HamburgerViewControllerTest.swift
//  AppFramework
//
//  Created by Philips on 9/26/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework

class HamburgerViewControllerTest: XCTestCase {

    func testHamburgerMenuViewControllerNilCheck(){
        let storyBoard = UIStoryboard(name: Constants.HAMBURGER_MENU_STORYBOARD_ID, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: Constants.HAMBURGER_MENU_CONTROLLER_STORYBOARD_ID)
        viewController.loadViewIfNeeded()
        XCTAssertNotNil(viewController)
    }
}
