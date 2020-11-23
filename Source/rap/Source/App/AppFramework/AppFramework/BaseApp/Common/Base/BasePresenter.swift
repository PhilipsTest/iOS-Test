/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit
import UAPPFramework

class BasePresenter : NSObject {
    
    weak fileprivate(set) var presenterBaseViewController: UIViewController?
    fileprivate(set) var stateOfPresenter : BaseState?
    
    init(_viewController: UIViewController?) {
        super.init()
        setBaseViewControllerForPresenter(_viewController)
        setPresenterState(Constants.APPDELEGATE?.getFlowManager().getCurrentState())
    }
    
    func onEvent(_ componentId: String) -> UIViewController? {
        assert(false,"onEvent method should be overrided in BasePresenter child class")
        return nil
    }
    
    fileprivate func setBaseViewControllerForPresenter(_ baseViewController : UIViewController?) {
        presenterBaseViewController = baseViewController
    }
    
    func setPresenterState(_ newState : BaseState?) {
        stateOfPresenter = newState
    }
    
    
}
