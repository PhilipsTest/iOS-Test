/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

/** 
 * AppFlowParser Handles the Parsing Logic that is read from json file
 */
struct AppFlowParser {
    
    /** Parsing Logic , Reading JSON from jsonpath
     
     - Parameter jsonPath: Is the file path where json is available
     - Returns : AppFlowModel, which has mapped JSON object to a Mappable object
     - Since 1.1.0
     */
    static func parseConfig(withJsonPath jsonPath : String) throws -> AppFlowModel? {
        var stateFlowModel : AppFlowModel?
        var appflowJson: [String : AppFlowModel]?
        if FileManager.default.fileExists(atPath: jsonPath) {
            
            if let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
                do {
                    try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                } catch {
                    throw FlowManagerErrors.jsonSyntaxError
                }
                let decoder = JSONDecoder()
                do {
                    appflowJson = try decoder.decode([String:AppFlowModel].self , from: Data(contentsOf: URL(fileURLWithPath: jsonPath)))
                } catch let error {
                    print(error.localizedDescription)
                }
                stateFlowModel =  appflowJson?[AppFrameworkConstants.FLOW_CONFIG_APP_FLOW_KEY]
            }
        } else {
            throw FlowManagerErrors.fileNotFoundError
        }
        return stateFlowModel
    }
}
