/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation

extension String {
    mutating func isValidCTN() -> Bool {
        self = trimmingCharacters(in: .whitespacesAndNewlines)
        return self.count > 0 && !self.contains(" ")
    }

    mutating func isValidEmail() -> Bool {
        self = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard isEmpty == false else {
            return false
        }
        // swiftlint:disable line_length
        let pattern = "^[A-Za-z0-9!#$%&'*+\\/=?^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%&'*+\\/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?$"
        // swiftlint:enable line_length
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
}
