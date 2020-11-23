/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS

/** 
 AboutViewController shows application details such as version and any other details About he App
 */
class AboutViewController:UIViewController,UIDAboutViewDelegate {
    func termsAndConditionsLinkClicked() {
        if let internetReachble = AppInfraSharedInstance.sharedInstance.appInfraHandler?.restClient.isInternetReachable(), internetReachble {
          _ = presenter?.onEvent(Constants.TERMS_AND_CONDITION_TEXT)
        } else {
            Utilites.showDLSAlert(withTitle: "Network Not Reachable", withMessage: "Please check network", buttonAction: [UIDAction(title: "OK", style: .primary)] , usingController: self)
        }
    }
    
    func privacyPolicyLinkClicked() {
        if let internetReachble = AppInfraSharedInstance.sharedInstance.appInfraHandler?.restClient.isInternetReachable(), internetReachble {
            TaggingUtilities.trackActionWithInfo(key: Constants.TAGGING_PRIVACY_POLICY_ACTION, params:nil)
            _ = presenter?.onEvent(Constants.PRIVACY_POLICY_TEXT ?? "")
        } else {
              Utilites.showDLSAlert(withTitle: "Network Not Reachable", withMessage: "Please check network", buttonAction: [UIDAction(title: "OK", style: .primary)] , usingController: self)
        }
    }

    var presenter : AboutPresenter?

    @IBOutlet var aboutView: UIDAboutView!
    override func viewDidLoad() {
        super.viewDidLoad()
       //invoking presenter for all the logic to implement
        presenter = AboutPresenter(_viewController: self)
        self.navigationItem.title = Utilites.aFLocalizedString("RA_AboutScreen_Title")
        
        
        //AppInfra logging
        AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: Constants.LOGGING_ABOUT_TAG, message: Constants.LOGGING_ABOUT_MESSAGE)
        aboutView.delegate = self
        
        //Change the content in the About
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        aboutView.applicationNameLabel.text = Utilites.aFLocalizedString("RA_HomeScreen_Title")
        
        if let appVersionNew = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) {
            if let versionString = Utilites.aFLocalizedString("RA_About_App_Version") {
                aboutView.versionLabel.text = versionString + " \(appVersionNew)"
            }
        }
        aboutView.copyrightLabel.text = "Copyright © \(formatter.string(from: NSDate() as Date)) Philips"
        aboutView.disclosureStatementLabel.text = Constants.ABOUTVIEW_BODYTEXT_MESSAGE

        let hyperLinkModel:UIDHyperLinkModel? = UIDHyperLinkModel()
        aboutView.privacyPolicyLabel.text = Constants.PRIVACY_POLICY_TEXT
        aboutView.termsAndConditionLabel.text = Constants.TERMS_AND_CONDITION_TEXT
        if let hyperLinkModelNew = hyperLinkModel {
            aboutView.privacyPolicyLabel.addLink(hyperLinkModelNew) { (range) in
                self.privacyPolicyLinkClicked()
            }
            aboutView.termsAndConditionLabel.addLink(hyperLinkModelNew) { (range) in
                self.termsAndConditionsLinkClicked()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //AppInfra Tagging
          TaggingUtilities.trackPageWithInfo(page: Constants.TAGGING_ABOUT_PAGE, params:nil)
    }
}


