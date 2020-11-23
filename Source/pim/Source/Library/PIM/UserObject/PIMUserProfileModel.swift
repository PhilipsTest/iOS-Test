/*
* Copyright (c) Koninklijke Philips N.V., 2018
* All rights are reserved. Reproduction or dissemination
* in whole or in part is prohibited without the prior written
* consent of the copyright holder.
*/

import AppAuth

struct PIMUserProfileResponse: Codable {
    var given_name: String?
    var family_name: String?
    var email: String?
    var gender: String?
    var phone_number: String?
    var birthday: String?
    var email_verified: Bool?
    var phone_number_verified: Bool?
    var address: Dictionary<String, String>?
    var sub: String?
    var consent_email_marketing_opted_in: Bool?
    
    enum CodingKeys: String, CodingKey {
        case given_name = "given_name"
        case family_name = "family_name"
        case email = "email"
        case gender = "gender"
        case phone_number = "phone_number"
        case birthday = "birthday"
        case email_verified = "email_verified"
        case phone_number_verified = "phone_number_verified"
        case address = "address"
        case sub = "sub"
        case consent_email_marketing_opted_in = "consent_email_marketing.opted_in"
    }
}
