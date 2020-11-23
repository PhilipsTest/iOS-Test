//
//  AppDelegate.swift
//  PIMDemoApp
//
//  Created by Chittaranjan Sahu on 2/27/19.
//  Copyright © 2019 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
import AppInfra
import AdobeMobileSDK
import FLEX

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appInfraHandler:AIAppInfra?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            let configuration = UIDThemeConfiguration(colorRange: .groupBlue,
                                                      tonalRange: .ultraLight,
                                                      navigationTonalRange: .bright)
            let theme = UIDTheme(themeConfiguration: configuration)
            UIDThemeManager.sharedInstance.setDefaultTheme(theme: theme, applyNavigationBarStyling: true)
            ADBMobile.overrideConfigPath(Bundle.main.path(forResource: "ADBMobileConfig", ofType: "json")!)
            appInfraHandler = AIAppInfra(builder: nil)
            return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let navController = self.window?.rootViewController as? UINavigationController
        let viewController = navController?.viewControllers.first as? UDIDemoViewController
        viewController?.handleRedirectURI(url: url)
        return true
    }

}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            FLEXManager.shared.showExplorer()
        }
    }
}
