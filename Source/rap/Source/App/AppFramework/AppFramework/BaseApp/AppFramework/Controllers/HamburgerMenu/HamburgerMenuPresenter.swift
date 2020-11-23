/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/

import Foundation
import UIKit
import PhilipsUIKitDLS
import UAPPFramework

protocol HamburgerMenuDelegate {
    func didSelectHamburgerMenu(selectedStateData: BAHamburgerMenuData)
}

class HamburgerMenuPresenter: BasePresenter {
    
    var menuViewController : UIViewController?
    
    override func onEvent(_ componentId: String) -> UIViewController? {
        var loadVC : UIViewController?
        var nextState : BaseState?
        
        do {
            nextState = try Constants.APPDELEGATE?.getFlowManager().getNextState(Constants.APPDELEGATE?.getFlowManager().getState(AppStates.HamburgerMenu), forEventId: componentId)
            if nextState != nil {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.info, eventId: "\(Constants.LOGGING_HAMBURGERMENU_SELECTION) : \(String(describing: nextState!))" , message: Constants.LOGGING_FLOW_MANAGER_TAG)
                if let listner = (Utilites.getDefaultViewController() as? StateCommunicationListener?){
                    nextState?.setStateCompletionDelegate(listner)
                }
                loadVC = nextState?.getViewController()
            }
        } catch {
            AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: Constants.LOGGING_FLOW_MANAGER_TAG, message: (error as! FlowManagerErrors).message())
            let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
            Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: menuViewController ?? nil)
        }
        return loadVC
    }
}
