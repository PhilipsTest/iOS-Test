/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import PhilipsUIKitDLS

class StateBasedNavigationPresenter: BasePresenter {

    var state: String

    init(_viewController: UIViewController?, forState state: String) {
        self.state = state
        super.init(_viewController: _viewController)
    }

    override func onEvent(_ componentId: String) -> UIViewController? {
        var loadVC : UIViewController?

        do {
            let nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(state), forEventId: componentId)

            if nextState != nil {
                loadVC = nextState?.getViewController()
            }

            if loadVC != nil {
                if(nextState?.stateId == AppStates.UserRegistrationWelcome || nextState?.stateId == AppStates.CookieConsent){
                    let screenToLoadModel = ScreenToLoadModel(viewControllerLoadType: .Push, animates: true, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                    Launcher.navigateToViewController(presenterBaseViewController, toViewController: loadVC, loadDetails: screenToLoadModel)
                }else{
                    let screenToLoadModel = ScreenToLoadModel(viewControllerLoadType: .Root, animates: true, modalTransitionStyle: nil, modalPresentationStyle: nil, segueId: nil)
                    Launcher.navigateToViewController(nil, toViewController: loadVC, loadDetails: screenToLoadModel)
                }
                
            }
        } catch {
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_FLOW_MANAGER_TAG, message: (error as! FlowManagerErrors).message())
            let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
            Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: presenterBaseViewController)

        }
        return loadVC
    }
}
