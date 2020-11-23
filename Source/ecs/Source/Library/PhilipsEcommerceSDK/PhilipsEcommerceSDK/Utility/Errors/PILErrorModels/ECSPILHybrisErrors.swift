/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

// MARK: - ECSPILHybrisErrors
@objcMembers class ECSPILHybrisErrors: NSObject, Codable {
    var errors: [ECSPILHybrisError]?

    override init() {
        super.init()
    }

    convenience init(errorType: ECSHybrisErrorType) {
        self.init()
        let error = ECSPILHybrisError()
        error.code = String(describing: errorType)
        errors = [error]
    }
}

// MARK: - ECSPILHybrisError
@objcMembers class ECSPILHybrisError: NSObject, Codable {
    // swiftlint:disable identifier_name
    var id, status, code, title: String?
    // swiftlint:enable identifier_name
    var source: ECSPILErrorSource?
}

// MARK: - ECSPILErrorSource
@objcMembers class ECSPILErrorSource: NSObject, Codable {
    var parameter: String?
}

extension ECSPILHybrisErrors {

    var hybrisPILError: Error? {
        var type: ECSHybrisErrorType?
        if let error = errors?.first {
            type = ECSHybrisErrorType.errorType(getECSPILErrorType(error: error))
        } else {
            type = ECSHybrisErrorType.errorType(nil)
        }
        return type?.error
    }

    func getECSPILErrorType(error: ECSPILHybrisError?) -> String {
        guard let error = error else { return "" }
        guard let errorCode = error.code else { return "" }
        guard !errorCode.hasPrefix("ECS") else { return errorCode }
        guard let errorType = error.source?.parameter else { return "\(ECSConstant.errorTypePrefix.rawValue)\(errorCode)" }
        guard errorType.hasPrefix("[") && errorType.hasSuffix("]") else {
            return "\(ECSConstant.errorTypePrefix.rawValue)\(errorCode)"
        }
        let trimmedErrorParts = errorType.dropFirst().dropLast().split(separator: ",")
        if trimmedErrorParts.count > 0,
            let firstErrorType = trimmedErrorParts.first {
            return "\(ECSConstant.errorTypePrefix.rawValue)\(errorCode)_\(firstErrorType)"
        }
        return "\(ECSConstant.errorTypePrefix.rawValue)\(errorCode)"
    }
}
