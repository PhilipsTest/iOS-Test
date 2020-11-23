//
//  ConsentRegistryProtocol.swift
//  ConsentAccessToolKit
//
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PlatformInterfaces

/// AIConsentStatusChangeProtocol is the protocol to be implemented in order to get callbacks when the registered Consent Definition Status changes
/// - Since: 2018.3.0
@objc public protocol AIConsentStatusChangeProtocol: NSObjectProtocol {
    /// Method which will be called when Consent Status changes for the registered Consent Defintion
    ///
    /// - Parameters:
    ///   - consentDefinition: The Consent Definition whose Consent Status has changed
    ///   - error: The error encountered while updating the Consent Definition status
    ///   - requestedStatus: The requested value of the Consent Definition Status to be updated
    /// - Since: 2018.3.0
    func consentStatusChanged(for consentDefinition: ConsentDefinition, error: NSError?, requestedStatus: Bool)
}

/// AIConsentManagerProtocol
/// Protocol implemented by the AIConsentManager class which serves as a contact point for registering/deregistering handlers with a particular consent type, storing and fetching consents using the handlers that are registered
/// - Since: 2018.1.0
@objc public protocol AIConsentManagerProtocol: NSObjectProtocol {
    
    /// Method used to register a consent handler of type ConsentHandlerProtocol with list of consent types.
    ///
    /// - Parameters:
    ///   - handler: Object that implements ConsentHandlerProtocol, which si the object that will be registered for the types passed in the first parameter
    ///   - forConsentTypes: Array of Strings denoting the consent types to be registering.
    /// - Throws: AIConsentManagerErrorCodes.duplicateConsentCode if the consent type has already been registered with the registry
    /// - Since: 2018.1.0
    func registerHandler(handler: ConsentHandlerProtocol, forConsentTypes: [String]) throws
    
    /// Method used to register a consent definitions which are passed as input parameter.
    ///
    /// - Parameters:
    ///   - consentDefinitions: List of consent definitions to register.
    ///   - completion: Completion handler that will be invoked once all the consent definitions are registered
    /// - Returns: NSError if there was an error that was encountered while registering consentDefinitions\
    /// - Since: 2018.1.0
    @objc optional func registerConsentDefinitions(consentDefinitions: [ConsentDefinition], completion: @escaping (_ error: NSError?)->())
    
    
    /// Method used to de-register a consent handler of type ConsentHandlerProtocol with list of consent types.
    ///
    /// - Parameter forConsentTypes: Array of Strings denoting the consent types to be deregistered.
    /// - Since: 2018.1.0
    func deregisterHandler(forConsentTypes: [String])
    
    /// Method used to store the status of all the consent types combined in the consent definition that is paased as the first parameter.
    ///
    /// - Parameters:
    ///   - consentDefinition: Consent Definition containing array of consent types whose status has to be stored in the backend.
    ///   - status: Bool indicating status of the consent definition that is to be stored
    ///   - completion: Block that will be executed once the store has been completed
    /// - Returns:
    ///             error: NSError if there was an error that was encountered while storing the ConsentDefinintion or
    ///            result: Bool denoting if the consent definition was executed successfully
    /// - Since: 2018.1.0
    func storeConsentState(consent consentDefinition: ConsentDefinition, withStatus status: Bool, completion: @escaping (_ result: Bool, _ error: NSError?) -> Void)
    
    /// Method used to store the status of all the consent types combined in the consent definition that is paased as the first parameter.
    ///
    /// - Parameters:
    ///   - forConsentType: String denoting the consent type.
    /// - Returns:
    ///   - consentDefinition: Consent Definition containing array of consent types whose status has to be stored in the backend.
    /// - Since: 2018.1.0
    
    func getConsentDefinition(forConsentType: String) -> ConsentDefinition?

    /// Method used to fetch to status of consent definitions passed as input parameter.
    ///
    /// - Parameters:
    ///   - consentDefinitions: Array of Consent Definitions each containing array of consent types whose status has to be fetched from the backend.
    ///   - completion: Block that will be invoked once the fetching operation has been completed.
    /// - Returns:
    ///             list: Array of ConsentDefinitionStatus containing the status of each consent definition
    ///            error: NSError if there was an error that was encountered while fetching statuses of ConsentDefinintions
    /// - Since: 2018.1.0
    func fetchConsentStates(forConsentDefinitions consentDefinitions: [ConsentDefinition], completion: @escaping (_ list:[ConsentDefinitionStatus]?, _ error: NSError?) -> Void)
   
    /// Method used to fetch status of Consent types contained in the consent definition that is passed as the parameter.
    ///
    /// - Parameters:
    ///   - consentDefinition: Consent Definition containing array of consent types whose status has to be fetched from the backend
    ///   - completion: Block that will be invoked once the fetching operation has been completed
    /// - Returns:
    ///             status: ConsentDefinitionStatus containing the status of the consent definition passed in the first parameter
    ///              error: NSError if there was an error that was encountered while fetching status of ConsentDefinintion
    /// - Since: 2018.1.0
    func fetchConsentState(forConsentDefinition consentDefinition: ConsentDefinition, completion: @escaping (_ status: ConsentDefinitionStatus?, _ error: NSError?) -> Void)
    
    /// Method used to fetch status of Consent types contained in the consent definition that is passed as the parameter.
    ///
    /// - Parameters:
    ///   - forConsentType: String containing the consent type that needs to be fetched
    ///   - completion: Block that will be invoked once the fetching operation has been completed
    /// - Throws:
    ///           status: ConsentDefinitionStatus containing the status of the consent definition passed in the first parameter
    ///            error: NSError if there was an error that was encountered while fetching status of ConsentDefinintion
    ///           Throws: AIConsentManagerErrorCodes.ConsentServiceErrorCode.consentDefinitionNotRegisteredErrorCode if the consent definition has not been registered with the registry
    ///- Since: 2018.1.0
    @objc optional func fetchConsentTypeState(forConsentType: String, completion: @escaping (_ status: ConsentDefinitionStatus?, _ error: NSError?) -> Void) throws
    
    /// Method used to add a delegate for listening to Consent Status Change for Consent Definition
    ///
    /// - Parameters:
    ///   - delegate: The delegate of type AIConsentStatusChangeProtocol which will receive the callback when Consent Status has changed
    ///   - consentDefiniton: The Consent Definition whose status change will trigger the callback
    ///- Since: 2018.3.0
    @objc optional func addConsentStatusChanged(delegate: AIConsentStatusChangeProtocol, for consentDefiniton: ConsentDefinition)
    
    /// Method used to remove a delegate for listening to Consent Status Change for Consent Definition
    ///
    /// - Parameters:
    ///   - delegate: The delegate of type AIConsentStatusChangeProtocol which will be removed as the callback of Consent Status change
    ///   - consentDefinition: The Consent Definition whose status change callback will be removed
    ///- Since: 2018.3.0
    @objc optional func removeConsentStatusChanged(delegate: AIConsentStatusChangeProtocol, for consentDefinition: ConsentDefinition)
}
