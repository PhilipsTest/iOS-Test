//
//  PPRLaunchData.swift
//  PhilipsProductRegistration
//
//  Created by Abhishek on 11/08/16.
//  Copyright © 2016 Philips. All rights reserved.
//

import Foundation
import UAPPFramework

/// This model class encapsulates all essential inputs to launch Product Registration.
/// - Since: 1.0.0
@objc public class PPRLaunchInput: UAPPLaunchInput {

    /// This provides information of any product.
    /// - Since: 1.0.0
    @objc public var productInfo: [PPRProduct]?
    
    /// This provides interfaces for configuring product registration user interface, launch option and content where configurable text is available.
    /// - Since: 1.0.0
    @objc public var launchConfiguration: PPRConfiguration?
    
    /// This provides protocols for Product Registration call backs.
    /// - Since: 1.0.0
    @objc weak public var userInterfacedelegate: PPRUserInterfaceDelegate!
}
