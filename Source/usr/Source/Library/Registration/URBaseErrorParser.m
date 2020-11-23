//
//  URBaseErrorParser.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "URBaseErrorParser.h"
#import "DIRegistrationConstants.h"
#import "DILogger.h"

@implementation URBaseErrorParser

+ (NSInteger)mapCommonErrorCode:(NSInteger)errorCode {
    NSInteger mappedError = 0;
    switch (errorCode) {
        case  -998:
        case  -999:
        case -1000:
        case -1001:
        case -1002:
        case -1003:
        case -1004:
        case -1005:
        case -1006:
        case -1007:
        case -1008:
        case -1009:
        case -1010:
        case -1011:
        case -1012:
        case -1013:
        case -1014:
        case -1015:
        case -1016:
        case -1017:
        case -1018:
        case -1019:
        case -1020:
        case -1021:
        case -1100:
        case -1101:
        case -1102:
        case -1103:
            mappedError = DINetworkErrorCode;
            break;
            
        default:
            mappedError = DIUnexpectedErrorCode;
            break;
    }
    return mappedError;
}

+ (NSError *)errorForErrorCode:(NSInteger)errorCode {
    NSError *mappedError;
    switch (errorCode) {
        case DIMergeFlowErrorCode:
            mappedError = [NSError errorWithDomain:@"Registration.JanrainError" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"Error While Mergeing the account"}];
            break;
        case DIRegNetworkSyncError:
            mappedError = [NSError errorWithDomain:@"AITimeProtocol" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"Network synchronize error"}];
            break;
        case DINotVerifiedMobileErrorCode:
            mappedError = [NSError errorWithDomain:@"MobileNumberNotVerified" code:errorCode userInfo:@{NSLocalizedDescriptionKey:LOCALIZE(@"USR_Janrain_Error_Need_Mobile_Verification")}];
            break;
        case DINotVerifiedEmailErrorCode:
            mappedError = [NSError errorWithDomain:@"EmailNotVerified" code:errorCode userInfo:@{NSLocalizedDescriptionKey:LOCALIZE(@"USR_Janrain_Error_Need_Email_Verification")}];
            break;
        case DISMSFailureErrorCode:
            mappedError = [NSError errorWithDomain:@"MobileVerificationError" code:errorCode userInfo:@{NSLocalizedDescriptionKey:LOCALIZE(@"USR_VerificationCode_ErrorText")}];
            break;
        case DIAcesssTokenIsNil:
            mappedError = [NSError errorWithDomain:@"AccessToken" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"Janrain access token is nil."}];
            break;
        case DIRegNoProviderErrorCode:
            mappedError = [NSError errorWithDomain:@"NoProviderChosen" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"No Provider Chosen"}];
            break;
        case DIRegAuthenticationError:
            mappedError = [NSError errorWithDomain:@"engageAuthenticationDidCancel" code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"Engage Authentication cancelled"}];
            break;
            
        default:
            mappedError = [NSError errorWithDomain:@"Missing Fields" code:errorCode userInfo:@{NSLocalizedDescriptionKey:LOCALIZE(@"USR_Generic_Network_ErrorMsg")}];
            break;
    }
    return mappedError;
}


+ (NSString *)getFormattedErrorLog:(NSError *)serverError andMappedError:(NSError *)mappedError {
    NSString *serverErrorFormat = [NSString stringWithFormat:@"errorCode:%ld, errorDomain:%@, userInfo:%@", (long)serverError.code, serverError.domain, [serverError.userInfo description]];
    NSString *mappedErrorFormat = [NSString stringWithFormat:@"errorCode:%ld, errorDomain:%@, userInfo:%@", (long)mappedError.code, mappedError.domain, [mappedError.userInfo description]];
    
    return [NSString stringWithFormat:@"serverErrorInfo:[%@], mappedErrorInfo:[%@]", serverErrorFormat, mappedErrorFormat];
}

+(NSError *)userNotLoggedInError {
    return [NSError errorWithDomain:UserDetailConstants.USER_ERROR_DOMAIN code:UserDetailErrorNotLoggedIn userInfo:@{NSLocalizedDescriptionKey:@"User Not Logged In", NSLocalizedFailureReasonErrorKey:@"User Not Logged In"}];
}

+ (NSError *)unsupportedConsentError {
    NSError *unsupportedError = [[NSError alloc] initWithDomain:@"URConsentErrorDomain" code:DIGDPRRegConsentError userInfo:@{NSLocalizedDescriptionKey: @"Unsupported Consent Key"}];
    DIRErrorLog(@"%@", [RegistrationUtility getURFormattedLogError:unsupportedError withDomain:@"URConsentErrorDomain"]);
    
    return unsupportedError;
}

+ (NSError *)userNotProvidedConsentError {
    NSError *unsupportedError = [[NSError alloc] initWithDomain:@"URConsentErrorDomain" code:DIGDPRRegConsentError userInfo:@{NSLocalizedDescriptionKey: @"User Consent Not stored"}];
    DIRErrorLog(@"%@", [RegistrationUtility getURFormattedLogError:unsupportedError withDomain:@"URConsentErrorDomain"]);
    
    return unsupportedError;
}

@end
