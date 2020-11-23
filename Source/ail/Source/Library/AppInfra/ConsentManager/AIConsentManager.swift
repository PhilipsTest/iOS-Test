//
//  ConsentRegistryInterface.swift
//  ConsentAccessToolKit
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PlatformInterfaces

struct AIConsentManagerConstants {
    static let timeoutInterval = 60.0
    
    struct ConsentServiceErrorDomain {
        static let ConsentHandlerNotFoundError = "Handler not registered"
        static let duplicateConsentType = "Consent type already present"
        static let duplicateConsentDefinition = "Consent Definition already present"
        static let consentDefinitionMissing = "Consent Definition is missing"
        static let consentFetchTimedOut = "Consent fetch timed out"
    }
    
    struct ConsentServiceErrorCode {
        static let HandlerMissingCode = 3600
        static let duplicateConsentCode = 3601
        static let consentDefinitionNotRegisteredErrorCode = 3602
        static let consentDefinitionMissingErrorCode = 3603
    }
}

/// AIConsentManager
/// Implements AIConsentManagerProtocol and acts as a endpoint for registering, deregistering Consent Handlers for particular types and also to fetch and store a consent type.
@objc public class AIConsentManager: NSObject, AIConsentManagerProtocol {
    private var consentHandlerMapping: AIConsentManagerMapper = AIConsentManagerMapper()
    private lazy var consentCallBackMapper = AIConsentCallBackMapper()
    private var consentTypesOperationQueue: OperationQueue
    private var synchronisingQueue = DispatchQueue(label: "com.AppInfra.AIConsentManagerQueue")
    private var storingQueue = DispatchQueue(label: "com.AppInfra.AIConsentManager.StoringQueue")
    private var fetchingConsentTypeQueue = DispatchQueue(label: "com.AppInfra.AIConsentManager.fetchingConsentTypeQueue")
    private var fetchingConsentDefinitionsQueue = DispatchQueue(label: "com.AppInfra.AIConsentManager.fetchingConsentDefinitionsQueue")
    private var consentStatusCombiner = AIConsentStatusCombiner()
    var _timeoutIntervalForTesting: Double?
    private var timeoutInterval: Double {
        get {
            if let _ = _timeoutIntervalForTesting {
                return _timeoutIntervalForTesting!
            } else {
                return AIConsentManagerConstants.timeoutInterval
            }
        }
    }
    
    //
    // MARK: Public methods
    //
    /// Designated Initialiser
    public override init() {
        self.consentTypesOperationQueue = OperationQueue()
        self.consentTypesOperationQueue.maxConcurrentOperationCount = 4
        super.init()
    }
    
    /// Method used to de-register a consent handler of type ConsentHandlerProtocol with list of consent types.
    ///
    /// - Parameter forConsentTypes: Array of Strings denoting the consent types to be deregistered.
    public func deregisterHandler(forConsentTypes: [String]) {
        self.consentHandlerMapping.removeHandler(forConsentTypes: forConsentTypes)
    }
    
    /// Method used to register a consent handler of type ConsentHandlerProtocol with list of consent types.
    ///
    /// - Parameters:
    ///   - handler: Object that implements ConsentHandlerProtocol, which si the object that will be registered for the types passed in the first parameter
    ///   - forConsentTypes: Array of Strings denoting the consent types to be registering.
    /// - Throws: AIConsentManagerErrorCodes.duplicateConsentCode if the consent type has already been registered with the registry
    public func registerHandler(handler: ConsentHandlerProtocol, forConsentTypes: [String]) throws {
        try self.consentHandlerMapping.register(consentTypes: forConsentTypes, withHandler: handler)
    }
    
