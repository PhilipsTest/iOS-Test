//
//  ConsentRegistry.swift
//  ConsentRegistry
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PlatformInterfaces

class AIConsentManagerMapper {
    private lazy var mappingDictionary: [String: ConsentHandlerProtocol] = [:]
    private lazy var consentDefinitionMappingDictionary: [String: ConsentDefinition] = [:]
    private lazy var synchronisationDispatchQueue = DispatchQueue(label: "ConsentRegistryQueue")
    
    func register(consentTypes: [String], withHandler: ConsentHandlerProtocol) throws {
        try self.synchronisationDispatchQueue.sync {
            for consentType in consentTypes {
                if let _ = self.getHandler(forConsentType: consentType) {
                    throw NSError(domain: AIConsentManagerConstants.ConsentServiceErrorDomain.duplicateConsentType, code: AIConsentManagerConstants.ConsentServiceErrorCode.duplicateConsentCode, userInfo: nil)
                } else {
                    mappingDictionary.updateValue(withHandler, forKey: consentType)
                }
            }
        }
    }
    
    func registerConsentDefinitions(consentDefinitions: [ConsentDefinition], completion: @escaping (_ error: NSError?)->()) {
        var error: NSError?
        self.synchronisationDispatchQueue.sync {
            for consentDefinition in consentDefinitions {
                guard error == nil else { break }
                let consentTypes = consentDefinition.getTypes()
                for consentType in consentTypes {
                    guard let consentDefinitionFetched = self.consentDefinitionMappingDictionary[consentType] else {
                        self.consentDefinitionMappingDictionary[consentType] = consentDefinition
                        continue
                    }
                    
                    guard consentDefinitionFetched != consentDefinition else {
                        error = NSError(domain: AIConsentManagerConstants.ConsentServiceErrorDomain.duplicateConsentDefinition, code: AIConsentManagerConstants.ConsentServiceErrorCode.duplicateConsentCode, userInfo: nil)
                        continue
                    }
                }
            }
            completion(error)
        }
    }
    
    func getConsentDefinition(forConsentType: String) -> ConsentDefinition? {
        return consentDefinitionMappingDictionary[forConsentType]
    }
    
    func getHandler(forConsentType: String) -> ConsentHandlerProtocol? {
        return mappingDictionary[forConsentType]
    }
    
    func removeHandler(forConsentTypes: [String]) {
        self.synchronisationDispatchQueue.sync {
            for consentType in forConsentTypes {
                mappingDictionary.removeValue(forKey: consentType)
            }
        }
    }
}
