/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/**
 * Aliasing(Extending the behavior of an existing named type) the defined dictionary to a variable, With value to be of type BaseState class
 * - Since 1.1.0
 */
public  typealias StateMapType = [String : BaseState]
/**
 * Aliasing the defined dictionary to a variable, With value to be of type BaseCondition class
 * - Since 1.1.0
 */
public typealias ConditionMapType = [String: BaseCondition]

/**
 * Flow Manager class which handles reading application flow from configuration json and manage different state transitions
 * - Since 1.1.0
 */
@objc open class BaseFlowManager : NSObject {
    
    
    /**
     * State flow model as defined in the json
     * - Since 1.1.0
     */
    public fileprivate(set) var appFlowModel: AppFlowModel!
    
    /**
     * This variable stores the current State which the App is in
     * - Since 1.1.0
     */
    fileprivate var currentState : BaseState?
    
    /**
     * Variable of type ConditionMapType i.e of type [String: BaseCondition]
     * - Since 1.1.0
     */
    internal var conditionMap : ConditionMapType = [:]
    
    /**
     * stateMap is Variable of type StateMapType i.e of type [String: BaseState]
     * - Since 1.1.0
     */
    internal var stateMap : StateMapType = [:]
    
    internal var appStack : [BaseState] = []
    
    /**
     * Default Initializer
     * - Since 1.1.0
     */
    @objc public override init() {
        super.init()
    }
    
    /**
    * To initialise the Flow Manager with App Flow configuration like Json and Maps
    * - Parameter jsonPath: Path of the Flow Json
    * - Parameter successBlock: A block which will be executed when the Json parsing is successful
    * - Parameter failureBlock: A block which will be executed when Json parsing fails and will return the error object
    * - Since 1.1.0
     */
    
    public func initialize(withAppFlowJsonPath jsonPath : String, successBlock : @escaping () -> (), failureBlock : @escaping (FlowManagerErrors) -> () ) {
        
        //If this method is called from Main Thread,create a Backgorund thread and do the Json parsing and give callbacks in Main Thread
        
        if Thread.isMainThread {
            let parseQueue = DispatchQueue(label: AppFrameworkConstants.QUEUE_IDENTIFIER, attributes: DispatchQueue.Attributes.concurrent)
            
            parseQueue.async(execute: {
                do {
                    try self.initializeJson(withJsonPath: jsonPath)
                    DispatchQueue.main.async(execute: successBlock)
                } catch {
                    let error = error as! FlowManagerErrors
                    DispatchQueue.main.async(execute: {
                        failureBlock(error)
                    })
                }
            })
        } else {
            
            //If this method is called from Background Thread,the Json parsing will be done in that Thread and the callbacks will be given in the callee thread
            
            do {
                try self.initializeJson(withJsonPath: jsonPath)
                successBlock()
            } catch {
                let error = error as! FlowManagerErrors
                failureBlock(error)
            }
        }
    }
    
    /**
    * To initialise the Flow Manager with App Flow mode
    * - Parameter flowModel: AppFlowModel object
    * - Since 1.1.0
     */
    
    public func initialize(withAppFlowModel flowModel : AppFlowModel? ) throws {
        guard flowModel != nil else {
            throw FlowManagerErrors.nullAppFlowModelError
        }
        appFlowModel = flowModel
        populateStateMap(&stateMap)
        populateConditionMap(&conditionMap)
    }
    
    /**
     * To get the State when custom navigation back button has been pressed.
     * - Parameter forState: The current state of the app
     * - Throws: Error of type FlowManagerErrors which tells the error faced by Flow Manager to get the state to go to for custom back
     * - Returns: An instance of BaseState which is the next state to navigate
     * - Since 1.1.0
     */
    