    /// Method used to fetch status of Consent types contained in the consent definition that is passed as the parameter.
    ///
    /// - Parameters:
    ///   - consentDefinition: Consent Definition containing array of consent types whose status has to be fetched from the backend
    ///   - completion: Block that will be invoked once the fetching operation has been completed that returns (status & error)
    ///        status : ConsentDefinitionStatus containing the status of the consent definition passed in the first parameter
    ///          error: NSError if there was an error that was encountered while fetching status of ConsentDefinintion
    public func fetchConsentState(forConsentDefinition consentDefinition: ConsentDefinition, completion: @escaping (_ status: ConsentDefinitionStatus?, _ error: NSError?) -> Void) {
        var errorToReturn: NSError!
        var consentStatusToReturn: ConsentDefinitionStatus!
        
        self.fetchingConsentTypeQueue.async { [weak self] in
            if let strongSelf = self {
                let fetchingDispatchGroup = DispatchGroup()
                for type in consentDefinition.getTypes() {
                    guard let handlerToUse = strongSelf.getHandler(forConsentType: type) else {
                        errorToReturn = strongSelf.getEmptyHandlerError()
                        break
                    }
                    fetchingDispatchGroup.enter()
                    let operationToUse = AIConsentTypeFetchOperation(consentHandler: handlerToUse, consentType: type) { (consentState, error) in
                        strongSelf.synchronisingQueue.sync {
                            consentStatusToReturn = strongSelf.consentStatusCombiner.combineConsentDefinitionStatus(forConsentDefinition: consentDefinition, consentDefinitionStatus: consentStatusToReturn, consentState: consentState, appVersion: consentDefinition.version)
                            errorToReturn = errorToReturn ?? error
                            fetchingDispatchGroup.leave()
                        }
                    }
                    strongSelf.consentTypesOperationQueue.addOperation(operationToUse)
                }
                
                let timeoutResult = fetchingDispatchGroup.wait(timeout: DispatchTime.now() + strongSelf.timeoutInterval)
                errorToReturn = strongSelf.getTimeoutError(for: timeoutResult, errorToReturn: errorToReturn)
            }
            completion(consentStatusToReturn, errorToReturn)
        }
    }
    
    /// Method used to fetch
    ///
    /// - Parameters:
    ///   - consentDefinitions: Array of Consent Definitions each containing array of consent types whose status has to be fetched from the backend.
    ///   - completion: Block that will be invoked once the fetching operation has been completed
    ///           list: Array of ConsentDefinitionStatus containing the status of each consent definition
    ///          error: NSError if there was an error that was encountered while fetching statuses of ConsentDefinintions
    public func fetchConsentStates(forConsentDefinitions consentDefinitions: [ConsentDefinition], completion: @escaping (_ list:[ConsentDefinitionStatus]?, _ error: NSError?) -> Void) {
        var errorToReturn: NSError!
        var consentStatusToReturn: [ConsentDefinitionStatus] = []
        
        self.fetchingConsentDefinitionsQueue.async { [weak self] in
            if let strongSelf = self {
                let fetchingDispatchGroup = DispatchGroup()
                for consentDefinition in consentDefinitions {
                    guard errorToReturn == nil else { break }
                    fetchingDispatchGroup.enter()
                    strongSelf.fetchConsentState(forConsentDefinition: consentDefinition, completion: { (consentDefinitionStatus, error) in
                        defer { fetchingDispatchGroup.leave() }
                        guard error == nil else {
                            consentStatusToReturn.removeAll()
                            errorToReturn = error
                            return
                        }
                        guard let returnedConsentDeifnitionStatus = consentDefinitionStatus else { return }
                        consentStatusToReturn.append(returnedConsentDeifnitionStatus)
                    })
                }
                let timeoutResult = fetchingDispatchGroup.wait(timeout: DispatchTime.now() + strongSelf.timeoutInterval)
                errorToReturn = strongSelf.getTimeoutError(for: timeoutResult, errorToReturn: errorToReturn)
            }
            completion(consentStatusToReturn, errorToReturn)
        }
    }
   
    /// Method used to store the status of all the consent types combined in the consent definition that is paased as the first parameter.
    ///
    /// - Parameters:
    ///   - consentDefinition: Consent Definition containing array of consent types whose status has to be stored in the backend.
    ///   - status: Bool indicating status of the consent definition that is to be stored
    ///   - completion: Block that will be executed once the store has been completed
    ///         result: Bool denoting if the consent definition was executed successfully
    ///          error: NSError if there was an error that was encountered while storing the ConsentDefinintion
    public func storeConsentState(consent consentDefinition: ConsentDefinition, withStatus status: Bool, completion: @escaping (_ result: Bool, _ error: NSError?) -> Void) {
        var errorToReturn: NSError!
        var valueToPass: Bool = false
        
        self.storingQueue.async { [weak self] in
            if let strongSelf = self {
                let sendingDispatchGroup = DispatchGroup()
                for type in consentDefinition.getTypes() {
                    guard let handlerToUse = strongSelf.getHandler(forConsentType: type) else {
                        errorToReturn = strongSelf.getEmptyHandlerError()
                        valueToPass = false
                        break
                    }
                    sendingDispatchGroup.enter()
                    let operationToUse = AIConsentTypeSendOperation(consentHandler: handlerToUse, consentType: type, status: status, version: consentDefinition.version) { (success, error) in
                        strongSelf.synchronisingQueue.sync {
                            if errorToReturn == nil { errorToReturn = error }
                            valueToPass = success
                            sendingDispatchGroup.leave()
                        }
                    }
                    strongSelf.consentTypesOperationQueue.addOperation(operationToUse)
                }
                _ = sendingDispatchGroup.wait(timeout: DispatchTime.now() + strongSelf.timeoutInterval)
            }
            self?.consentCallBackMapper.consentStatusChanged(for: consentDefinition, error: errorToReturn, requestedStatus: status)
            completion(valueToPass, errorToReturn)
        }
    }

