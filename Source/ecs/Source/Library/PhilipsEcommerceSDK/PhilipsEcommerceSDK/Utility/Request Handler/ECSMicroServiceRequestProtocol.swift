/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

enum ECSHTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol ECSMicroServiceRequest: class {
    var baseURL: String { get set }
    var httpMethod: ECSHTTPMethod { get set }
    var urlRequest: URLRequest? { get }
    var microserviceEndPoint: String { get set }
    var requestURL: String { get }
    var queryParameter: [String: String] { get set }
    var headerParameter: [String: String] { get set }
    var bodyParameter: [String: String] { get set }

    // MARK: - PIL Microservice methods
    var requestType: String { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension ECSMicroServiceRequest {
    var requestURL: String {
        return "\(self.baseURL)\(self.microserviceEndPoint)"
    }

    var urlRequest: URLRequest? {
        guard let url = URL(string: requestURL) else {
            return nil
        }
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItem = queryParameter.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
        if queryItem.count > 0 {
            if let existingQueryItems = urlComponent?.queryItems, existingQueryItems.count > 0 {
                urlComponent?.queryItems?.append(contentsOf: queryItem)
            } else {
                urlComponent?.queryItems = queryItem
            }
        }

        guard let urlObject = urlComponent?.url else {
            return nil
        }
        var urlRequest = URLRequest(url: urlObject)
        if requestType == ECSConstant.pilKey.rawValue {
            headerParameter[ECSConstant.apiKey.rawValue] = ECSUtility.fetchPILAPIKey()
            headerParameter[ECSConstant.apiVersion.rawValue] = ECSConstant.apiVersionValue.rawValue
        }
        urlRequest.allHTTPHeaderFields = headerParameter
        if bodyParameter.count > 0 {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameter, options: .prettyPrinted)
            if requestType != ECSConstant.pilKey.rawValue {
                urlRequest.setBodyContent(bodyParameter)
            }
        }
        let requestHeaderContentType = requestType == ECSConstant.pilKey.rawValue ?
            "application/json" :
        "application/x-www-form-urlencoded"
        urlRequest.setValue(requestHeaderContentType, forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
}

private extension URLRequest {

    mutating func setBodyContent(_ contentMap: [String: String]?) {
        if let content = contentMap {
            var firstOneAdded = false
            var contentBodyAsString = String()
            let contentKeys: [String] = Array(content.keys)
            for contentKey in contentKeys {
                if let contentValue = content[contentKey] {
                    if !firstOneAdded {
                        contentBodyAsString += contentKey + "=" + contentValue
                        firstOneAdded = true
                    } else {
                        contentBodyAsString += "&" + contentKey + "=" + contentValue
                    }
                }
            }
            contentBodyAsString = contentBodyAsString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            self.httpBody = contentBodyAsString.data(using: String.Encoding.utf8)
        }
    }
}

protocol ECSMicroServiceHybrisRequestProtocol: ECSMicroServiceRequest { }

protocol ECSMicroServiceWTBRequestProtocol: ECSMicroServiceRequest { }
