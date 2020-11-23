//
// URConsentProvider.m
// PhilipsRegistration
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URConsentProvider.h"
#import "DIConstants.h"
#import "RegistrationUIConstants.h"

@implementation URConsentProvider

+ (ConsentDefinition *)fetchMarketingConsentDefinition:(NSString * _Nonnull)locale {
    ConsentDefinition *consentDefinition = [[ConsentDefinition alloc] initWithType:kUSRMarketingConsentKey text:LOCALIZE(@"USR_DLS_OptIn_Promotional_Message_Line1") helpText:LOCALIZE(@"USR_DLS_PhilipsNews_Description_Text") version:0 locale:locale];
    return consentDefinition;
}

//Dummy consent definition
+ (ConsentDefinition *)fetchPersonalConsentDefinition {
    ConsentDefinition *consentDefinition = [[ConsentDefinition alloc] initWithType:kUSRMarketingConsentKey text:LOCALIZE(@"USR_DLS_UR_Data_Consent_Line") helpText:LOCALIZE(@"USR_DLS_UR_Data_Consent_Description") version:0 locale:@""];
    return consentDefinition;
}

+ (NSString *)personalConsentErrorMessage {
    return LOCALIZE(@"USR_DLS_UserDataConsentText_Error");
}


@end
