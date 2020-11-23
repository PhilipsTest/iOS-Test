/* Copyright (c) Koninklijke Philips N.V., 2019
  * All rights are reserved. Reproduction or dissemination
  * in whole or in part is prohibited without the prior written
  * consent of the copyright holder.
  */

import Foundation

class ECSMicroServiceHybrisRequest: NSObject, ECSMicroServiceHybrisRequestProtocol {
    var requestType: String = ""
    var baseURL: String = ECSConfiguration.shared.baseURL ?? ""
    var microserviceEndPoint: String = ""
    var queryParameter: [String: String] = [:]
    var headerParameter: [String: String] = [:]
    var bodyParameter: [String: String] = [:]
    var httpMethod: ECSHTTPMethod = .GET

    override init() {
        super.init()
    }

    convenience init(requestType: String) {
        self.init()
        self.requestType = requestType
    }
}

class  ECSMicroServiceWTBRequest: NSObject, ECSMicroServiceWTBRequestProtocol {
    var requestType: String = ""
    var baseURL: String = ""
    var microserviceEndPoint: String = ""
    var queryParameter: [String: String] = [:]
    var headerParameter: [String: String] = [:]
    var bodyParameter: [String: String] = [:]
    var httpMethod: ECSHTTPMethod = .GET
 }
