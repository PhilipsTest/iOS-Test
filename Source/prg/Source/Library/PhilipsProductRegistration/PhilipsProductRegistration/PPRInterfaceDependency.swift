//
//  PPRInterfaceDependency.swift
//  Pods
//
//  Created by Abhishek on 24/08/16.
//
//

import UIKit
import UAPPFramework
import PlatformInterfaces

/// PPRInterfaceDependency provides interface to add dependencies to product registration module.
/// - Since: 1.0.0
@objcMembers open class PPRInterfaceDependency: UAPPDependencies {
    /// UserDataInterface to interact with user details and token
    /// - Since 1903.0.0
    open var userDataInterface: UserDataInterface!
}

