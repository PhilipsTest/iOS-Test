//
//  AIAppIdentityInterface.swift
//  AppInfra
//
//  Created by Philips on 9/19/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import UIKit


public class AIAppIdentityInterface: NSObject, AIAppIdentityProtocol {
    
    let kStateTest = "TEST"
    let kStateDevelopment = "DEVELOPMENT"
    let kStateStaging = "STAGING"
    let kStateAccepteance = "ACCEPTANCE"
    let kStateProduction = "PRODUCTION"
    let kStateInvalid = "INVALID"
    
    let kMicrositeId = "appidentity.micrositeId"
    let kState = "appidentity.appState"
    let kSector = "appidentity.sector"
    let kServiceDiscoveryEnvironment = "appidentity.serviceDiscoveryEnvironment"
    
    let kAppIdentityGroupName = "appinfra"
    let kAIAIEventID = "AIAppIdentity"
    let SDEnvironmentProduction = "PRODUCTION"
    let SDEnvironmentStaging = "STAGING"
    
    @objc var dictAppIdentity:Dictionary<AnyHashable,Any> = [:]
    var aiAppInfra: AIAppInfraProtocol?
    
    @objc public init(appInfra: AIAppInfraProtocol) {
        aiAppInfra = appInfra
        super.init()
        let message = "Initializing with appinfra :\(appInfra)"
        AIInternalLogger.log(AILogLevel.debug, eventId: kAIAIEventID, message: message)
        _ = getAppIdentityConfigDictionary()
    }
    
    @objc public func getMicrositeId() -> String {
        if dictAppIdentity.isEmpty{
            dictAppIdentity = getAppIdentityConfigDictionary()
        }
        var micositeIdentifier: String = ""
        if let strMicrositeID = dictAppIdentity[kMicrositeId] as? String{
            micositeIdentifier = strMicrositeID
        }
        return micositeIdentifier
    }
    
    @objc public func getAppState() -> AIAIAppState {
        // do case insensitive search
        if dictAppIdentity.isEmpty {
            dictAppIdentity = getAppIdentityConfigDictionary()
        }
        var appState: String = ""
        if let strDefaultAppState = dictAppIdentity[kState] as? String{
            if strDefaultAppState.caseInsensitiveCompare(kStateProduction) == ComparisonResult.orderedSame {
                appState = strDefaultAppState
            } else {
                do {
                    if let strAppState = try aiAppInfra?.appConfig.getPropertyForKey(kState, group: kAppIdentityGroupName) as? String{
                        appState = strAppState
                    }else{
                        appState = strDefaultAppState
                    }
                }catch{
                    appState = strDefaultAppState
                }
            }
        }
        validateAppState(appState)
        let state: AIAIAppState = appStateString(toEnum: appState)
        return state
    }
    
    @objc public func getSector() -> String {
        if dictAppIdentity.isEmpty {
            dictAppIdentity = getAppIdentityConfigDictionary()
        }
        var strSectorIdentifier: String = ""
        if let strSector = dictAppIdentity[kSector] as? String{
            strSectorIdentifier = strSector
        }
        return strSectorIdentifier
    }
    
    @objc public func getAppName() -> String {
        var appName = ""
        if let strAppName =  Bundle.main.infoDictionary?["CFBundleName"] as? String{
            appName = strAppName
        }
        return appName
    }
    
    @objc public func getLocalizedAppName() -> String {
        var localisedName = ""
        if let strLocalisedName =  Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String{
            localisedName = strLocalisedName
        }
        return localisedName
    }
    
