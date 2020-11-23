//
//  PrivacySettingsStateTests.swift
//  AppFrameworkTests
//
//  Created by philips on 4/2/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import XCTest
import AppInfra
import ConsentWidgets
@testable import AppFramework


class PrivacySettingsStateTests: XCTestCase {

    var privacySettingsState : PrivacySettingsState?
    var returnedViewController: UIViewController?

    func testPrivacySettingsStateViewController() {
        privacySettingsState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.PrivacySettings) as? PrivacySettingsState
        returnedViewController = privacySettingsState?.getViewController()
        XCTAssertNotNil(returnedViewController)
    }
    
    func testPrivacySettingStateViewControllerToNil() {
        privacySettingsState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.PrivacySettings) as? PrivacySettingsState
        let dependency = ConsentWidgetsDependencies()
        dependency.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        privacySettingsState?.consentWidgetInterface = ConsentWidgetsInterfaceMock(dependencies: dependency , andSettings: nil)
        returnedViewController = privacySettingsState?.getViewController()
        XCTAssertNil(returnedViewController)
    }
}

