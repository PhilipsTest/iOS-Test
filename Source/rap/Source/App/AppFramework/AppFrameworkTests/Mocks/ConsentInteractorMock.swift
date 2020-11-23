//
//  ConsentInteractorMock.swift
//  ConsentWidgetsTests

//

import PlatformInterfaces

class ConsentInteractorMock: NSObject, ConsentHandlerProtocol {
    var errorToReturn : NSError?
    var postSuccess : Bool = false
    var statusOfConsentToPost: Bool?
    var consentTypeToPost: String?
    var versionToPost: Int!
    var consentDefinitionStatusListToReturn: [ConsentDefinitionStatus]?
    var consentStatusToReturn: ConsentStatus?
    
    func fetchConsentTypeState(for consentType: String, completion: @escaping (ConsentStatus?, NSError?) -> Void) {
        guard errorToReturn == nil else {
            completion(nil, errorToReturn)
            return
        }
        completion(consentStatusToReturn, nil)
    }
    
    func storeConsentState(for consentType: String, withStatus status: Bool, withVersion version: Int, completion: @escaping (Bool, NSError?) -> Void) {
        self.consentTypeToPost = consentType
        self.versionToPost = version
        self.statusOfConsentToPost = status
        completion(postSuccess, errorToReturn)
    }
}