    /// Method used to fetch status of Consent types contained in the consent definition that is passed as the parameter.
    ///
    /// - Parameters:
    ///   - forConsentType: String containing the consent type that needs to be fetched
    ///   - completion: Block that will be invoked once the fetching operation has been completed
    ///         status: ConsentDefinitionStatus containing the status of the consent definition passed in the first parameter
    ///          error: NSError if there was an error that was encountered while fetching status of ConsentDefinintion
    /// - Throws: AIConsentManagerErrorCodes.ConsentServiceErrorCode.consentDefinitionNotRegisteredErrorCode if the consent definition has not been registered with the registry
    @objc public func fetchConsentTypeState(forConsentType: String, completion: @escaping (_ status: ConsentDefinitionStatus?, _ error: NSError?) -> Void) throws {
        guard let consentDefinition = self.consentHandlerMapping.getConsentDefinition(forConsentType: forConsentType) else {
            
            let error = NSError(domain: AIConsentManagerConstants.ConsentServiceErrorDomain.consentDefinitionMissing, code: AIConsentManagerConstants.ConsentServiceErrorCode.consentDefinitionMissingErrorCode, userInfo: nil)
            
            completion(nil,error)
            throw error
        }
        self.fetchConsentState(forConsentDefinition: consentDefinition, completion: completion)
    }
    
    /// Method used to register a consent definitions which are passed as input parameter.
    ///
    /// - Parameters:
    ///   - consentDefinitions: List of consent definitions to register.
    ///   - completion: Completion handler that will be invoked once all the consent definitions are registered
    ///   - error: NSError if there was an error that was encountered while registering consentDefinitions
    /// - Since: 2018.1.0
    
    
    /// Method used to register a consent definitions which are passed as input parameter.
    ///
    /// - Parameters:
    ///   - consentDefinitions: List of consent definitions to register.
    ///   - completion: Completion handler that will be invoked once all the consent definitions are registered
    ///          error: NSError if there was an error that was encountered while registering consentDefinitions
    @objc public func registerConsentDefinitions(consentDefinitions: [ConsentDefinition], completion: @escaping (_ error: NSError?)->()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.consentHandlerMapping.registerConsentDefinitions(consentDefinitions: consentDefinitions, completion: completion)
        }
    }
    
    public func addConsentStatusChanged(delegate: AIConsentStatusChangeProtocol, for consentDefiniton: ConsentDefinition) {
        consentCallBackMapper.addConsentStatusChanged(delegate: delegate, for: consentDefiniton)
    }
    
    public func removeConsentStatusChanged(delegate: AIConsentStatusChangeProtocol, for consentDefinition: ConsentDefinition) {
        consentCallBackMapper.removeConsentStatusChanged(delegate: delegate, for: consentDefinition)
    }
    
    //
    // MARK: File private methods
    //
    func getHandler(forConsentType: String) -> ConsentHandlerProtocol? {
        return self.consentHandlerMapping.getHandler(forConsentType: forConsentType)
    }
    
    @objc public func getConsentDefinition(forConsentType: String) -> ConsentDefinition? {
        return self.consentHandlerMapping.getConsentDefinition(forConsentType: forConsentType)
    }
    
    //
    // MARK: Private methods
    //
    private func getEmptyHandlerError() -> NSError {
        return NSError(domain: AIConsentManagerConstants.ConsentServiceErrorDomain.ConsentHandlerNotFoundError, code: AIConsentManagerConstants.ConsentServiceErrorCode.HandlerMissingCode, userInfo: nil)
    }
    
    private func getTimeoutError(for timeoutResult: DispatchTimeoutResult, errorToReturn: NSError?) -> NSError? {
        if errorToReturn != nil {
            return errorToReturn
        }
        
        switch timeoutResult {
        case .success:
            return nil
        case .timedOut:
            return NSError(domain: AIConsentManagerConstants.ConsentServiceErrorDomain.consentFetchTimedOut, code: NSURLErrorTimedOut, userInfo: nil)
        }
    }
}
