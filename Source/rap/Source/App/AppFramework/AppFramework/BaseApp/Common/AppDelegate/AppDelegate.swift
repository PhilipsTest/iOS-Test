/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import PhilipsUIKitDLS
import FBSDKCoreKit
import PhilipsRegistration
import AdobeMobileSDK
import Firebase
import FirebaseInstallations

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {
    
    var window: UIWindow?
    var presenter : BasePresenter?
    var cartIcon : UIBarButtonItem?
    var appConnectionStatus : String?
    var centralManagerRestorationIdentifier = [String]()
    var isHybrisEnabled : Bool?
    var cookieConsentInterface:CookieConsentInterface?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        ADBMobile.overrideConfigPath(Bundle(for: object_getClass(self)!).path(forResource: Constants.ADBMOBILE_PATH, ofType: Constants.JSON_TYPE)!)
        // call firebase configure in appdelegate to configure your app with firebase this call should be done at the appdelegate only
        FirebaseApp.configure()
        _ = AppInfraSharedInstance.sharedInstance
        
        let instanceID = Installations.installations()
        // below call is to firebase to get the authToken of the app so that they can be added in firebase to test ABtest(the below call is a async call)
        instanceID.authToken { (tokenResult, error) in
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "Appdelegate", message: tokenResult?.authToken ?? "Instance id is nil")
        }
    
        loadSplash()
        var bundles = [Bundle]()
        bundles.append(Bundle.main)
        //Needs to update universal link.
        WXApi.registerApp("wx5b3bfa4e2970475e", universalLink: "Universal link")
        AppInfraSharedInstance.sharedInstance.appInfraHandler?.restClient.reachabilityManager.startMonitoring()
        NotificationCenter.default.addObserver(self, selector: #selector(networkConnectionAltered), name: NSNotification.Name.AFNetworkingReachabilityDidChange , object: nil)
        
        //UI Configuration
        setThemeConfiguration()
        
        guard launchOptions?[UIApplication.LaunchOptionsKey.bluetoothCentrals] == nil else {
            if let bluetoothCentrals = (launchOptions?[UIApplication.LaunchOptionsKey.bluetoothCentrals] as? [String]){
                self.centralManagerRestorationIdentifier = bluetoothCentrals
            }
            return true
        }
       
        let selector = #selector(TaggingUtilities.receiveTaggingData(notification:))
        NotificationCenter.default.addObserver(TaggingUtilities.classForCoder(), selector: selector, name: NSNotification.Name(rawValue:kAilTaggingNotification) , object: nil)
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        /* Firebase GDPR logic*/
        
        // developer mode enabled means we are setting the abtest cache time to 0(zero)
        if let appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler{
            cookieConsentInterface =  CookieConsentInterface(withappInfra:appInfra)
            cookieConsentInterface?.registerAndFetchCookieConsentValue(completion: { (status) in
                if (status){
                    appInfra.abtest.enableDeveloperMode(true)
                    Analytics.setAnalyticsCollectionEnabled(true)
                    appInfra.abtest.updateCache(success:{
                        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "AppDelegate", message: "Abtest update cache success")
                    }, error: {
                        error in
                        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: "AppDelegate", message: "Abtest returned error on update cache")
                    })
                }else{
                    Analytics.resetAnalyticsData()
                    Analytics.setAnalyticsCollectionEnabled(false)
                }
            })
        }
        return true
    }
    
    
    @objc func networkConnectionAltered() {
        guard AppInfraSharedInstance.sharedInstance.appInfraHandler?.restClient.reachabilityManager.isReachable == false else{
            return
        }
        return
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication){
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        TaggingUtilities.trackActionWithInfo(key: Constants.TAGGING_BACKGROUND, params:nil)
        
        //To avoid Leakage through App Snapshots setting view to 0 visibility
        window?.alpha = 0.0
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        return
        
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication){
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0;
        TaggingUtilities.trackPageWithInfo(page: Constants.TAGGING_FOREGROUND, params: nil)
        window?.alpha = 1.0

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ app: UIApplication,open url: URL,options:[UIApplication.OpenURLOptionsKey : Any]) -> Bool{
        guard ((Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistration) as? UserRegistrationState)?.openApplication(forApp: app, url: (url as URL), options: options)) == false else {
            return true
        }
        
        
        guard url.absoluteString.range(of: "telehealth.com") == nil else {
            if let nextState = try? Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.Welcome), forEventId: "welcome_Button_Skip") {
                let loadModel = ScreenToLoadModel(viewControllerLoadType: .Root, animates: false, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                if let hamburgerController = nextState.getViewController() as? HamburgerMenuViewController{
                Launcher.navigateToViewController(nil, toViewController: hamburgerController, loadDetails: loadModel)
                }
            }
            return true
        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else {
            return false;
        }
        return DIUser.application(application, open: url, options: (userActivity.userInfo ?? [:]))
    }

}


//MARK: Helper methods

extension AppDelegate {
    
    func loadSplash() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let rootVC = SplashState().getViewController() {
            let loadDetails = ScreenToLoadModel(viewControllerLoadType: .Root, animates: false, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
            Launcher.navigateToViewController(nil, toViewController: rootVC, loadDetails: loadDetails)
            window?.makeKeyAndVisible()
        }
    }
    
    func getFlowManager() -> BaseFlowManager {
        return FlowManager.sharedInstance
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
    
    //Commented to support non-Hybris Flow
    
    @objc func cartIconPressed() {
        /*
        if Constants.APPDELEGATE?.getFlowManager().getCondition(AppConditions.IsLoggedIn)?.isSatisfied() == true {
            if let nextState = Constants.APPDELEGATE?.getFlowManager().getState(AppStates.InAppPurchaseCart) as? InAppPurchaseCartState {
                if let nextVC = nextState.getViewController() {
                    let stateModel = ScreenToLoadModel(viewControllerLoadType: .Push, animates: true, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                    if let rootVC = Constants.APPDELEGATE?.window?.rootViewController as? UITabBarController {
                        if let topVC = (rootVC.selectedViewController as? UINavigationController)?.topViewController {
                            Launcher.navigateToViewController(topVC, toViewController: nextVC, loadDetails: stateModel)
                        }
                    } else {
                        if let topVC = Constants.APPDELEGATE?.window?.rootViewController?.childViewControllers.first {
                            Launcher.navigateToViewController(topVC, toViewController: nextVC, loadDetails: stateModel)
                        }
                    }
                }
            }
        } else {
            Utilites.showAlertWith(buttonTitles: [Constants.OK_TEXT!], title: Constants.APPFRAMEWORK_TITLE, message: Constants.LOGIN_MESSAGE, delegate: nil)
        }
        
    }
 */
    
}
}


