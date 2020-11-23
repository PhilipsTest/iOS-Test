/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import AppAuth
import AppInfra

class PIMOIDCConfiguration {
    
    private var oidcConfig: OIDServiceConfiguration?
    
    init(_ oidcConfiguration:OIDServiceConfiguration){
        oidcConfig = oidcConfiguration
    }
    
    func oidcConfiguration() -> OIDServiceConfiguration? {
        return oidcConfig
    }
}
