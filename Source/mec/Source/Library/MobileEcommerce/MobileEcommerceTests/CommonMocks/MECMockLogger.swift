/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import AppInfra

class MECMockLogger: NSObject, AILoggingProtocol {
    
    func createInstance(forComponent componentId: String!, componentVersion: String!) -> AILoggingProtocol! {
        return self
    }
    
    func log(_ level: AILogLevel, eventId: String!, message: String!) {}
    
    func log(_ level: AILogLevel, eventId: String!, message: String!, dictionary: [AnyHashable : Any]!) {}
}
