//
//  CookieState.swift
//  AppFramework
//
//  Created by Philips on 8/22/18.
//  Copyright © 2018 Philips. All rights reserved.
//

/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
import UAPPFramework
import PlatformInterfaces

/** CookieState is inherited from BaseState */
class CookieState: BaseState {
    var isCookieConsentGiven:Bool = false
    var cookieConsentInterface:CookieConsentInterface?
    
    override init() {
        super.init(stateId : AppStates.CookieConsent)
        if let appinfra = AppInfraSharedInstance.sharedInstance.appInfraHandler{
            cookieConsentInterface =  CookieConsentInterface(withappInfra: appinfra)
            cookieConsentInterface?.fetchCookieConsent(consentDefinition: CookieConsentProvider.getCookieConsentDefination(), completion: { [weak self](value, error) in
                guard error == nil else{
                    self?.isCookieConsentGiven = false
                    return
                }
                if(value?.status == ConsentStates.active){
                    self?.isCookieConsentGiven = true
                }else{
                    self?.isCookieConsentGiven = false
                }
                return
            })
            
        }
    }
    
    public func getCookieConsentInterface() ->CookieConsentInterface?{
        return cookieConsentInterface
    }
    
    override func getViewController() -> UIViewController? {
        let cookieVC : UIViewController?
        let storyBoard = UIStoryboard(name: Constants.COOKIE_STORYBOARD_ID, bundle: nil)
        cookieVC = storyBoard.instantiateViewController(withIdentifier:Constants.COOKIE_VIEWCONTROLLER_ID)
        return cookieVC
    }
}
