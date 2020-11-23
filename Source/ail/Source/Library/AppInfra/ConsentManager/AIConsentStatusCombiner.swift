//
//  AIConsentStatusCombiner.swift
//  AppInfra
//
//  Created by Rayan Sequeira on 12/03/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

import Foundation
import PlatformInterfaces

class AIConsentStatusCombiner {
    
    func combineConsentDefinitionStatus(forConsentDefinition: ConsentDefinition, consentDefinitionStatus: ConsentDefinitionStatus?, consentState: ConsentStatus?, appVersion: Int) -> ConsentDefinitionStatus? {
        guard let consentDefinitionStatusReturned = self.createConsentDefinitionStatus(forConsentDefinition: forConsentDefinition, withConsentState: consentState, appVersion: appVersion) else {
            return consentDefinitionStatus
        }
        
        guard let passedConsentStatus = consentDefinitionStatus else {
            return consentDefinitionStatusReturned
        }
        
        return ConsentDefinitionStatus.combine(consentDefinitionStatus1: passedConsentStatus, consentDefinitionStatus2: consentDefinitionStatusReturned)
    }
    
    private func createConsentDefinitionStatus(forConsentDefinition: ConsentDefinition, withConsentState: ConsentStatus?, appVersion: Int) -> ConsentDefinitionStatus? {
        guard let consent = withConsentState else { return nil }
        return toConsentDefinitionStatus(forConsentState: consent, withAppVersion: appVersion, forConsentDefinition: forConsentDefinition)
    }
    
    private func toConsentDefinitionStatus(forConsentState: ConsentStatus, withAppVersion: Int, forConsentDefinition: ConsentDefinition) -> ConsentDefinitionStatus {
        var status = forConsentState.status
        var states: ConsentVersionStates
        if forConsentState.version == withAppVersion {
            states = ConsentVersionStates.inSync
        } else if forConsentState.version < withAppVersion {
            states = ConsentVersionStates.appVersionIsHigher
            status = ConsentStates.inactive
        } else {
            states = ConsentVersionStates.appVersionIsLower
        }
        
        return ConsentDefinitionStatus(status: status, versionStatus: states, consentDefinition: forConsentDefinition,lastModifiedTimestamp:forConsentState.timestamp)
    }
}
