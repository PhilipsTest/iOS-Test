/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework

class TermsAndPrivacyState: BaseState {
    
    override init() {
        super.init(stateId : AppStates.TermsAndPrivacy)
    }
    
    //MARK: BaseState implementation methods
    /** Navigate to AboutViewController Class
     - returns : Viewcontroller that needs to be loaded or navigated to*/
    override func getViewController() -> UIViewController? {
        let termsAndPrivacyVC : UIViewController?
        let storyBoard = UIStoryboard(name: Constants.TERMS_AND_PRIVACY_STORYBOARD_NAME, bundle: nil)
        termsAndPrivacyVC = storyBoard.instantiateViewController(withIdentifier: Constants.TERMS_AND_PRIVACY_STORYBOARD_ID)
        return termsAndPrivacyVC
    }
}
