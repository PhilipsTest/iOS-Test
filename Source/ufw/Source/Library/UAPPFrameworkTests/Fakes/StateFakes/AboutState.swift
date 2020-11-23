/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import UIKit
@testable import UAPPFrameworkDev

/** AboutState is inherited from BaseState */
class AboutState: BaseState {
    
    override init() {
        super.init(stateId : AppStates.About)
    }
}
