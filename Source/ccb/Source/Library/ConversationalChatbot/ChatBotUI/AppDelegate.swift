/* Copyright (c) Koninklijke Philips N.V., 2017
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/
/** © Koninklijke Philips N.V., 2016. All rights reserved. */


import UIKit
import AppInfra
import PhilipsUIKitDLS
import AdobeMobileSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appInfraHandler:AIAppInfra!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let configuration = UIDThemeConfiguration(colorRange: .groupBlue,
                                                  tonalRange: .ultraLight,
                                                  navigationTonalRange: .bright)
        let theme = UIDTheme(themeConfiguration: configuration)
        UIDThemeManager.sharedInstance.setDefaultTheme(theme: theme, applyNavigationBarStyling: true)
        ADBMobile.overrideConfigPath(Bundle.main.path(forResource: "ADBMobileConfig", ofType: "json")!)
        appInfraHandler = AIAppInfra(builder: nil)
        
        self.setThemeConfiguration()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    
    //UI Configuration
    func setThemeConfiguration() {
        let storedDefault = UserDefaults.standard
        let colorRange:Int? = storedDefault.integer(forKey: Constants.THEME_COLOR_RANGE)
        let tonalRange:Int? = storedDefault.integer(forKey: Constants.THEME_TONAL_RANGE)
        let navTonalRange:Int? = storedDefault.integer(forKey: Constants.THEME_NAVTONAL_RANGE)
        
        var configuration:UIDThemeConfiguration?
        var theme: UIDTheme?
        if let themeColorRange = colorRange, let themeTonalRange = tonalRange, let themeNavTonalRange = navTonalRange {
            if themeColorRange == 0 && themeTonalRange == 0 && themeNavTonalRange == 0 {
                configuration = UIDThemeConfiguration(colorRange: .groupBlue, tonalRange: .ultraLight, navigationTonalRange: .bright)
            } else {
                if let color = UIDColorRange(rawValue: themeColorRange), let tonal = UIDTonalRange(rawValue: themeTonalRange), let navTonal = UIDTonalRange(rawValue: themeNavTonalRange) {
                    configuration = UIDThemeConfiguration(colorRange: color, tonalRange: tonal, navigationTonalRange: navTonal)
                }
            }
            if let config = configuration {
                theme = UIDTheme(themeConfiguration: config)
            }
            if let themeConfig = theme {
                UIDThemeManager.sharedInstance.setDefaultTheme(theme: themeConfig, applyNavigationBarStyling: true)
            }
        }
    }

}

