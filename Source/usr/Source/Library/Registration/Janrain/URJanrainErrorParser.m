//
//  URJanrainErrorParser.m
//  Registration
//
//  Created by Sai Pasumarthy on 12/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URJanrainErrorParser.h"
#import "JRCaptureError.h"
#import "JREngageError.h"
#import "DIRegistrationConstants.h"
#import "RegistrationUIConstants.h"
#import "URErrorAppTaggingUtility.h"
#define JRCaptureApidErrorInvalidAuthorizationCode  3413
#define JRCaptureApidErrorInFlow                    3540

NSString *const JanrainErrorDomain = @"Janrain";

@implementation URJanrainErrorParser

+ (NSError *)mappedErrorForJanrainError:(NSError *)error {
    NSString *mappedLocalizedString;
    NSInteger mappedErrorCode = 0;
    
    switch (error.code) {
        case JRCaptureApidErrorMissingArgument:
        case JRCaptureApidErrorInvalidArgument:
        case JRCaptureApidErrorDuplicateArgument:
        case JRCaptureApidErrorInvalidAuthMethod:
        case JRCaptureLocalApidErrorInvalidArgument:
            mappedErrorCode = DIInvalidFieldsErrorCode;
            mappedLocalizedString = [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code];
            break;
        case JRCaptureErrorGenericBadPassword:
            mappedErrorCode = DIInvalidCredentials;
            mappedLocalizedString = LOCALIZE(@"USR_Janrain_Invalid_Credentials");
            break;
        case JRCaptureApidErrorUnknownApplication:
        case JRCaptureApidErrorUnknownEntityType:
        case JRCaptureApidErrorUnknownAttribute:
        case JRCaptureApidErrorAttributeExists:
        case JRCaptureApidErrorReservedAttribute:
        case JRCaptureApidErrorRecordNotFound:
        case JRCaptureApidErrorIdInNewRecord:
        case JRCaptureApidErrorTimestampMismatch:
        case JRCaptureApidErrorInvalidDataFormat:
        case JRCaptureApidErrorInvalidJsonType:
        case JRCaptureApidErrorConstraintViolation:
        case JRCaptureApidErrorUniqueViolation:
        case JRCaptureApidErrorMissingRequiredAttribute:
        case JRCaptureApidErrorInvalidClientCredentials:
        case JRCaptureApidErrorClientPermissionError:
        case JRCaptureApidErrorRedirectUriMismatch:
        case JRCaptureApidErrorInvalidAuthorizationCode:
            mappedErrorCode = DIJanrainConnectionErrorCode;
            mappedLocalizedString = [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code];
            break;
        case JRCaptureApidErrorEntityTypeExists:
            mappedErrorCode = DIEmailOrMobileNumberAlreadyInUse;
            mappedLocalizedString = [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Email_Phone_Label_Text"), error.code];
            break;
        case JRCaptureApidErrorInvalidDateTime:
            mappedErrorCode = DIJanrainInvalidDateTimeErrorCode;
            mappedLocalizedString = [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_HSDP_ServerErrorMsg"), error.code];
            break;
        case JRCaptureApidErrorLengthViolation:
            mappedErrorCode = DIHTTPInputValidationErrorCode;
            mappedLocalizedString = LOCALIZE(@"USR_MaxiumCharacters_ErrorMsg");
            break;
        case JRCaptureApidErrorEmailAddressInUse:
            mappedErrorCode = DIEmailAddressAlreadyInUse;
            mappedLocalizedString = LOCALIZE(@"USR_Janrain_EmailAddressInUse_ErrorMsg");
            break;
        case JRCaptureApidErrorFormValidation:
            mappedErrorCode = error.userInfo[@"invalid_fields"][@"mobileNumberRegistration"] ? DIMobileNumberAlreadyInUse : DIEmailAddressAlreadyInUse;
            mappedLocalizedString = mappedErrorCode == DIMobileNumberAlreadyInUse ? [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Phonenumber_Label_Text"), error.code] : [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Email_Label_Text"), error.code];
            break;
        case JRCaptureApidErrorAuthorizationCodeExpired:
            mappedErrorCode = DIJanrainCodeExpiredErrorCode;
            mappedLocalizedString = LOCALIZE(@"USR_Generic_Network_Error");
            break;
        case JRCaptureApidErrorVerificationCodeExpired:
            mappedErrorCode = DIJanrainCodeExpiredErrorCode;
            mappedLocalizedString = LOCALIZE(@"USR_Janrain_VerificationCodeExpired_ErrorMsg");
            break;
        case JRCaptureApidErrorCreationTokenExpired:
            mappedErrorCode = DIJanrainTokenExpiredErrorCode;
            mappedLocalizedString = LOCALIZE(@"USR_Generic_Network_Error");
            break;
        case JRCaptureApidErrorApiLimitError:
            mappedErrorCode = DIJanrainApiLimitErrorCode;
            mappedLocalizedString = LOCALIZE(@"USR_Janrain_LimitError_ErrorMsg");
            break;
        case JRCaptureApidErrorInFlow:
            mappedErrorCode = DIJanrainErrorInFlowErrorCode;
            mappedLocalizedString = [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code];
            break;
        case JRCaptureApidErrorUnexpectedError:
            mappedErrorCode = DIUnexpectedErrorCode;
            mappedLocalizedString = LOCALIZE(@"USR_UnexpectedInternalError_ErrorMsg");
            break;
        case JRCaptureLocalApidErrorUrlConnection:
        case JRCaptureLocalApidErrorConnectionDidFail:
            mappedErrorCode = DINetworkErrorCode;
            mappedLocalizedString = [NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), error.code];
            break;
        case JRProviderNotConfiguredError:
            mappedErrorCode = DIRegProviderNotSupported;
            mappedLocalizedString = LOCALIZE(@"USR_Generic_Network_ErrorMsg");
            break;
        case JRCaptureApidErrorAccessTokenExpired:
            mappedErrorCode = DISessionExpiredErrorCode;
            mappedLocalizedString = LOCALIZE(@"USR_Generic_Network_ErrorMsg");
            break;
        case JRAuthenticationNoAccessToWeChatAccountsError:
            mappedErrorCode = DIRegWeChatAccountsError;
            mappedLocalizedString = LOCALIZE(@"USR_Generic_Network_ErrorMsg");
            break;
        case JRCaptureApidErrorApiFeatureDisabled:
            mappedErrorCode = DIJanrainApiFeatureDisabledErrorCode;
            mappedLocalizedString = [NSString stringWithFormat:LOCALIZE(@"USR_Janrain_HSDP_ServerErrorMsg"), error.code];
            break;
        default:
            mappedErrorCode = [self mapCommonErrorCode:error.code];
            mappedLocalizedString = LOCALIZE(@"USR_Generic_Network_ErrorMsg");
            break;
    }
    
    NSString *janrainErrorString = [self mapJanrainUserInformation:error.userInfo];
    janrainErrorString = [self overrideJanrainErrorMessage:janrainErrorString errorCode:mappedErrorCode];
    NSString *errorString = (janrainErrorString.length == 0) ? mappedLocalizedString : janrainErrorString;
    NSDictionary *mappedInfo = @{NSLocalizedDescriptionKey:errorString};
    NSError *mappedError = [NSError errorWithDomain:JanrainErrorDomain code:mappedErrorCode userInfo:mappedInfo];
    [URErrorAppTaggingUtility trackAppMappedError:mappedError serverErrorCode:error.code serverErrorMessage:error.userInfo[@"error"] ? error.userInfo[@"error"] : @""];
    DIRErrorLog(@"%@", [self getFormattedErrorLog:error andMappedError:mappedError]);
    return mappedError;
}


