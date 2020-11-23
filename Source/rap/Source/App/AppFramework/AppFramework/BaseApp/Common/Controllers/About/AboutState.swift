/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework

/** AboutState is inherited from BaseState */
class AboutState: BaseState {
    
    override init() {
        super.init(stateId : AppStates.About)
    }
    
    //MARK: BaseState implementation methods
    /** Navigate to AboutViewController Class
     - returns : Viewcontroller that needs to be loaded or navigated to*/
    override func getViewController() -> UIViewController? {
        let aboutVC : UIViewController?
        let storyBoard = UIStoryboard(name: Constants.ABOUT_STORYBOARD_NAME, bundle: nil)
        aboutVC = storyBoard.instantiateViewController(withIdentifier: Constants.ABOUT_VIEWCONTROLLER_STORYBOARD_ID)
        return aboutVC
    }
}
