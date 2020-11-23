/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework
import PlatformInterfaces

/**
MECDependencies handles the dependency required for MEC.
Propositions needs to initialize MECDependencies and set the dependency objects which will be used throughout MEC for different actions
- Since: 2001.0
*/
@objcMembers open class MECDependencies: UAPPDependencies {

    /**
     This variable is used to hold the UserDataInterface object which will be used to interact with user details and access token
    - Since 2001.0
     */
    open var userDataInterface: UserDataInterface!
}
