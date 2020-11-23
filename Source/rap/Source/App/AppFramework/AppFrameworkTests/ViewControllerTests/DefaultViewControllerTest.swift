//
//  ChapterDetailViewControllerTest.swift
//  AppFramework
//
//  Created by Philips on 9/26/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework

class DefaultViewControllerTest: XCTestCase {
    var deafultViewController: DefaultViewController?
    
    
    override func tearDown() {
        deafultViewController = nil
        super.tearDown()
    }
    
    func testDefaultViewControllerNilCheck(){
        let storyboard = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil)
        let defaultViewController = storyboard.instantiateViewController(withIdentifier: Constants.DEFAULT_VIEWCONTROLLER_STORYBOARD_ID)
        defaultViewController.loadViewIfNeeded()
        defaultViewController.viewWillAppear(false)
        XCTAssertNotNil(defaultViewController)
    }
    
}

