//
//  ConsentInteractorMock.swift
//  ConsentRegistryTests
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PlatformInterfaces

class AIConsentHandlerMock: NSObject, ConsentHandlerProtocol {
    
    var errorToReturn : NSError?
    var postSuccess : ConsentStates! = ConsentStates.inactive
    var statusOfConsentToPost: Bool?
    var versionToReturn: Int = 0
    var consentStatusToReturn = ConsentStates.inactive
    var consentStatesToUse: [ConsentStatus] = []
    var shouldUseArrayOfConsentStates = false
    var indexOfStatusToReturn = 0
    var dispatchQueue = DispatchQueue(label: "com.AppInfra.AIConsentManager.AIConsentHandlerMockForTests")
    var shouldReturnEmptyErrorAndStatus = false
    var shouldFetchCallCompletion = true
    
    func fetchConsentTypeState(for consentType: String, completion: @escaping (ConsentStatus?, NSError?) -> Void) {
        if !shouldFetchCallCompletion {
            return
        }
        
        guard errorToReturn == nil else {
            completion(nil, errorToReturn)
            return
        }
        guard shouldUseArrayOfConsentStates == false else {
            self.dispatchQueue.sync {
                completion(consentStatesToUse[indexOfStatusToReturn], nil)
                indexOfStatusToReturn = indexOfStatusToReturn + 1
            }
            return
        }
        guard shouldReturnEmptyErrorAndStatus == false else {
            completion(nil,nil)
            return
        }
        completion(ConsentStatus(status: postSuccess, version: self.versionToReturn), errorToReturn)
    }
    
    func storeConsentState(for consentType: String, withStatus status: Bool, withVersion version: Int, completion: @escaping (Bool, NSError?) -> Void) {
        self.statusOfConsentToPost = status
        completion(postSuccess == ConsentStates.active, errorToReturn)
    }
}
