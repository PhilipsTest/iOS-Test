/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

protocol ECSWTBMicroService: ECSMicroServices {
    func getWTBError(for data: Data) -> NSError?
}

extension ECSWTBMicroService {
    func getWTBError(for data: Data) -> NSError? {
        var requestError: NSError?
        do {
            let jsonDecoder = JSONDecoder()
            let wtbError = try jsonDecoder.decode(ECSWTBError.self, from: data)
            if let success = wtbError.success, success == false {
                let userInfo: [String: Any]? = [NSLocalizedDescriptionKey: wtbError.failureReason ?? wtbError.message ?? "",
                                                NSLocalizedFailureReasonErrorKey: wtbError.failureReason ??
                                                    wtbError.message ?? ""]
                requestError = NSError(domain: "WTBError", code: 404, userInfo: userInfo)
            }
        } catch {
            ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                   eventId: "ECSParsingError",
                                                   message: "\(error.fetchCatchErrorMessage())")
            requestError = error as NSError
        }

        return requestError
    }
}
