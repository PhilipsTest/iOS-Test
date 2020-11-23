//
//  CookieConsentCondition.swift
//  AppFramework
//
//  Created by Philips on 8/22/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import UAPPFramework
import PhilipsRegistration
import PlatformInterfaces

class CookieConsentCondition: BaseCondition {
    
    override init() {
        super.init(conditionId: AppConditions.IsCookieConsentProvided)
    }
    
    override func isSatisfied() -> Bool {
        if let isCookieConsentGiven = (Constants.APPDELEGATE?.getFlowManager().getState(AppStates.CookieConsent) as? CookieState)?.isCookieConsentGiven{
            return !isCookieConsentGiven
        }else{
            return true
        }
    }
}

class UserLoggedInCondition: BaseCondition {
    
    override init() {
        super.init(conditionId: AppConditions.IsUserVerified)
    }
    
    override func isSatisfied() -> Bool {
        var satisfied = false;
        if (DIUser.getInstance().userLoggedInState == .pendingVerification) {
            satisfied = true;
        }
        return satisfied
    }
}

