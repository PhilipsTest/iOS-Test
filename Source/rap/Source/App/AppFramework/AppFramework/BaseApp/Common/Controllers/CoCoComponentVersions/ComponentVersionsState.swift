/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import PhilipsUIKitDLS
import UAPPFramework

class ComponentVersionsState: BaseState {

    override init() {
        super.init(stateId: AppStates.ComponentVersions)
    }

    override func getViewController() -> UIViewController? {
        let componentVersionsVC : UIViewController?
        let storyBoard = UIStoryboard(name: Constants.COMPONENTVERSION_STORYBOARD_NAME, bundle: nil)
        componentVersionsVC = storyBoard.instantiateViewController(withIdentifier: Constants.COMPONENT_VIEWCONTROLLER_STORYBOARD_ID)
        return componentVersionsVC
    }
}
