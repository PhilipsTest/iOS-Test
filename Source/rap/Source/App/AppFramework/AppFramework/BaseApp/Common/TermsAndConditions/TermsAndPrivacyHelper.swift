/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import Foundation

protocol TermsAndPrivacyHelperProtocol {
    func launchTermsAndConditions(fromViewController : UIViewController?)
    func launchPrivacyPolicy(fromViewController : UIViewController?, withTitle: String?)
    func launchPersonalConsentDescription(fromViewController : UIViewController?, withTitle: String?)
}

class TermsAndPrivacyHelper: TermsAndPrivacyHelperProtocol {
    
    /** launchTermsAndConditions gets called when terms and condition is clicked, launch of terms and conditions happens via this method */
    func launchTermsAndConditions(fromViewController : UIViewController?) {
        loadWebView(fromViewController: fromViewController, withTitle: nil)
        UserDefaults.standard.set(Constants.TERMS_AND_CONDITION_LAUNCH, forKey: Constants.TYPE_OF_CONDITION_IDENTIFIER)
    }
    
    /** launchPrivacyPolicy gets called when privacy policy is clicked, launch of privacy policy happens via this method */
    func launchPrivacyPolicy(fromViewController : UIViewController?, withTitle: String?) {
        loadWebView(fromViewController: fromViewController, withTitle: withTitle)
        UserDefaults.standard.set(Constants.PRIVACY_POLICY_LAUNCH, forKey: Constants.TYPE_OF_CONDITION_IDENTIFIER)
    }
    
    /** launchPersonal Consent gets called when privacy policy is clicked, launch of privacy policy happens via this method */
    func launchPersonalConsentDescription(fromViewController : UIViewController?, withTitle: String?) {
        loadWebView(fromViewController: fromViewController, withTitle: withTitle)
        UserDefaults.standard.set(Constants.PERSONAL_CONSENT_LAUNCH, forKey: Constants.TYPE_OF_CONDITION_IDENTIFIER)
    }
        
    /** Load of terms and privacy view controller with a web view */
    func loadWebView(fromViewController : UIViewController?, withTitle: String?){
        do{
            if let nextState =  try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistrationWelcome), forEventId: Constants.TERMS_AND_PRIVACY_TEXT) {
                
                if let nextVC = nextState.getViewController() {
                    
                    if let viewController = nextVC as? UINavigationController,
                        let nextViewController = viewController.topViewController as? TermsAndPrivacyViewController {
                        nextViewController.titleString = withTitle
                    }
                    
                    let loadDetails = ScreenToLoadModel(viewControllerLoadType: .Modal, animates: true, modalTransitionStyle: .coverVertical , modalPresentationStyle: .fullScreen , segueId: nil)
                    
                    Launcher.navigateToViewController(fromViewController?.navigationController?.topViewController, toViewController: nextVC, loadDetails: loadDetails)
                }
            }
        }catch{
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "error", message:"Unable to load ViewController")
        }
    }
    
}

