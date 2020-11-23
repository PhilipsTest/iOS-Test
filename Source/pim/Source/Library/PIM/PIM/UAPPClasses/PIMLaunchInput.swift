/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import UAPPFramework

/**
This enum holds the consents for UDI.
- Since: 2001.0
*/
public enum PIMConsent: String {
    /**
    Setting of ab_testing value will set the PIL  to run ABTesting in the backend
    - Since: 2001.0
    */
    case ABTestingConsent = "ab_testing"
}

/**
This enum holds the configurations to launch different endpoint in UDI CLP page.
- Since: 2005.0
*/
public enum PIMLaunchFlow: String {
    /**
    Launch always login flow in UDI CLP page
    - Since: 2005.0
    */
    case login = "login"
    
    /**
    Launch always create account flow in UDI CLP page
    - Since: 2005.0
    */
    case create = "create"
    
    /**
    Launch login flow in UDI CLP page if no valid session is found else automatically gets logged in using the exisitng session.
    - Since: 2005.0
    */
    case noPrompt = "noPrompt"
}

/**
PIMLaunchInput holds all the Configuration Values needed to Launch and Customize UDI behaviour
- Since: 1904.0
*/
@objcMembers open class PIMLaunchInput: UAPPLaunchInput {
    
    /**
    Set this value to pass launch flow of UDI, which will be used while initialising PIM
     - **Default value is noPrompt.**

    - Since: 2005.0
    */
    open var pimLaunchFlow: PIMLaunchFlow? {
        didSet {
            PIMSettingsManager.sharedInstance.setPIMLaunchFLow(launchFLow: pimLaunchFlow ?? PIMLaunchFlow.noPrompt)
        }
    }
    
    /**
    Default initializer to initialize PIMLaunchInput
    - Since: 1904.0
    */
    public override init() {
        super.init()
    }
    
    /**
    Overiden initializer to initialize PIMLaunchInput with consents
    - Parameter consents: consents to be injected for launching UDI behavior rewuired by UApp
    - Since: 1904.0
    */
    public init?(consents: [PIMConsent]) {
        if consents.isEmpty {
            return nil
        }
        var consentList = [String]()
        for consent in consents {
            consentList.append(consent.rawValue)
        }
        PIMSettingsManager.sharedInstance.setPIMConsents(consents: consentList)
        super.init()
    }
}
