//
//  PPRUIConfiguration.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import UIKit

/// This class provides interfaces for configuring UI.
/// - Since: 1.0.0
@objc public class PPRUIConfiguration: NSObject {
    
    /// Set background image.
    /// - Since: 1.0.0
    @objc public var productPromotionImage: UIImage?
    override init() {
        super.init()
    }
}
