/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework
import PlatformInterfaces

/**
 IAPDependencies handles the dependency required for IAP. SO right now IAP has one dependency i.e AppInfra.
 So vertical needs to initialize IAPDependencies and set the app infra object. This app infra object will be
 responsible for logging, tagging and some configuration.
 - Since: 1.0.0
 */
@objcMembers open class IAPDependencies: UAPPDependencies {
    /// UserDataInterface to interact with user details and token
    /// - Since 1903.0.0
    open var userDataInterface: UserDataInterface!
}
