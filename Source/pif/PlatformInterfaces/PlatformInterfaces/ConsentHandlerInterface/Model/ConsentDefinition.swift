/* Copyright (c) Koninklijke Philips N.V., 2019
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation

@objcMembers public class ConsentDefinition : NSObject {
    private var types: [String]
    public var text: String
    public var helpText: String
    public var version: Int
    public var locale: String
    public var revokeMessage: String?
    
    public init(types: [String], text: String, helpText: String, version: Int, locale: String) {
        precondition(types.count > 0)
        self.types = types
        self.text = text
        self.helpText = helpText
        self.version = version
        self.locale = locale
        super.init()
    }
    
    public convenience init(type: String, text: String, helpText: String, version: Int, locale: String) {
        self.init(types: [type], text: text, helpText: helpText, version: version, locale: locale)
    }
    
    public convenience init(type: String, text: String, helpText: String, version: Int, locale: String, revokeMessage: String) {
        self.init(types: [type], text: text, helpText: helpText, version: version, locale: locale)
        self.revokeMessage = revokeMessage
    }
    
    public convenience init(types: [String], text: String, helpText: String, version: Int, locale: String, revokeMessage: String) {
        self.init(types: types, text: text, helpText: helpText, version: version, locale: locale)
        self.revokeMessage = revokeMessage
    }
    
    public func getTypes() -> [String] {
        return types
    }
    
    public static func == (lhs: ConsentDefinition, rhs: ConsentDefinition) -> Bool {
        return lhs.helpText == rhs.helpText &&
            lhs.locale == rhs.locale &&
            lhs.text == rhs.text &&
            lhs.version == lhs.version &&
            lhs.types.sorted() == rhs.types.sorted() &&
            lhs.revokeMessage == rhs.revokeMessage
    }
}
