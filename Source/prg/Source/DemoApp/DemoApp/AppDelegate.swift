//
//  AppDelegate.swift
//  PPROneRoofDemo
//
//  Created by Abhishek on 21/03/17.
//  Copyright © 2017 Abhishek. All rights reserved.
//

import UIKit
import AdobeMobileSDK
import AppInfra
import PhilipsUIKitDLS
import PhilipsRegistration
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appInfra: AIAppInfra?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Needs to update universal link.
        WXApi.registerApp("wxbdf2ab8822f6022f", universalLink: "https://www.philips.com/udi/universal-links/com.philips.apps.registration.ent")
        self.loadAdobeJSON()
        self.configureNavigationBar()
        appInfra = AIAppInfra.init(builder: nil)

        return true
    }

    func loadAdobeJSON() {
        ADBMobile.overrideConfigPath(Bundle(for: object_getClass(self)!).path(forResource: "ADBMobileConfig", ofType: "json"))
    }

    func configureNavigationBar() {
        UIDThemeManager.sharedInstance.setDefaultTheme(theme: UIDTheme(), applyNavigationBarStyling: true);
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return DIUser.application(app, open: url, options: options)
    }
        
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else {
            return false;
        }
        return DIUser.application(application, open: url, options: (userActivity.userInfo ?? [:]))
    }}

