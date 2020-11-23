/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class IAPMockingHelper: NSObject {
    class func getReponseForURL(methodName: String, url: String)-> [String: AnyObject] {
        let environmentData = ProcessInfo.processInfo.environment
        var jsonFileName: String?
        guard let className = environmentData["MockBundleClass"] else {
            return [:]
        }   
        
        if url.contains("oauth/token") {
            jsonFileName = "bearerAuth"
        } else {
            jsonFileName = "\(methodName.lowercased())\(getEncodedString(url: url))"
        }
        guard let bundleClassName = NSClassFromString(className) else {
            return [:]
        }
        let bundle = Bundle(for: bundleClassName)
        guard let path = bundle.path(forResource: jsonFileName, ofType: "json") else {
            return [:]
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            return jsonResult as? [String: AnyObject] ?? [:]
        } catch {
            return [:]
        }
    }
    
    class func getEncodedString(url: String) -> String {
        return url.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
