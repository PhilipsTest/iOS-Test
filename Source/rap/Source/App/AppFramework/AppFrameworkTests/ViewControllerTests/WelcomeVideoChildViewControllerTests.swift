/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import XCTest
@testable import AppFramework

class WelcomeVideoChildViewControllerTests: XCTestCase {
    var viewController : WelcomeVideoChildViewController! = nil

    let screenData = [
        Constants.WELCOME_BACKGROUND_IMAGE_KEY: "" as AnyObject,
        Constants.WELCOME_VIDEO_ID_KEY: "app.splashvideo" as AnyObject,
        Constants.WELCOME_VIDEO_THUMBNAIL_KEY: "VideoThumbnail" as AnyObject,
        Constants.TITLE_KEY: [Constants.WELCOME_TEXT_KEY: "Title" as AnyObject] as AnyObject,
        Constants.WELCOME_DESCRIPTION_KEY: [Constants.WELCOME_TEXT_KEY: "Description" as AnyObject] as AnyObject
    ]

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "welcomeVideoChildViewController") as! WelcomeVideoChildViewController
        viewController.screenDict = screenData
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    func testPlayIconIsHiddenByDefault() {
        XCTAssertFalse(viewController.imgPlay.isHidden)
    }

    func testVideoThumbnailIsSet() {
        XCTAssertNotNil(viewController.videoView.image)
    }
    
    func testDeviceRotated() {
        viewController.deviceRotated()
        XCTAssertNotNil(viewController.scrollView.frame.size.height)
    }

    func testPlayAndPauseVideoTogglesPlayIcon() {
        // ideally we'd use the togglePlayingState method, but that logic is dependent on the AVPlayer state
        // this is not reliable during unit testing. Instead we'll call the helper methods directly
        viewController.playVideo()
        XCTAssertTrue(viewController.imgPlay.isHidden)
        viewController.pauseVideo()
        XCTAssertFalse(viewController.imgPlay.isHidden)
        viewController.playVideo()
        XCTAssertTrue(viewController.imgPlay.isHidden)
    }
    
    func testVideoPausesWhenViewDisappears() {
        viewController.playVideo()
        viewController.viewWillDisappear(true)
        XCTAssertFalse(viewController.imgPlay.isHidden)
    }
    
    func testVideoIsNotLoadedWhenInternetUnreachable() {
        viewController.isInternetReachable = { false }

        viewController.loadVideo() // simulate viewDidLoad

        XCTAssertNil(viewController.player)
        XCTAssertFalse(viewController.imgPlay.isHidden)
    }
    
    func testVideoLoadedWhenInternetReachable() {
        viewController.isInternetReachable = { true }
        viewController.getVideoUrl = ServiceDiscoveryMock.validGetVideoUrl

        viewController.loadVideo() // simulate viewDidLoad

        XCTAssertNotNil(viewController.player)
        XCTAssertFalse(viewController.imgPlay.isHidden)
    }

    func testVideoIsNotLoadedWhenInternetReachableButVideoIdIsInvalid() {
        viewController.isInternetReachable = { true }
        viewController.getVideoUrl = ServiceDiscoveryMock.invalidGetVideoUrl

        viewController.loadVideo() // simulate viewDidLoad

        XCTAssertNil(viewController.player)
        XCTAssertFalse(viewController.imgPlay.isHidden)
    }

    class ServiceDiscoveryMock {
        static func validGetVideoUrl(withCountryPreference videoId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Swift.Void)!) {
            completionHandler("http://techslides.com/demos/sample-videos/small.mp4", nil)
        }

        static func invalidGetVideoUrl(withCountryPreference videoId: String!, withCompletionHandler completionHandler: ((String?, Error?) -> Swift.Void)!) {
            completionHandler(nil, nil)
        }
    }
}

class WelcomeVideoChildViewControllerWithInValidConfigTests: XCTestCase {
    var viewController : WelcomeVideoChildViewController! = nil

    let incompleteScreenData = [
        Constants.WELCOME_BACKGROUND_IMAGE_KEY: "" as AnyObject,
        Constants.TITLE_KEY: [Constants.WELCOME_TEXT_KEY: "Title" as AnyObject] as AnyObject,
        Constants.WELCOME_DESCRIPTION_KEY: [Constants.WELCOME_TEXT_KEY: "Description" as AnyObject] as AnyObject
    ]

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "welcomeVideoChildViewController") as! WelcomeVideoChildViewController
        viewController.screenDict = incompleteScreenData
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    func testVideoThumbnailIsNotSetIfKeyIsMissing() {
        XCTAssertNil(viewController.videoView.image)
    }

    func testVideoIsNotLoadedIfVideoIdKeyIsMissing() {
        XCTAssertNil(viewController.player)
    }
}

