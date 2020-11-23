//
//  ChapterDetailViewControllerTest.swift
//  AppFramework
//
//  Created by Philips on 9/26/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest
@testable import AppFramework
import PhilipsUIKitDLS

class AboutViewControllerTest: XCTestCase {

    
    var aboutViewController: AboutViewController?
    var aboutViewControllerPresenterMock:AboutPresenter?
    let hyperLinkModel:UIDHyperLinkModel? = UIDHyperLinkModel()
    //var presenter : AboutPresenter?
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: Constants.ABOUT_STORYBOARD_NAME, bundle:nil)
        aboutViewController = storyBoard.instantiateViewController(withIdentifier: Constants.ABOUT_VIEWCONTROLLER_STORYBOARD_ID) as? AboutViewController
        aboutViewControllerPresenterMock = AboutPresenter(_viewController: aboutViewController)
        aboutViewController?.presenter = aboutViewControllerPresenterMock
        aboutViewController?.loadViewIfNeeded()
        aboutViewController?.viewWillAppear(false)
    }
    
    override func tearDown() {
        aboutViewController = nil
        aboutViewControllerPresenterMock = nil
        super.tearDown()
    }
    
    func testAboutScreenLabels() {
        XCTAssertNotNil(aboutViewController?.aboutView.privacyPolicyLabel)
        XCTAssertNotNil(aboutViewController?.aboutView.applicationNameLabel)
        XCTAssertNotNil(aboutViewController?.aboutView.copyrightLabel)
        XCTAssertNotNil(aboutViewController?.aboutView.disclosureStatementLabel)
        XCTAssertNotNil(aboutViewController?.aboutView.termsAndConditionLabel)
    }
}
