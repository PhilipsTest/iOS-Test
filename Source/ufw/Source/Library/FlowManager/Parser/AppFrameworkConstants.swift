/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/** 
 * Constant structure that contains the Configuration Keys
 * Any new keys, to be added to AppFrameworkConstants structure
 */
struct AppFrameworkConstants {
    
    static let FLOW_CONFIG_FIRST_STATE_KEY = "firstState"
    static let FLOW_CONFIG_STATES_KEY = "states"
    static let FLOW_CONFIG_STATE_KEY = "state"
    static let FLOW_CONFIG_NEXT_STATE_KEY = "nextState"
    static let FLOW_CONFIG_NEXT_STATES_KEY = "nextStates"
    static let FLOW_CONFIG_CONDITION_KEY = "condition"
    static let FLOW_CONFIG_EVENTID_KEY = "eventId"
    static let FLOW_CONFIG_APP_FLOW_KEY = "appflow"
    static let FLOW_CONFIG_EVENTS_KEY = "events"
    static let BACK_EVENT = "back"
    static let QUEUE_IDENTIFIER = "com.Philips.uAppFramework"
}
