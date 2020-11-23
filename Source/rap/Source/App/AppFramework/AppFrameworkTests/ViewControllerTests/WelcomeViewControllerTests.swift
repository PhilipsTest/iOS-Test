/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class WelcomeViewControllerTests: XCTestCase {

    var welcomeViewController: WelcomeViewController! = nil

    let viewOptionsWithVideoID = [
        Constants.WELCOME_BACKGROUND_IMAGE_KEY: "" as AnyObject,
        Constants.WELCOME_VIDEO_ID_KEY: "app.splashvideo" as AnyObject,
        Constants.WELCOME_VIDEO_THUMBNAIL_KEY: "VideoThumbnail" as AnyObject,
        Constants.TITLE_KEY: [Constants.WELCOME_TEXT_KEY: "Title" as AnyObject] as AnyObject,
        Constants.WELCOME_DESCRIPTION_KEY: [Constants.WELCOME_TEXT_KEY: "Description" as AnyObject] as AnyObject
    ]

    let viewOptionsWithoutVideoID = [
        Constants.WELCOME_BACKGROUND_IMAGE_KEY: "" as AnyObject,
        Constants.TITLE_KEY: [Constants.WELCOME_TEXT_KEY: "Title" as AnyObject] as AnyObject,
        Constants.WELCOME_DESCRIPTION_KEY: [Constants.WELCOME_TEXT_KEY: "Description" as AnyObject] as AnyObject
    ]

    override func setUp() {
        super.setUp()
        self.welcomeViewController = WelcomeViewController()
    }

    override func tearDown() {
        self.welcomeViewController = nil
        super.tearDown()
    }

    func testCreatesVideoChildPageWhenOptionsContainVideoID() {
        let childViewController = welcomeViewController.createChildViewController(viewOptionsWithVideoID)
        XCTAssertEqual(String(describing: type(of: childViewController)), String(describing: WelcomeVideoChildViewController.self))
    }

    func testCreatesRegularChildPageWhenOptionsDoesNotContainVideoID() {
        let childViewController = welcomeViewController.createChildViewController(viewOptionsWithoutVideoID)
        XCTAssertEqual(String(describing: type(of: childViewController)), String(describing: WelcomeChildViewController.self))
    }
    
}
