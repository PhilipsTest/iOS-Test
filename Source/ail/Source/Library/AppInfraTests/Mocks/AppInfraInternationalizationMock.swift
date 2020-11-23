/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import AppInfra

@objcMembers public class AppInfraInternationalizationMock: NSObject, AIInternationalizationProtocol {
    public func getUILocale() -> Locale! {
        return Locale(identifier: "en_US")
    }
    
    public func getUILocaleString() -> String! {
        return "en_US"
    }
    
    public func getBCP47UILocale() -> String! {
        return "en_US"
    }
}
