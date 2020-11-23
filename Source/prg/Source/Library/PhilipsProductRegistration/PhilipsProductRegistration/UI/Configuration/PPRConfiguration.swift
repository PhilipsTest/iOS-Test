//
//  PPRConfiguration.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

/// PPRUILaunchOption enum denotes the current launchOption of registration UI flow.
/// - Since: 1.0.0

@objc public enum PPRUILaunchOption: Int {
    
    /// App setup flow. To be displayed at screen PR-1a.(Please refer to the [flow document](http://tfsemea1.ta.philips.com:8080/tfs/TPC_Region24/CDP2/TEAM%20Huma/_git/prg-ios?path=%2FDocuments%2FExternal%2FUX%20flow_%20product%20registration_v0.8.pdf&version=GBdevelop&_a=contents) for more info).
    /// - Since: 1.0.0
    case WelcomeScreen
    
    /// User initiated  flow. To be displayed at screen PR-1b.(Please refer to the [flow document](http://tfsemea1.ta.philips.com:8080/tfs/TPC_Region24/CDP2/TEAM%20Huma/_git/prg-ios?path=%2FDocuments%2FExternal%2FUX%20flow_%20product%20registration_v0.8.pdf&version=GBdevelop&_a=contents) for more info).
    /// - Since: 1.0.0
    case ProductRegistrationScreen
}

/// This class provides interfaces for configuring product registration user interface, launch option and content where configurable text is available.
/// - Since: 1.0.0
@objc public class PPRConfiguration: NSObject {
    
    /// Set the launch option to initiate app setup flow or user initiated flow configuration object. Default will app setup flow.
    /// - Since: 1.0.0
    @objc public var launchOption: PPRUILaunchOption = .WelcomeScreen
    
    /// Use this to provide if Product Registration should animate or not while poping itself out of current navigation stack. Default is true.
    /// - Since: 18.2.0
    public var animateExit: Bool = true
    
    /// Set the ProductRegistration UI configuration object.
    /// - Since: 1.0.0
    @objc public lazy var userInterfaceConfiguration: PPRUIConfiguration = {
       return PPRUIConfiguration()
    }()
    
    /// Set the ProductRegistration content configuration object.
    /// - Since: 1.0.0
    @objc public lazy var  contentConfiguration: PPRContentConfiguration = {
        return PPRContentConfiguration()
    }()
}