+ (NSString *)overrideJanrainErrorMessage:(NSString *)janrainErrorMessage errorCode:(NSInteger)errorCode {
    NSString *locailzedString;
    switch (errorCode) {
        case DIInvalidCredentials:
            locailzedString = LOCALIZE(@"USR_Janrain_Invalid_Credentials");
            break;
            
        default:
            locailzedString = janrainErrorMessage;
            break;
    }
    return locailzedString;
}


+ (NSString *)mapJanrainUserInformation:(NSDictionary *)userInfo {
    NSDictionary *invalidFieldsDictionary = [userInfo objectForKey:@"invalid_fields"];
    NSMutableString *errorMessage = [[NSMutableString alloc] init];
    if (userInfo[@"message"]) {
        [errorMessage appendFormat:@"%@\n",userInfo[@"message"]];
    }
    if (errorMessage.length == 0) {
        for (NSString *keyString in [invalidFieldsDictionary allKeys]) {
            id valueObject = [invalidFieldsDictionary valueForKey:keyString];
            if ([valueObject isKindOfClass:[NSArray class]]) {
                [errorMessage appendFormat:@"%@\n",[valueObject componentsJoinedByString:@"%@\n"]];
            } else if ([valueObject isKindOfClass:[NSString class]]) {
                [errorMessage appendFormat:@"%@\n",valueObject];
            } else {
                errorMessage = nil;
            }
        }
    }
    return [errorMessage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
