//
//  ProductRegistrationHandler.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation
import PhilipsPRXClient
import PlatformInterfaces
import UAPPFramework

/// ### Protocols for Product Registration call backs.
/// - Since: 1.0.0
@objc public protocol PPRRegisterProductDelegate: class {

    /// Success protocol is called if product is registered successfully.
    ///
    /// - Parameters:
    ///   - userProduct: Object of PPRUserWithProducts. This class contains methods for product registration related methods.
    ///   - product: Object of PPRRegisteredProduct. This class contains information of the product along with error while registering, if any.
    /// - Since: 1.0.0
    func productRegistrationDidSucced(userProduct: PPRUserWithProducts, product: PPRRegisteredProduct)

    /// Failure protocol is called if product registration fails.
    ///
    /// - Parameters:
    ///   - userProduct: Object of PPRUserWithProducts. This class contains methods for product registration related methods.
    ///   - product: Object of PPRRegisteredProduct. This class contains information of the product along with error while registering, if any.
    /// - Since: 1.0.0
    func productRegistrationDidFail(userProduct: PPRUserWithProducts, product: PPRRegisteredProduct)
}

/// This class is a wrapper on the Product Registration methods.
/// - Since: 1.0.0
@objc public class PPRProductRegistrationHelper: NSObject {
    
    lazy var user = {
        return PPRInterfaceInput.sharedInstance.appDependency.userDataInterface
    }()
    
    /// The delegate of a *PPRProductRegistrationHelper* must adopt to *PPRRegisterProductDelegate*.
    /// - Since: 1.0.0
    @objc weak public var delegate: PPRRegisterProductDelegate?

    /// Provides the object of PPRUserWithProducts for currently signed in user.
    ///
    /// - Returns: Object of PPRUserWithProducts class.
    /// - Since: 1.0.0
    @objc public func getSignedInUserWithProudcts() -> PPRUserWithProducts? {
        let user = self.user
        let userWithProducts = PPRUserWithProducts()
        userWithProducts.user = user
        userWithProducts.delegate = self.delegate
        return userWithProducts
    }
}
