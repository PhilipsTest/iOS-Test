/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UIKit

extension String {
    var length: Int {
        return self.count
    }

    var byWords: [String] { return components(separatedBy: .byWords) }
    func components(separatedBy options: EnumerationOptions) -> [String] {
        var components: [String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: options) { (component, _, _, _) in
            guard let component = component else { return }
            components.append(component)
        }
        return components
    }
    
    func contains(_ find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    func replaceCharacter(_ characterToReplace: String, withCharacter: String) -> String {
        return self.replacingOccurrences(of: characterToReplace, with: withCharacter)
    }

    mutating func appendedLanguageURL()->String {
        guard false == self.contains("client_secret") else {
            return self
        }
        let languageCode = IAPConfiguration.sharedInstance.locale!
        guard false == self.contains("?lang=") else {
            self += languageCode
            return self
        }
        guard false == self.contains("&lang=") else {
            self += languageCode
            return self
        }
        guard false == self.contains("/wtb/") else {
            return self
        }
        self += "?lang=" + (languageCode)
        return self
    }
    
    func replaceCharacters(_ characters: String, withCharacter: String) -> String {
        let characterSet = CharacterSet(charactersIn: characters)
        let components = self.components(separatedBy: characterSet)
        let result = components.joined(separator: withCharacter)
        return result
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        
        return boundingBox.height
    }
    
    func removeCharacterAtEndOfString(_ count: Int) -> String? {
        guard count > 0 else { return nil}
        return String(self.dropLast(count))
    }
}
