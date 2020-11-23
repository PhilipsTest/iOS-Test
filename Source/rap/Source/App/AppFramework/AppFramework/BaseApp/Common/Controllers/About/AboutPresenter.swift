/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework

class AboutPresenter: BasePresenter {
    
      override func onEvent(_ componentId: String) -> UIViewController?  {
        let termsAndPrivacyHelper : TermsAndPrivacyHelperProtocol = TermsAndPrivacyHelper()

        switch componentId {
        case Constants.TERMS_AND_CONDITION_TEXT:
            termsAndPrivacyHelper.launchTermsAndConditions (fromViewController: presenterBaseViewController)
            break
        case Constants.PRIVACY_POLICY_TEXT:
            termsAndPrivacyHelper.launchPrivacyPolicy(fromViewController: presenterBaseViewController, withTitle: nil)
            break
        case Constants.PERSONAL_CONSENT_TEXT:
            termsAndPrivacyHelper.launchPersonalConsentDescription(fromViewController: presenterBaseViewController, withTitle: nil)
            break
        default:
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.debug, eventId: Constants.DEFAULT_TEXT, message: "")
    }
        return nil
    }
    
}
