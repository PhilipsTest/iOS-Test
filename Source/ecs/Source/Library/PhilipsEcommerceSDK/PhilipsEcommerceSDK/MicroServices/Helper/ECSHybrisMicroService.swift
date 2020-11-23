/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

protocol ECSHybrisMicroService: ECSMicroServices {
    func getHybrisError(for data: Data) -> ECSHybrisError?
    // MARK: - PIL Microservices
    func getPILHybrisError(for data: Data) -> ECSPILHybrisErrors?
}

extension ECSHybrisMicroService {
    func getHybrisError(for data: Data) -> ECSHybrisError? {
        do {
            let jsonDecoder = JSONDecoder()
            let hybrisError = try jsonDecoder.decode(ECSHybrisError.self, from: data)
            return hybrisError
        } catch {
            ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                   eventId: "ECSParsingError",
                                                   message: "\(error.fetchCatchErrorMessage())")
            return ECSHybrisError()
        }
    }

    // MARK: - PIL Microservices

    func getPILHybrisError(for data: Data) -> ECSPILHybrisErrors? {
        do {
            let jsonDecoder = JSONDecoder()
            let pilHybrisError = try jsonDecoder.decode(ECSPILHybrisErrors.self, from: data)
            return pilHybrisError
        } catch {
            ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                   eventId: "ECSPILParsingError",
                                                   message: "\(error.fetchCatchErrorMessage())")
            return ECSPILHybrisErrors()
        }
    }
}
