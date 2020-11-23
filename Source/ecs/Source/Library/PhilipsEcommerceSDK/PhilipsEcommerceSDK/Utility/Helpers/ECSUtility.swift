/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsPRXClient

class ECSUtility: NSObject {
    class func getECSBundle() -> Bundle {
        return Bundle(for: self)
    }

    func ECSLocalizedString(_ key: String, _ args: CVarArg...) -> String {

        let localizedFormat = NSLocalizedString(key, bundle: ECSUtility.getECSBundle(), comment: key)
        return args.count == 0
            ? localizedFormat
            : String(format: localizedFormat, arguments: args)
    }

    class func fetchDefaultClientSecret() -> String {
        let appState = ECSConfiguration.shared.appInfra?.appIdentity.getAppState()
        return appState == .PRODUCTION ? "prod_inapp_54321" : "acc_inapp_12345"
    }

    // MARK: - PIL Microservice methods

    class func fetchPILAPIKey() -> String {
        return ECSConfiguration.shared.apiKey ?? ""
    }

    @objc dynamic class func getPRXRequestManager() -> PRXRequestManager {
        let prxDependencies = PRXDependencies(appInfra: ECSConfiguration.shared.appInfra,
                                              parentTLA: ECSConstant.ecsTLA.rawValue)
        return PRXRequestManager(dependencies: prxDependencies)
    }
}
