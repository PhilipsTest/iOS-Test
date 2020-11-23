/* Copyright (c) Koninklijke Philips N.V., 2017
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

class ComponentMetadata {
    private var name: String
    private var version: String?
    var description: String

    init(name: String, version: String?, description: String) {
        self.name = name
        self.version = version
        self.description = description
    }

    func formattedNameAndVersion() -> String {
        return "\(name) - \(version ?? "Not Available")"
    }
}
