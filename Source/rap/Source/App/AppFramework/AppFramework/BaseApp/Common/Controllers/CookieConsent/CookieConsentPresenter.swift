//
//  CookieConsentPresenter.swift
//  AppFramework
//
//  Created by Philips on 8/22/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import UIKit
import PhilipsUIKitDLS
import UAPPFramework
import PlatformInterfaces


class CookieConsentPresenter: BasePresenter {
    
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
                if(nextState?.stateId == AppStates.UserRegistrationWelcome ){
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
            Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: Constants.FLOW_MANAGER_ERROR, buttonAction: [alertAction], usingController: nil)
            
        }
        return loadVC
    }
    
    func getCookieConsent() -> CookieConsentInterface?{
        let state = Constants.APPDELEGATE?.getFlowManager().getState(self.state)
        if(state != nil){
            return (state as? CookieState)?.cookieConsentInterface
        }
        return nil
    }
    
    func setIsCookieConsentGiven(withValue value:Bool){
        let state = Constants.APPDELEGATE?.getFlowManager().getState(self.state)
        if(state !=  nil){
            (state as? CookieState)?.isCookieConsentGiven = value
        }else{
            (state as? CookieState)?.isCookieConsentGiven = false
        }
        
    }
}


