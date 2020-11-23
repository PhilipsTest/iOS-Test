/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class WelcomePageViewControllerTests: XCTestCase {

    var welcomePageViewController : WelcomePageViewController! = nil

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let welcomeNavCntrlr = storyboard.instantiateViewController(withIdentifier: "welcomePageViewController")
        welcomePageViewController = welcomeNavCntrlr.children[0] as? WelcomePageViewController
        welcomePageViewController.loadViewIfNeeded()
    }

    func testConfigureButtonsForFirstIndex() {
        welcomePageViewController.configureButtonsForIndex(0)
        XCTAssertFalse(welcomePageViewController.btnForwardPage.isHidden)
        XCTAssertFalse(welcomePageViewController.btnSkipWelcome.isHidden)
        XCTAssertTrue(welcomePageViewController.btnDone.isHidden)
    }

    func testConfigureButtonsForSecondIndex() {
        welcomePageViewController.configureButtonsForIndex(1)
        XCTAssertFalse(welcomePageViewController.btnForwardPage.isHidden)
        XCTAssertFalse(welcomePageViewController.btnSkipWelcome.isHidden)
    }

    func testConfigureButtonsForLastIndex() {
        welcomePageViewController.configureButtonsForIndex(8)
        XCTAssertTrue(welcomePageViewController.btnForwardPage.isHidden)
        XCTAssertTrue(welcomePageViewController.btnSkipWelcome.isHidden)
        XCTAssertFalse(welcomePageViewController.btnDone.isHidden)
    }

}
