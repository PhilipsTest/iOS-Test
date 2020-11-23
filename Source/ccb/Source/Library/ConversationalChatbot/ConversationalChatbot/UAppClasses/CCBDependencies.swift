/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import UAPPFramework

@objcMembers open class CCBDependencies: UAPPDependencies {
    
    open var chatbotConfiguration: CCBConfiguration? {
        didSet {
            //TODO:set configuration to shared handler which can be accessed from anywhere
        }
    }
    
}
