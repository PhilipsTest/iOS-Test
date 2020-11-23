/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import AppInfra
import PhilipsUIKitDLS
import AdobeMobileSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var appInfraHandler: AIAppInfra?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = UIDThemeConfiguration(colorRange: .green,
                                                  tonalRange: .ultraLight,
                                                  navigationTonalRange: .bright)
        let theme = UIDTheme(themeConfiguration: configuration)
        UIDThemeManager.sharedInstance.setDefaultTheme(theme: theme, applyNavigationBarStyling: true)
        if let path = Bundle.main.path(forResource: "ADBMobileConfig", ofType: "json") {
            ADBMobile.overrideConfigPath(path)
        }
        self.appInfraHandler = AIAppInfra(builder: nil)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

