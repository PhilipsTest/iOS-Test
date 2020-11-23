/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

@objcMembers class ECSHybrisError: NSObject, Codable {
    var error, errorDescription: String?
    var net: Bool?
    var errors: [HybrisErrorDetail]?

    override init() {
        super.init()
    }

    init(with errorType: ECSHybrisErrorType) {
        error = String(describing: errorType)
    }

    enum CodingKeys: String, CodingKey {
        case error, net, errors
        case errorDescription = "error_description"
    }

    var hybrisError: Error? {
        var type: ECSHybrisErrorType?
        if let error = error {
            type = ECSHybrisErrorType.errorType(getECSErrorType(type: error))
        } else if let error = errors?.first {
            type = ECSHybrisErrorType.errorType(getECSErrorType(type: error.type))
        } else {
            type = ECSHybrisErrorType.errorType(nil)
        }
        return type?.error
    }

    var subjectError: Error? {
        var type: ECSHybrisErrorType?
        if let error = error {
            type = ECSHybrisErrorType.errorType(error)
        } else if let error = errors?.first {
            if let errorSubject = error.getSubjectFormatted {
                type = ECSHybrisErrorType.errorType(getECSErrorType(type: errorSubject))
            } else {
                type = ECSHybrisErrorType.errorType(getECSErrorType(type: error.type))
            }
        } else {
            type = ECSHybrisErrorType.errorType(nil)
        }
        return type?.error
    }
}

// Helper methods
extension ECSHybrisError {
    func getECSErrorType(type: String?) -> String {
        guard let inType = type else { return "" }
        return inType.hasPrefix("ECS") ? inType : "ECS\(inType)"
    }
}

@objcMembers class HybrisErrorDetail: NSObject, Codable {
    var type: String?
    var message, reason, subject, subjectType: String?

    var getSubjectFormatted: String? {
        return subject?.replacingOccurrences(of: ".", with: "")
    }
}