    public func getBackState(_ forState : BaseState) throws -> BaseState? {
        var currentState : BaseState?
        do {
            
            //This will check in Json,if there is any custom back state mentioned for the state
            
            if let backEventState = try getNextState(forState, forEventId: AppFrameworkConstants.BACK_EVENT) {
                
                //If there is any custom state,we will search whether that custom state is present in the state stack
                
                if appStack.contains(backEventState) {
                    
                    //If the custom state is found,then pop upto that state
                    
                    pop(backEventState)
                    currentState = backEventState
                } else {
                    //If the custom state is not found in the stack,then pop the first state and push the custom state
                    pop()
                    push(backEventState)
                    currentState = backEventState
                }
            } else {
                //If there is no custom state for that state,then just pop the topmost element
                pop()
                currentState = appStack.last
            }
        } catch let error as FlowManagerErrors {
            switch error {
            case .noEventFoundError:
                pop()
                currentState = appStack.last
            default:
                throw error
            }
            
        }
        if currentState != nil {
            setCurrentState(currentState)
        }
        return currentState
    }
    
    /**
     * To get the State when custom navigation back button has been pressed. This by default takes the current State of the app
     * - Throws: Error of type FlowManagerErrors which tells the error faced by Flow Manager to get the state to go to for custom back
     * - Returns: An instance of BaseState which is the next state to navigate
     * - Since 1.1.0
     */
    
    public func getBackState() throws -> BaseState? {
        var backState : BaseState?
        
        do {
            backState = try getBackState(getCurrentState()!)
        } catch {
            throw error
        }
        
        return backState
    }
    
    /**
     * To get the current state of the app
     
     * - Returns: The current State of the App
     * - Since 1.1.0
     */
    @objc public func getCurrentState() -> BaseState? {
        return currentState
    }
    
    /**
     * Method to be implemented by the child classes for mapping the app states with corresponding state classes, inherited from baseState class
     
     * - Parameter stateMap: Variable that hold the base state
     * - Since 1.1.0
     */
    
    open func populateStateMap(_ stateMap : inout StateMapType) {
        assert(false,"Subclass of BaseFlowManager should implement populateStateMap method")
    }
    
    /**
     * Method to be implemented by the child classes for mapping the app conditions with corresponding condition classes, inhereted from baseCondition class
     
     * - Parameter conditionMap: Variable that hold the base condition
     * - Since 1.1.0
     */
    open func populateConditionMap(_ conditionMap : inout ConditionMapType) {
        assert(false,"Subclass of BaseFlowManager should implement populateConditionMap method")
    }
    
    /**
     * Call this method to get the state, which is mapped with the corresponding stateId
     
     * - Parameter stateId: State Id, defines the which state is the app in
     * - Returns: state of type BaseState
     * - Since 1.1.0
     */
    public func getState(_ stateId : String) -> BaseState? {
        guard let state = stateMap[stateId] else {
            return nil
        }
        return state
    }
    
    /**
     * Call this method to get the condition, which is mapped with the corresponding conditionId
     
     * - Parameter conditionId: condition Id defines, at which condition the app is in
     * - Returns: state of type BaseCondition
     * - Since 1.1.0
     */
    public func getCondition(_ conditionId : String) -> BaseCondition? {
        guard let condition = conditionMap[conditionId] else {
            return nil
        }
        return condition
    }
    
    /**
     * Returns next state for the specified state. This takes the current State by default
     
     * - Parameter forEventId: The event Id of the click
     * - Throws: Error of type FlowManagerErrors which tells the error faced by Flow Manager to get the state to go to on the Event
     * - Returns: The next state to load
     * - Since 1.1.0
     */
    
    public func getNextState(_ forEventId : String?) throws -> BaseState? {
        var nextState : BaseState? = nil
        
        do {
            nextState = try getNextState(getCurrentState(), forEventId: forEventId)
        } catch {
            throw error
        }
        
        return nextState
    }
    
    /**
     * Returns next state for the specified state.
     
     * - Parameter currentState: The current state
     * - Parameter forEventId: The event Id of the click
     * - Throws: Error of type FlowManagerErrors which tells the error faced by Flow Manager to get the state to go to on the Event
     * - Returns: The next state to load
     * - Since 1.1.0
     */
    
