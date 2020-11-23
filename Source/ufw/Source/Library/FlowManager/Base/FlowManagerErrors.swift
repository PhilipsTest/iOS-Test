/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 * FlowManagerErrors is an enum which holds all error values of Flow Manager
 * - Since 1.1.0
 */

public enum FlowManagerErrors : Error {
    
    /// This error is thrown when there is a error in the Flow Json structure
    case jsonSyntaxError
    
    /// This error is thrown when the Event Id passed doesnot match any EventId in the Json
    case noEventFoundError
    
    /// This error is thrown when there is no State found in the StateMap with the given State Id
    case noStateFoundError
    
    /// This error is thrown when there is no State found in the ConditionMap with the given Condition Id
    case noConditionFoundError
    
    /// This error is thrown when there null State has been passed to the Flow Manager's getNextState API
    case nullStateError
    
    /// This error is thrown when there null Event has been passed to the Flow Manager's getNextState API
    case nullEventError
    
    /// This error is thrown when there is no Flow Json file found in the path given
    case fileNotFoundError
    
    /// This error is thrown when a call has been made to Flow Manager APIs without initialisng the app's flow
    case flowManagerInitializationError
    
    /// This error is thrown when Flow Manager is being initialise multiple times
    case flowManagerAlreadyInitializedError
    
    /// This error is thrown when the State Id passed doesnot match any StateId in the Json
    case stateIdNotFoundError
    
    /// This error is thrown when the Condition Id passed doesnot match any ConditionId in the Json
    case conditionIdNotFoundError
    
    /// This error is thrown when the Condition Id passed doesnot match any ConditionId in the Json
    case nullAppFlowModelError
    /**
     * This will return a error message for all FlowManagerErrors encountered
     * - Returns : Error message encountered in Flow Manager
     * - Since 1.1.0
     */
    
    public func message() -> String {
        switch self {
        case .jsonSyntaxError:
            return "The Json structure is wrong"
        case .noEventFoundError:
            return "No Event found with that Id"
        case .noStateFoundError:
            return "No State found with that Id"
        case .noConditionFoundError:
            return "No Condition found with that Id"
        case .nullStateError:
            return "Passed State is not valid"
        case .nullEventError:
            return "Passed Event is not valid"
        case .fileNotFoundError:
            return "There is no Json in the given path"
        case .flowManagerInitializationError:
            return "Flow Manager was not initialized"
        case .flowManagerAlreadyInitializedError:
            return "Flow Manager already initialized"
        case .stateIdNotFoundError:
            return "There is no State Id for the passed State"
        case .conditionIdNotFoundError:
            return "There is no Condition Id for the passed Condition"
        case.nullAppFlowModelError:
            return "App flow model passed is null"
        }
    }
    
    /**
     * This will return a error code for all FlowManagerErrors encountered
     * - Returns : Error code encountered in Flow Manager
     * - Since 1.1.0
     */
    public func code() -> Int {
        return 100 + self._code
    }
}
