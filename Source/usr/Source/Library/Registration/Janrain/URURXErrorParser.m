//
//  URURXErrorParser.m
//  Registration
//
//  Created by Sai Pasumarthy on 10/10/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "URURXErrorParser.h"
#import "DIRegistrationConstants.h"
#import "DIConstants.h"
#import "URErrorAppTaggingUtility.h"

NSString *const URXErrorDomain = @"URX";

@implementation URURXErrorParser

+ (NSDictionary *)mappedErrorForURXResponseData:(NSData *)response statusCode:(NSInteger)statusCode serverError:(NSError *)serverError error:(NSError * __autoreleasing *)error {
    NSError *mappedError;
    if (serverError && ![serverError isKindOfClass:[NSNull class]]) {
        mappedError = [self errorForCommonErrorCode:[self mapCommonErrorCode:serverError.code]];
    } else {
        NSError *jsonError;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError) {
            mappedError = [self errorForErrorCode:DIInvalidFieldsErrorCode];
        } else if (jsonDictionary[@"errorCode"]) {
            if ([jsonDictionary[@"errorCode"] integerValue] == 0) {
                return jsonDictionary;
            } else {
                mappedError = [self mapURXSMSStatusCode:[jsonDictionary[@"errorCode"] integerValue]];
            }
        } else {
            mappedError = [self errorForCommonErrorCode:statusCode];
        }
    }
    *error = mappedError;
    [URErrorAppTaggingUtility trackURXAppServerError:mappedError errorMessage:serverError.userInfo[@"message"] ? serverError.userInfo[@"message"] : mappedError.userInfo[NSLocalizedDescriptionKey]];
    DIRErrorLog(@"%@", [self getFormattedErrorLog:serverError andMappedError:mappedError]);
    return nil;
}


+ (NSError *)errorForCommonErrorCode:(NSInteger)errorCode {
    NSString *errorMsg = [self localizedStringForCommonErrorCodes:errorCode];
    NSDictionary *mappedInfo = @{NSLocalizedDescriptionKey:errorMsg};
    return [NSError errorWithDomain:URXErrorDomain code:errorCode userInfo:mappedInfo];
}


+ (NSError *)mapURXSMSStatusCode:(NSInteger)errorCode {
    NSString *errorMsg = [self localizedStringForSMSStatusCodes:errorCode];
    NSDictionary *mappedInfo = @{NSLocalizedDescriptionKey:errorMsg};
    return [NSError errorWithDomain:URXErrorDomain code:errorCode userInfo:mappedInfo];
}


+ (NSString *)localizedStringForCommonErrorCodes:(NSInteger)errorCode {
    NSString *errorMsg = LOCALIZE(@"USR_Generic_Network_ErrorMsg");
    return errorMsg;
}


+ (NSString *)localizedStringForSMSStatusCodes:(NSInteger)errorCode {
    errorCode = (NSInteger)URXSMSErrorGeneric + errorCode;
    NSString *errorMsg = @"";
    switch (errorCode) {
        case URXSMSErrorCodeInvalidNumber:
            errorMsg = LOCALIZE(@"USR_URX_SMS_Invalid_PhoneNumber");
            break;
        case URXSMSErrorCodeNumberNotRegistered:
            errorMsg = LOCALIZE(@"USR_Phone_Number_Not_Found_Text");
            break;
        case URXSMSErrorCodeUnAvailNumber:
            errorMsg = LOCALIZE(@"URX_SMS_PhoneNumber_UnAvail_ForSMS");
            break;
        case URXSMSErrorCodeUnSupportedCountry:
            errorMsg = [NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_UnSupported_Country_ForSMS"), LOCALIZE(@"USR_URX_SMS_Invalid_PhoneNumber")];
            break;
        case URXSMSErrorCodeLimitReached:
            errorMsg = LOCALIZE(@"USR_URX_SMS_Limit_Reached");
            errorMsg = [NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_Limit_Reached"), DIURXSMSRetryTimeDuration];
            break;
        case URXSMSErrorCodeInternalServerError:
            errorMsg = [NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_InternalServerError"), LOCALIZE(@"USR_Error_PleaseTryLater_Txt")];
            break;
        case URXSMSErrorCodeNoInfo:
            errorMsg = [NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_NoInformation_Available"), LOCALIZE(@"USR_Error_PleaseTryLater_Txt")];
            break;
        case URXSMSErrorCodeNotSent:
            errorMsg = [NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_Not_Sent"), LOCALIZE(@"USR_Error_PleaseTryLater_Txt")];
            break;
        case URXSMSErrorCodeAlreadyVerifed:
            errorMsg = LOCALIZE(@"USR_URX_SMS_Already_Verified");
            break;
        case URXSMSErrorCodeFailureCode:
            errorMsg = LOCALIZE(@"USR_VerificationCode_ErrorText");
            break;
        default:
            errorMsg = LOCALIZE(@"USR_Generic_Network_ErrorMsg");
            break;
    }
    return errorMsg;
}
@end
