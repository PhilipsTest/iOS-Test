/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import PhilipsUIKitDLS
import PhilipsEcommerceSDK

extension Array where Element == String {

    func formatCTNList() -> [String] {

        var result = [String]()
        for value in self {
            result.append(value.replacingOccurrences(of: "_", with: "/"))
        }
        return result
    }
}

extension Array where Element: Equatable {

    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

extension Float {
    func rounded(digits: Int) -> Float {
        let multiplier = pow(10.0, Float(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

extension Date {

    func convertToReviewFormat() -> String {
        let reviewDateFormatter = DateFormatter()
        reviewDateFormatter.dateFormat = "dd-MM-yyyy"
        let reviewDateString = reviewDateFormatter.string(from: self)
        return reviewDateString
    }
}

extension String {

    mutating func appendWith(text: String?, withPrefix textPrefix: String?) {
        guard let text = text, text.count > 0 else {
            return
        }
        guard self.count > 0 else {
            self.append(text)
            return
        }
        let prefix = textPrefix ?? ""
        prefix.count > 0 ? self.append("\(prefix)\(text)") : self.append(text)
    }

    mutating func appendWith(text: String?, withSuffix textSuffix: String?) {
        guard let text = text, text.count > 0 else {
            return
        }
        let suffix = textSuffix ?? ""
        suffix.count > 0 ? self.append("\(text)\(suffix)") : self.append(text)
    }

    func isExtensionOfTypeVideo() -> Bool {
        let videoFormats = ["WEBM",
                            "MPG",
                            "MP2",
                            "MPEG",
                            "MPE",
                            "MPV",
                            "OGG",
                            "MP4",
                            "M4P",
                            "M4V",
                            "AVI",
                            "WMV",
                            "MOV",
                            "QT",
                            "FLV",
                            "SWF",
                            "AVCHD"]
        return videoFormats.contains { $0.lowercased().compare(self.lowercased()) == .orderedSame }
    }

    func fetchMECCountryCode() -> String? {
        let localeDelimiter = CharacterSet(["_", "-"])
        let localeComponents = components(separatedBy: localeDelimiter)
        if localeComponents.count > 1,
            let countryCode = localeComponents.last,
            countryCode.count > 0 {
            return countryCode
        }
        return nil
    }
}

extension StringProtocol where Index == String.Index {
    func nsRange(of string: String) -> NSRange? {
        guard let range = self.range(of: string) else {  return nil }
        return NSRange(range, in: self)
    }
}

extension Locale {
    static let currency: [String: (code: String?, symbol: String?)] = Locale.isoRegionCodes.reduce(into: [:]) {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
        $0[$1] = (locale.currencyCode, locale.currencySymbol)
    }
}

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }

    func handleOauthError(completion: @escaping (_ handled: Bool, _ error: Error?) -> Void) {
        guard code == 5009 || code == 6025 else {
            completion(false, self)
            return
        }
        MECOAuthHandler.shared.refreshHybris { (_, error) in
            guard let error = error else {
                completion(true, nil)
                return
            }
            completion(false, error)
        }
    }
}

extension String: MECPopoverDataProtocol {
    func titleForItem() -> String {
        return self
    }
}
