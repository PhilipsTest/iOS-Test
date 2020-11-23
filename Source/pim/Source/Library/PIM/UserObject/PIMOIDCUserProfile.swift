/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import Foundation
import PlatformInterfaces
import AppAuth
import AppInfra

class PIMOIDCUserProfile {    
    
    private var authState: OIDAuthState?
    public var userProfileResponse: PIMUserProfileResponse?
    lazy var userDataInterfaceDict = [String: AnyObject]()
    
    init(_ oidState:OIDAuthState?, userProfileJson: Data?) {
        authState = oidState
        do{
            if let jsonData = userProfileJson {
                userProfileResponse = try JSONDecoder().decode(PIMUserProfileResponse.self, from: jsonData)
                mapUserProfileToDataInterface()
                PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMOIDCUserProfile", message: "user details object present")
            }
        }catch{
            PIMUtilities.logMessage(AILogLevel.debug, eventId:"PIMOIDCUserProfile", message: "user details object not present \(error.localizedDescription)")
        }
    }
}

extension PIMOIDCUserProfile {
    
    func mapUserProfileToDataInterface() {
        userDataInterfaceDict[UserDetailConstants.GIVEN_NAME] = userProfileResponse?.given_name as AnyObject
        userDataInterfaceDict[UserDetailConstants.FAMILY_NAME] = userProfileResponse?.family_name as AnyObject
        userDataInterfaceDict[UserDetailConstants.EMAIL] = userProfileResponse?.email as AnyObject
        userDataInterfaceDict[UserDetailConstants.GENDER] = userProfileResponse?.gender as AnyObject
        userDataInterfaceDict[UserDetailConstants.BIRTHDAY] = userProfileResponse?.birthday as AnyObject
        userDataInterfaceDict[UserDetailConstants.MOBILE_NUMBER] = userProfileResponse?.phone_number as AnyObject
        userDataInterfaceDict[UserDetailConstants.ACCESS_TOKEN] = authState?.lastTokenResponse?.accessToken as AnyObject
        userDataInterfaceDict[UserDetailConstants.UUID] = userProfileResponse?.sub as AnyObject
        userDataInterfaceDict[UserDetailConstants.ID_TOKEN] = authState?.lastTokenResponse?.idToken as AnyObject
        userDataInterfaceDict[UserDetailConstants.TOKEN_TYPE] = authState?.lastTokenResponse?.tokenType as AnyObject
        userDataInterfaceDict[UserDetailConstants.ACCESS_TOKEN_EXPIRATION_TIME] = authState?.lastTokenResponse?.accessTokenExpirationDate as AnyObject
        userDataInterfaceDict[UserDetailConstants.RECEIVE_MARKETING_EMAIL] = userProfileResponse?.consent_email_marketing_opted_in as AnyObject
    }
    
     func mapUserDetails(_ fields: Array<String>) -> Dictionary<String, AnyObject> {
         var userDetailsDict = [String: AnyObject]()
         for fieldName in fields {
            let fieldValue =  userDataInterfaceDict[fieldName]
            if (!(fieldValue is NSNull)) {
                userDetailsDict[fieldName] = fieldValue;
            }
         }
         return userDetailsDict
    }

}
