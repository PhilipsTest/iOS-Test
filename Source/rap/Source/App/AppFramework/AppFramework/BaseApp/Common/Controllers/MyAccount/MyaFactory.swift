/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import MyAccount
import UAPPFramework

class MyaFactory {
    
    public func createMyaInterface() -> MYAInterface {
        let uAppDependencies = UAPPDependencies()
        uAppDependencies.appInfra = AppInfraSharedInstance.sharedInstance.appInfraHandler
        return MYAInterface(dependencies: uAppDependencies, andSettings: nil)
    }
    
}
