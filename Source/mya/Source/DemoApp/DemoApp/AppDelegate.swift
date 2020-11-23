//
//  AppDelegate.swift
//  DemoApp
//
//  Created by Hashim MH on 09/10/17.
//  Copyright © 2017 Philips. All rights reserved.
//

import UIKit
import PhilipsUIKitDLS
import AppInfra
import AdobeMobileSDK
import PhilipsRegistration
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appInfra: AIAppInfra!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        WXApi.registerApp("wxbdf2ab8822f6022f")
        loadAdobeJSON()
        UIDThemeManager.sharedInstance.setDefaultTheme(theme: UIDTheme(), applyNavigationBarStyling: true)

        if (appInfra == nil ){
            appInfra = AIAppInfra.init(builder: nil)
        }
        
        return true
    }
    
    func loadAdobeJSON() {
        ADBMobile.overrideConfigPath(Bundle(for: object_getClass(self)!).path(forResource: "ADBMobileConfig", ofType: "json"))
    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @objc  public func forceRefreshUIApperence() {
        let windows = UIApplication.shared.keyWindow
        if let window = windows{
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            window.rootViewController  = sb.instantiateInitialViewController()
            
        }
        
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return DIUser.application(app, open: url, options: options)
    }

}