    public func getNextState(_ currentState: BaseState?,forEventId : String?) throws -> BaseState? {
        var stateString: String? = nil
        var nextState: BaseState? = nil
        var currentStateValue : String? = nil
        
        if let eventId = forEventId {
            if appFlowModel != nil {
                if let state = currentState {
                    currentStateValue = state.stateId
                    if currentStateValue == nil {
                        throw FlowManagerErrors.stateIdNotFoundError
                    }
                    if let mappedState = mapCurrentStateModel(currentStateValue!) {
                        if let event = getEventForState(mappedState, eventId: eventId) {
                            if let possibleStates = possibleStatesForEvent(event) {
                                for condition in possibleStates {
                                    do {
                                        if try isConditionTrue(condition) == true {
                                            stateString = condition.nextState
                                            break
                                        }
                                    } catch {
                                        throw error
                                    }
                                }
                            }
                        } else {
                            throw FlowManagerErrors.noEventFoundError
                        }
                        
                        if let stateString = stateString {
                            nextState = getState(stateString)
                            if nextState != nil {
                                setCurrentState(nextState)
                                if eventId.caseInsensitiveCompare(AppFrameworkConstants.BACK_EVENT) != .orderedSame {
                                    push(nextState!)
                                }
                            } else {
                                throw FlowManagerErrors.noStateFoundError
                            }
                        }
                    } else {
                        throw FlowManagerErrors.noStateFoundError
                    }
                } else {
                    throw FlowManagerErrors.nullStateError
                }
            } else {
                throw FlowManagerErrors.flowManagerInitializationError
            }
        } else {
            throw FlowManagerErrors.nullEventError
        }
        return nextState
    }
    
    public func getEventForState(_ state : StateModel? , eventId : String?) -> EventModel? {
        let eventModel = state?.events.filter({ (model) -> Bool in
            return model.eventId?.caseInsensitiveCompare(eventId!) == .orderedSame
        })
        return eventModel?.first
    }
}

// MARK:- Private functions
extension BaseFlowManager {
    
    fileprivate func parseAppFlow(withJsonPath jsonPath : String) throws {
        do {
            if let stateFlow = try AppFlowParser.parseConfig(withJsonPath: jsonPath) {
                appFlowModel = stateFlow
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func possibleStatesForEvent(_ event : EventModel) -> [ConditionModel]? {
        var possibleStates: [ConditionModel]? = nil
        possibleStates = event.nextStates
        return possibleStates
    }
    
    fileprivate func mapCurrentStateModel(_ stateId : String) -> StateModel? {
        let stateModel = appFlowModel.states.filter { (model) -> Bool in
            return model.state == stateId
        }
        return stateModel.first
    }
    
    
    
    fileprivate func isConditionTrue(_ conditionModel:  ConditionModel) throws -> Bool {
        var isTrue = false
        
        if conditionModel.conditions.count == 0 {
            isTrue = true
        } else {
            for condition in conditionModel.conditions {
                if let conditionType = getCondition(condition) {
                    isTrue = isTrue || conditionType.isSatisfied()
                } else {
                    throw FlowManagerErrors.noConditionFoundError
                }
            }
        }
        
        return isTrue
    }
    
    fileprivate func push(_ state : BaseState) {
        appStack.append(state)
    }
    
    fileprivate func pop() {
        if appStack.count > 0 {
            appStack.removeLast()
        }
    }
    
    fileprivate func pop(_ state : BaseState) {
        if appStack.count > 0 {
            let states = appStack.filter({
                $0.stateId == state.stateId
            })
            if states.count > 0 {
                for reversedState in Array(appStack.reversed()) {
                    if reversedState.stateId == state.stateId {
                        break
                    }
                    pop()
                }
            }
            
        }
    }
    
    fileprivate func initializeJson(withJsonPath jsonPath : String) throws {
        if appFlowModel != nil {
            throw FlowManagerErrors.flowManagerAlreadyInitializedError
        }
        
        populateStateMap(&stateMap)
        populateConditionMap(&conditionMap)
        
        do {
            try parseAppFlow(withJsonPath: jsonPath)
        } catch {
            throw error
        }
    }
    
    fileprivate func setCurrentState(_ newState : BaseState?) {
        currentState = newState
    }
}
