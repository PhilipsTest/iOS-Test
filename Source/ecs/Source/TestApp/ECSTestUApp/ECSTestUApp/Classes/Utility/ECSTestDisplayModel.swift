/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ECSTestMicroservicsData: NSObject, Codable {
    var microservices: [ECSTestMicroserviceModel]?
    
    enum CodingKeys: String, CodingKey {
        case microservices = "AllMicroservices"
    }
}

class ECSTestMicroserviceModel: NSObject, Codable {
    var microserviceGroupDisplayName: String
    var microServiceGroups: [ECSTestMicroServiceGroupModel]?
    
    enum CodingKeys: String, CodingKey {
        case microServiceGroups = "MicroServiceGroups"
        case microserviceGroupDisplayName = "DisplayName"
    }
}

class ECSTestMicroServiceGroupModel: NSObject, Codable {
    var microServiceGroupName: String
    var microServicesDetails: [ECSTestMicroServiceDisplayModel]?
    
    enum CodingKeys: String, CodingKey {
        case microServiceGroupName = "MainMicroServiceName"
        case microServicesDetails = "EmbeddedMicroServices"
    }
}

class ECSTestMicroServiceDisplayModel: NSObject, Codable {
    var microServiceName: String
    var microServiceIdentifier: String
    var shouldHideClearButton: Bool?
    var microServiceInputs: [ECSTestDisplayInput]?
    
    enum CodingKeys: String, CodingKey {
        case microServiceName = "EmbeddedMicroServicesName"
        case microServiceIdentifier = "EmbeddedMicroServicesIdentifier"
        case shouldHideClearButton = "HidesClearButton"
        case microServiceInputs = "EmbeddedMicroServicesInput"
    }
}

class ECSTestDisplayInput: NSObject, Codable {
    var inputType: Int
    var inputDisplayText: String
    var inputPlaceHolderText: String
    var inputIdentifier: Int
    
    enum CodingKeys: String, CodingKey {
        case inputType = "InputType"
        case inputDisplayText = "InputDisplayName"
        case inputPlaceHolderText = "InputPlaceholderName"
        case inputIdentifier = "InputIdentifier"
    }
}
