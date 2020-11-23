/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import AppInfra

class MockAppConfig: NSObject, AIAppConfigurationProtocol {
    
    var propositionID: Any? = "MockPropositionID"
    var apiKey: Any? = "MockAPIKey"
    var getPropertyError: NSError?
    
    func getPropertyForKey(_ key: String!, group: String!) throws -> Any {
        if let getPropertyError = getPropertyError {
            throw getPropertyError
        }
        if key == "propositionId" {
            return propositionID as Any
        } else if key == "PIL_ECommerce_API_KEY" {
            return apiKey as Any
        }
        return ""
    }
    
    func setPropertyForKey(_ key: String!, group: String!, value: Any!) throws {}
    
    func getDefaultProperty(forKey key: String!, group: String!) throws -> Any { return "" }
    
    func refreshCloudConfig(_ completionHandler: ((AIACRefreshResult, Error?) -> Void)!) {}
    
    func resetConfig() throws {}
}
