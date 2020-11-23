//
//  UserOptinState.swift
//  AppFramework
//
//  Created by philips on 7/18/18.
//  Copyright © 2018 Philips. All rights reserved.
//

import Foundation
import UAPPFramework
import PhilipsRegistration

class UserOptinState: BaseState {
    
    lazy var userRegistrationState = (Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistration)) as? UserRegistrationState
    
    override init() {
        super.init(stateId : AppStates.UserOptin)
    }
    
    override func getViewController() -> UIViewController? {
        userRegistrationState?.userRegistrationLaunchInput?.registrationFlowConfiguration.loggedInScreen = .marketingOptIn
        if let launchInput = userRegistrationState?.userRegistrationLaunchInput {
            AppInfraSharedInstance.sharedInstance.appInfraHandler?.consentManager.fetchConsentState(forConsentDefinition: CookieConsentProvider.getCookieConsentDefination(), completion: { (consentStatus, error) in
                if consentStatus?.status == ConsentStates.active {
                    let statusValue = AppInfraSharedInstance.sharedInstance.appInfraHandler?.abtest.getTestValue("optin_Image", defaultContent: "Kitchen", updateType: .appStart)
                    if statusValue == "Sonicare" {
                        launchInput.registrationContentConfiguration.optinImage = #imageLiteral(resourceName: "Sonicare")
                        launchInput.registrationContentConfiguration.optInTitleText = "Here's what You Have To Look Forward To:"
                        launchInput.registrationContentConfiguration.optInQuessionaryText = "Custom Reward Coupons, Holiday Surprises, VIP Shopping Days "
                        launchInput.registrationContentConfiguration.optInDetailDescription = ""
                    } else {
                        launchInput.registrationContentConfiguration.optinImage = #imageLiteral(resourceName: "Kitchen")
                    }
                } else {
                    launchInput.registrationContentConfiguration.optinImage = #imageLiteral(resourceName: "Norelco")
                }
            })
            if let urViewController = userRegistrationState?.userRegistrationInterface?.instantiateViewController(launchInput, withErrorHandler: { (error) in AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "UserOptinState", message: "Unable to launch UserOptinState screen from User-Registration")}) {
                return urViewController
            }
        }
        return nil
    }
}
