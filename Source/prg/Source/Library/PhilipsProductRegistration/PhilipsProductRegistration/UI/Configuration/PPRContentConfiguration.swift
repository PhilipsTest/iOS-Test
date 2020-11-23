//
//  PPRContentConfiguration.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

/// This class provides interfaces for configuring text in benefit screen and success screen.
/// - Since: 1.0.0
@objc public class PPRContentConfiguration: NSObject {
    
    /// Set the description that user is going to get benefit with product registration. If multilple benefits are there, please provide the content separated by \n. To be displayed at screen PR-1a.(Please refer to the [flow document](http://tfsemea1.ta.philips.com:8080/tfs/TPC_Region24/CDP2/TEAM%20Huma/_git/prg-ios?path=%2FDocuments%2FExternal%2FUX%20flow_%20product%20registration_v0.8.pdf&version=GBdevelop&_a=contents) for more info).
    /// - Since: 1.0.0
    @objc public var benefitText: String?
    
    /// Set the description along with extended warranty after successful registration of product. To be displayed at screen PR-4b.(Please refer to the [flow document](http://tfsemea1.ta.philips.com:8080/tfs/TPC_Region24/CDP2/TEAM%20Huma/_git/prg-ios?path=%2FDocuments%2FExternal%2FUX%20flow_%20product%20registration_v0.8.pdf&version=GBdevelop&_a=contents) for more info). The default localized text for the key PRG_Extended_Warranty_Lbltxt will be displayed in case vertical is not providing the description.
    /// - Since: 1.0.0
    @objc public var extendWarrantyText: String?
    
    /// Set the description about what information user will get via email. To be displayed at screen PR-4b.(Please refer to the [flow document](http://tfsemea1.ta.philips.com:8080/tfs/TPC_Region24/CDP2/TEAM%20Huma/_git/prg-ios?path=%2FDocuments%2FExternal%2FUX%20flow_%20product%20registration_v0.8.pdf&version=GBdevelop&_a=contents) for more info). The default localized text for the key PRG_Eamil_Sent_Lbltxt will be displayed in case vertical is not providing the description.
    /// - Since: 1.0.0
    @objc public var emailText: String?
    
    /// Set the button text of the product registeration button in case if mandatoryProductRegistration is set to true. To be displayed at screen PR-4b.(Please refer to the [flow document](https://confluence.atlas.philips.com/display/UC/PR+%7C+Product+Registration) for more info).
    /// - Since: 1805.0.0
    @objc public var mandatoryRegisterButtonText: String?
    
    /// Set the value as true and false to hide the "No Thanks, Register Later" button.(Please refer to the [flow document](https://confluence.atlas.philips.com/display/UC/PR+%7C+Product+Registration) for more info).
    /// - Since: 1805.0.0
    public var mandatoryProductRegistration: Bool?
}
