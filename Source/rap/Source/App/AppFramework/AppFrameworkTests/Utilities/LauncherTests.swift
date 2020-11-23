//
//  LauncherTests.swift
//  AppFramework
//
//  Created by Philips on 1/17/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import XCTest

@testable import AppFramework

class LauncherTests: XCTestCase {
    var window: UIWindow?
    var dummyViewController:UIViewController?

    override func setUp() {
        super.setUp()
         window = UIWindow(frame: UIScreen.main.bounds)
         window?.rootViewController = UIViewController()
         dummyViewController = UIViewController()
    }

    func testNavigateToRoot(){
        let loadDetails = getLoadDetails(.Root)
            XCTAssertNotNil(loadDetails)
        XCTAssertNotNil(dummyViewController)
        XCTAssertNotNil(window?.rootViewController)
          XCTAssertNotNil(Launcher.navigateToViewController(window?.rootViewController, toViewController: dummyViewController, loadDetails: loadDetails))
    }
    
    func testNavigateToSegue(){
        let loadDetails = getLoadDetails(.Segue)
        XCTAssertNotNil(loadDetails)
        XCTAssertNotNil(dummyViewController)
        XCTAssertNotNil(window?.rootViewController)
        XCTAssertNotNil(Launcher.navigateToViewController(window?.rootViewController, toViewController: dummyViewController, loadDetails: loadDetails))
    }
    func testNavigateToPush(){
        let loadDetails = getLoadDetails(.Push)
        XCTAssertNotNil(loadDetails)
        XCTAssertNotNil(dummyViewController)
        XCTAssertNotNil(window?.rootViewController)
        XCTAssertNotNil(Launcher.navigateToViewController(window?.rootViewController, toViewController: dummyViewController, loadDetails: loadDetails))
    }
    func testNavigateToEmbedSubview(){
        let loadDetails = getLoadDetails(.EmbedSubview)
        XCTAssertNotNil(loadDetails)
        XCTAssertNotNil(dummyViewController)
        XCTAssertNotNil(window?.rootViewController)
        XCTAssertNotNil(Launcher.navigateToViewController(window?.rootViewController, toViewController: dummyViewController, loadDetails: loadDetails))
    }
    func testNavigateToModal(){
        let loadDetails = getLoadDetails(.Modal)
        XCTAssertNotNil(loadDetails)
        XCTAssertNotNil(dummyViewController)
        XCTAssertNotNil(window?.rootViewController)
       XCTAssertNotNil(Launcher.navigateToViewController(window?.rootViewController, toViewController: dummyViewController, loadDetails: loadDetails))
    }
    func testNavigateToEmbedChild(){
        let loadDetails = getLoadDetails(.EmbedChild)
        XCTAssertNotNil(loadDetails)
        XCTAssertNotNil(dummyViewController)
        XCTAssertNotNil(window?.rootViewController)
        XCTAssertNotNil(Launcher.navigateToViewController(window?.rootViewController, toViewController: dummyViewController, loadDetails: loadDetails))
    }
    
    func testNavigateToRemoveChild(){
        let loadDetails = getLoadDetails(.RemoveChild)
        XCTAssertNotNil(loadDetails)
        XCTAssertNotNil(dummyViewController)
        XCTAssertNotNil(window?.rootViewController)
        XCTAssertNotNil(Launcher.navigateToViewController(window?.rootViewController, toViewController: dummyViewController, loadDetails: loadDetails))
    }

    func getLoadDetails(_ loadType :ViewControllerLoadType) -> ScreenToLoadModel{
        
        let loadDetails =   ScreenToLoadModel(viewControllerLoadType: loadType, animates: false, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
        
        return loadDetails
    }
}
