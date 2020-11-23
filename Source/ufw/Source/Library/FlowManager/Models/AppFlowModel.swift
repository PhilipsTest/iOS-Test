/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
/**
 Model used to map the json data of nextStates and Conditions.
 */
public struct ConditionModel: Codable {
    /// Variable that holds the next state value
    var nextState: String?
    /// Variable that holds the condition that app is at
    var conditions: [String] = []
    private enum CodingKeys: String, CodingKey {
        case conditions = "condition"
        case nextState = "nextState"
    }
}

/**
 Model used to map variables to eventId and nextStates.
 */
public struct EventModel : Codable {
    /// Variable that holds the event id that is clicked or landed at
    var eventId : String?
    /// Variable that holds the chain of next states based on the corresponding event
    var nextStates: [ConditionModel] = []
}

/**
 Model used to map variables to state and events.
 */
public struct StateModel: Codable {
    /// Variable that holds the state at which the application is in
    var state: String?
    /// Variable that holds the chain of events, corresponding to the state of app
    var events : [EventModel] = []
}

/**
 Model used to map variables to firstState and states.
 */
public struct AppFlowModel: Codable {
    /// Variable that holds the first state after the launch of app
    var firstState: String?
    /// Variable that holds the chain of next states across the application flow
    var states: [StateModel] = []
}
