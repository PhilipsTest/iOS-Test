/* Copyright (c) Koninklijke Philips N.V., 2020
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import UAPPFramework

@objcMembers open class CCBLaunchInput: UAPPLaunchInput {
    /*
     * A chat icon image which resides on left of the screen which indicates Philips/proposition
     */
    @objc open var leftChatIcon:UIImage?
}
