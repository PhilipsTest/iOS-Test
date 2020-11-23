//
//  NSBundle.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

extension Bundle {
    
    class func localBundle() -> Bundle {
        return Bundle(for: PPRProductRegistrationUIHelper.classForCoder())
    }
    
    class var applicationVersionNumber: String {
        if let version = localBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Version Number Not Available"
    }
    
    class var applicationBuildNumber: String {
        if let build = localBundle().infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Build Number Not Available"
    }
}
