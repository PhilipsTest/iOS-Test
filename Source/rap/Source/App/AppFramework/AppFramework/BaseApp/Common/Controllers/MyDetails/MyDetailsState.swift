/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import Foundation
import UAPPFramework
import PhilipsRegistration

class MyDetailsState: BaseState {
    
    lazy var userRegistrationState = (Constants.APPDELEGATE?.getFlowManager().getState(AppStates.UserRegistration)) as? UserRegistrationState
    
    override init() {
        super.init(stateId : AppStates.MyDetails)
    }
    
    override func getViewController() -> UIViewController? {
        userRegistrationState?.userRegistrationLaunchInput?.registrationFlowConfiguration.loggedInScreen = .myDetails
        if let launchInput = userRegistrationState?.userRegistrationLaunchInput {
            if let urViewController = userRegistrationState?.userRegistrationInterface?.instantiateViewController(launchInput, withErrorHandler: { (error) in AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "MyDetails", message: "Unable to launch MyDetails screen from User-Registration")}) {
                return urViewController
            }
        }
        return nil
    }
}
