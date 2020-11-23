/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import PhilipsUIKitDLS


/** ViewController to show Launch screen if any customisation is required in the UI presentation */
class SplashViewController: UIViewController {
    
    //MARK: Variables Declaration
    
    //MARK: Default Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //AppInfra Tagging
        TaggingUtilities.trackPageWithInfo(page: Constants.TAGGING_SPLASH_PAGE, params: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utilites.showActivityIndicator(with: Constants.APP_SCREEN_SETUP_MESSAGE, using: self)
        Constants.APPDELEGATE?.getFlowManager().initialize(withAppFlowJsonPath: (Bundle.main.path(forResource: Constants.FLOW_CONFIG_FILE_NAME, ofType: Constants.JSON_TYPE)!), successBlock: {
            // get a reference to the app delegate

            Utilites.removeActivityIndicator(onCompletionExecute: nil)
            self.loadFirstState()
            }, failureBlock: { (error) in
                Utilites.removeActivityIndicator(onCompletionExecute: nil)
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_FLOW_MANAGER_TAG, message: error.message())
                let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
                Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: nil)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension SplashViewController {
    
    func loadFirstState() {
        do {
            if var rootVC = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.Splash), forEventId: "onAppStartEvent")?.getViewController() {
                if (!rootVC.isKind(of: UINavigationController.self) && !rootVC.isKind(of:UITabBarController.self)){
                    rootVC = AFBaseNavigationController(rootViewController: rootVC)
                }
                let loadDetails = ScreenToLoadModel(viewControllerLoadType: .Root, animates: false, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                Launcher.navigateToViewController(nil, toViewController: rootVC, loadDetails: loadDetails)
            }
        } catch {
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_FLOW_MANAGER_TAG, message: (error as! FlowManagerErrors).message())
            let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
            Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: nil)
        }
    }
}