    @objc public func getAppVersion() -> String {
        var appVersion = ""
        if let strAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            appVersion = strAppVersion
            let isValidVersion = isValidAppVersion(appVersion)
            let message = "app version (\(appVersion)) is not valid in info plist file. It should be X.X.X "
            if !isValidVersion {
                AIInternalLogger.log(AILogLevel.debug, eventId: kAIAIEventID, message: message)
            }
            assert(isValidVersion, message)
        }
        return appVersion
    }
    
    // get path of the configuration
    public func getAppIdentityConfigDictionary() -> [AnyHashable : Any] {
        assert((aiAppInfra != nil), "not initialized with appinfra")
        var appIdentity: [AnyHashable : Any] = [:]
        var micrositeID,sector,appState,serviceDiscoveryEnvironment: String
        micrositeID = ""
        sector = ""
        appState = ""
        serviceDiscoveryEnvironment = ""
        var catchError:Error? = nil
        do {
            if let microID = try aiAppInfra?.appConfig.getDefaultProperty(forKey: kMicrositeId, group: kAppIdentityGroupName){
                if microID is NSNumber{
                    micrositeID = "\(microID )"
                }else{
                    if let microsite = microID as? String{
                        micrositeID = microsite
                    }
                }
            }
            if let sectorId = try aiAppInfra?.appConfig.getDefaultProperty(forKey: kSector, group: kAppIdentityGroupName) as? String{
                sector = sectorId
            }
            if let appStateCondition = try aiAppInfra?.appConfig.getDefaultProperty(forKey: kState, group: kAppIdentityGroupName) as? String{
                appState = appStateCondition
            }
            if let serviceDiscoveryEnv = try aiAppInfra?.appConfig.getDefaultProperty(forKey: kServiceDiscoveryEnvironment, group: kAppIdentityGroupName) as? String{
                serviceDiscoveryEnvironment = serviceDiscoveryEnv
            }
        } catch {
            catchError = error;
        }
        appIdentity[kMicrositeId] = micrositeID
        appIdentity[kSector] = sector
        appIdentity[kState] = appState
        appIdentity[kServiceDiscoveryEnvironment] = serviceDiscoveryEnvironment
        let assertMessage = "\(catchError?.localizedDescription ?? ""). Make sure that you have group \"appinfra\" in AppConfig.json file and all the necessary keys are present like \(kMicrositeId), \(kSector), \(kState), \(kServiceDiscoveryEnvironment)"
        if ((catchError) != nil){
            AIInternalLogger.log(AILogLevel.debug, eventId: kAIAIEventID, message: assertMessage)
        }
        assert(catchError == nil,assertMessage);
        validateAppIdentity(appIdentity)
        dictAppIdentity = appIdentity
        return dictAppIdentity
    }
    
    /**
     *  Description: Method to getServiceDiscoveryEnvironment
     *
     *  @return getServiceDiscoveryEnvironment
     */
    @objc public func getServiceDiscoveryEnvironment() -> String {
        if dictAppIdentity.isEmpty {
            dictAppIdentity = getAppIdentityConfigDictionary()
        }
        var SDEnvironment = ""
        
        if let SDDefaultEnvironment = dictAppIdentity[kServiceDiscoveryEnvironment] as? String{
            if let appState = dictAppIdentity[kState] as? String{
                if appState.caseInsensitiveCompare(kStateProduction) == ComparisonResult.orderedSame{
                    SDEnvironment = SDDefaultEnvironment
                } else {
                    do {
                        if let SDEnvironmentVar = try aiAppInfra?.appConfig.getPropertyForKey(kServiceDiscoveryEnvironment, group: kAppIdentityGroupName) as? String{
                            SDEnvironment = SDEnvironmentVar
                        }else{
                            SDEnvironment = SDDefaultEnvironment
                        }
                    }catch{
                        SDEnvironment = SDDefaultEnvironment
                    }
                }
            }
        }
        validateserviceDiscoveryEnvironment(SDEnvironment)
        if SDEnvironment.caseInsensitiveCompare(SDEnvironmentProduction) == ComparisonResult.orderedSame {
            return SDEnvironmentProduction
        } else if SDEnvironment.caseInsensitiveCompare(SDEnvironmentStaging) == ComparisonResult.orderedSame {
            return SDEnvironmentStaging
        }
        return ""
    }
    
    public func validateAppIdentity(_ appIdentity: [AnyHashable : Any]?) {
        var micrositeID,sector,appState,serviceDiscoveryEnvironment: String
        
        if (appIdentity?[kMicrositeId] is NSNumber) {
            micrositeID = "\(appIdentity?[kMicrositeId] ?? "")"
        } else {
            micrositeID = appIdentity?[kMicrositeId] as? String ?? ""
        }
        sector = appIdentity?[kSector] as? String ?? ""
        appState = appIdentity?[kState] as? String ?? ""
        serviceDiscoveryEnvironment = appIdentity?[kServiceDiscoveryEnvironment] as? String ?? ""
        assert(micrositeID.count > 0, "micrositeId cannot be empty in App config file ");
        let micrositeIDAcceptedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let blockedCharacters = CharacterSet(charactersIn: micrositeIDAcceptedCharacters).inverted
        let availableSectors = ["B2C", "B2B_HC", "CORPORATE", "B2B_LI"]
        assert(sector.count > 0,"App Sector cannot be empty in App config file")
        if micrositeID.isEmpty {
            AIInternalLogger.log(AILogLevel.debug, eventId: kAIAIEventID, message: "micrositeId cannot be empty in App config file ")
        }else if micrositeID.rangeOfCharacter(from: blockedCharacters, options: String.CompareOptions.caseInsensitive) != nil {
            AIInternalLogger.log(AILogLevel.debug, eventId: kAIAIEventID, message: "micrositeId should be alpha numeric")
        } else if sector.isEmpty {
            AIInternalLogger.log(AILogLevel.debug, eventId: kAIAIEventID, message: "App Sector cannot be empty in App config file")
            assert(availableSectors.contains(sector), "Sector in appIdentityConfig json file must match one of the following values \n B2C,\n B2B_HC,\n corporate, \n B2B_LI")
        } else if !availableSectors.contains(sector.uppercased()) {
            AIInternalLogger.log(AILogLevel.debug, eventId: kAIAIEventID, message: "Sector in appIdentityConfig json file must match one of the following values \n B2C,\n B2B_HC,\n corporate, \n B2B_LI")
        }
        //state validation
        validateAppState(appState)
        //service discovery environment
        validateserviceDiscoveryEnvironment(serviceDiscoveryEnvironment)
    }
    
    
    public func validateAppState(_ appState: String) {
        assert((appState.count) > 0,"<appidentity.appState> cannot be empty in App config file");
        let availableStates = [kStateTest, kStateDevelopment, kStateStaging, kStateAccepteance, kStateProduction]
        if !availableStates.contains(appState.uppercased()) {
            print( "<appidentity.appState> in  App config file must match one of the following values \n TEST,\n DEVELOPMENT,\n STAGING, \n ACCEPTANCE, \n PRODUCTION")
        }
    }
    
    public func validateserviceDiscoveryEnvironment(_ SDEnvironment: String) {
        //service discovery environment
        let availableEnvironments = [SDEnvironmentStaging, SDEnvironmentProduction]
        assert(SDEnvironment.count > 0, "serviceDiscoveryEnvironment cannot be empty in App config  file");
        if SDEnvironment == "" || (SDEnvironment.count) < 1 || !(availableEnvironments.contains(SDEnvironment.uppercased() )) {
            assert(availableEnvironments.contains(SDEnvironment.uppercased()),"serviceDiscoveryEnvironment in App config  file must match one of the following values \n STAGING, \n PRODUCTION")
            AIInternalLogger.log(AILogLevel.debug, eventId: kAIAIEventID, message: "serviceDiscoveryEnvironment in App config  file must match one of the following values \n STAGING, \n PRODUCTION")
        }
    }
    
    @objc public func isValidAppVersion(_ appVersion: String?) -> Bool {
        let expression = "[0-9]+\\.[0-9]+\\.[0-9]+([_(-].*)?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expression)
        return predicate.evaluate(with: appVersion)
    }
    
    @objc public func getAppStateString() -> String? {
        var appState: String
        switch getAppState() {
        case AIAIAppState.TEST:
            appState = kStateTest
        case AIAIAppState.DEVELOPMENT:
            appState = kStateDevelopment
        case AIAIAppState.STAGING:
            appState = kStateStaging
        case AIAIAppState.ACCEPTANCE:
            appState = kStateAccepteance
        case AIAIAppState.PRODUCTION:
            appState = kStateProduction
        }
        return appState
    }
    
    @objc public func appStateString(toEnum stateString: String?) -> AIAIAppState {
        if (stateString?.caseInsensitiveCompare(kStateTest)) == ComparisonResult.orderedSame {
            return AIAIAppState.TEST
        } else if ((stateString?.caseInsensitiveCompare(kStateDevelopment)) == ComparisonResult.orderedSame) {
            return AIAIAppState.DEVELOPMENT
        } else if ((stateString?.caseInsensitiveCompare(kStateStaging)) == ComparisonResult.orderedSame) {
            return AIAIAppState.STAGING
        } else if ((stateString?.caseInsensitiveCompare(kStateAccepteance)) == ComparisonResult.orderedSame) {
            return AIAIAppState.ACCEPTANCE
        } else if ((stateString?.caseInsensitiveCompare(kStateProduction)) == ComparisonResult.orderedSame) {
            return AIAIAppState.PRODUCTION
        }
        return AIAIAppState.TEST
    }
}
