
/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


import Foundation

class ECSTestUtility: NSObject {
    class func getResponseFrom(jsonFile: String) -> Any? {
        
        if let path = Bundle(for: self).path(forResource: jsonFile, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                return jsonResult
            } catch {}
        }
        return nil
    }
    
    class func fetchQueryParameterFor(url: URL?) -> [String: String]? {
        guard let url = url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    class func stripQueryParametersFor(url: URL?) -> URL? {
        guard let url = url else { return nil }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = nil
        return components?.url
    }
    
    class func requestBodyString(request: URLRequest?) -> String {
        guard let requestBody = request?.httpBody else { return "" }
        return String(data: requestBody, encoding: String.Encoding.utf8) ?? ""
    }
    
    class func requestBodyDict(request: URLRequest?) -> [String: Any] {
        guard let requestBody = request?.httpBody else { return [:] }
        do {
            return try JSONSerialization.jsonObject(with: requestBody, options: []) as? [String: Any] ?? [:]
        } catch {
            return [:]
        }
    }
}
