/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

class ECSRestClientCommunicator: NSObject {

    func performRequestAsynchronously(for requester: ECSMicroServiceRequest?,
                                      with appInfra: AIAppInfra,
                                      completionHandler: @escaping (Data?, Error?) -> Void) {
        guard let request = requester?.urlRequest else {
            completionHandler(nil, ECSHybrisError().hybrisError)
            return
        }
        let requestCurl = request.convertURLRequestToString()
        ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                               eventId: "ECSRequest",
                                               message: "Request: \n \(requestCurl)")
        let restClient = appInfra.restClient.createInstance(with: .ephemeral)
        restClient.responseSerializer = AIRESTClientJSONResponseSerializer()

            let task = restClient.dataTask(with: request) { (_, responseObject, error) in
            if let error = error {
                // swiftlint:disable line_length
                ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                       eventId: "ECSRequestError",
                                                       message: "Request with details: \n \(requestCurl) \n\n failed with error: \n \(error.fetchResponseErrorMessage()) \n\n with errorDetails: \n \(self.fetchErrorDetailsMessageFor(responseObject: responseObject))")
                // swiftlint:enable line_length
            }
            if responseObject != nil {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: responseObject as Any, options: .prettyPrinted)
                    completionHandler(jsonData, error)
                } catch {
                    ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                           eventId: "ECSParsingError",
                                                           message: "\(error.fetchCatchErrorMessage())")
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, error)
            }
        }
        appInfra.restClient.setSessionDidReceiveAuthenticationChallenge { (_, _, _) -> URLSession.AuthChallengeDisposition in
            return .useCredential
        }
        task.resume()
    }
}

// MARK: - Helper methods

extension ECSRestClientCommunicator {

    func fetchErrorDetailsMessageFor(responseObject: Any?) -> String {
        if let responseDict = responseObject as? [String: Any] {
            return responseDict.description
        }
        return ""
    }
}

extension URLRequest {

    func convertURLRequestToString() -> String {
        let httpMethod = self.httpMethod ?? ""
        let url = self.url?.absoluteString ?? ""
        let httpHeaders = self.allHTTPHeaderFields
        let bodyParameters = self.requestBodyString()
        var curlCommandString = String(format: "curl -v -X %@ ", httpMethod)

        curlCommandString.append(String(format: "\'%@\' ", url))
        httpHeaders?.forEach({ (key: String, value: String) in
            curlCommandString.append(String(format: "-H \'%@: %@\' ", key, value))
        })

        if bodyParameters.count > 0 {
            curlCommandString.append("-d \'")
            curlCommandString.append(bodyParameters)
            curlCommandString = String(curlCommandString.dropLast())
            curlCommandString.append("'")
        }
        return curlCommandString
    }

    func requestBodyString() -> String {
        guard let requestBody = self.httpBody else { return "" }
        return String(data: requestBody, encoding: String.Encoding.utf8) ?? ""
    }
}

extension Error {

    func fetchResponseErrorMessage() -> String {
        if let error = self as NSError? {
            return "\(error.code): \(error.localizedDescription)"
        }
        return ""
    }

    func fetchCatchErrorMessage() -> String {
        if let error = self as NSError? {
            return "Error: \(error.localizedDescription) \n with description: \(error.debugDescription)"
        }
    }
}
