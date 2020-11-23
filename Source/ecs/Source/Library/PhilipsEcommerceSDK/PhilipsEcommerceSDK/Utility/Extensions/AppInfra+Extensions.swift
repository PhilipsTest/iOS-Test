/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

extension AIAppInfra {

    func fetchConfigValueFor(key: String, group: String) -> String? {
        do {
            return try ECSConfiguration.shared.appInfra?.appConfig.getPropertyForKey(key,
                                                                            group: group) as? String
        } catch {
            ECSConfiguration.shared.ecsLogger?.log(.verbose,
                                                   eventId: "ECSParsingError",
                                                   message: "\(error.fetchCatchErrorMessage())")
            return nil
        }
    }
}
