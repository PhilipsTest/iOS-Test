/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

class ECSConfiguration: NSObject {
    static let shared = ECSConfiguration()

    var locale: String? {
        didSet {
            populateLanguageAndCountryValues()
        }
    }
    var propositionId: String? {
        didSet {
            invalidateConfiguration()
        }
    }
    var appInfra: AIAppInfra?
    var siteId: String?
    var rootCategory: String?
    var baseURL: String?
    var hybrisToken: String?
    var ecsLogger: AILoggingProtocol?
    var language: String?
    var country: String?
    var apiKey: String?

    func invalidateConfiguration() {
        rootCategory = nil
        siteId = nil
        locale = nil
    }

    func initialiseECSLogger() {
        ecsLogger = appInfra?.logging.createInstance(forComponent: ECSConstant.ecsTLA.rawValue,
                                                     componentVersion: fetchComponentVersion())
    }

    private func fetchComponentVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    func configurePropositionID() {
        propositionId = appInfra?.fetchConfigValueFor(key: ECSConstant.propositionIDKey.rawValue,
                                                      group: ECSConstant.mecGroupName.rawValue)
    }

    func populateLanguageAndCountryValues() {
        language = nil
        country = nil
        if let localeParts = locale?.components(separatedBy: "_"), localeParts.count == 2 {
            language = localeParts.first
            country = localeParts.last
        }
    }

    func configureAPIKey() {
        apiKey = appInfra?.fetchConfigValueFor(key: ECSConstant.apiKeyConfigKey.rawValue,
                                               group: ECSConstant.mecGroupName.rawValue)
    }
}
