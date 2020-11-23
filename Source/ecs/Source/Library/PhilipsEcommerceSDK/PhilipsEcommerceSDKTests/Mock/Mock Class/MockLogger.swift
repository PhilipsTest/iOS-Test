/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

class MockLogger: NSObject, AILoggingProtocol {
    
    var logLevel: AILogLevel?
    var logEventID: String?
    var logMessage: String?
    
    func createInstance(forComponent componentId: String!, componentVersion: String!) -> AILoggingProtocol! {
        return self
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!) {
        logLevel = level
        logEventID = eventId
        logMessage = message
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!, dictionary: [AnyHashable : Any]!) {}
}
