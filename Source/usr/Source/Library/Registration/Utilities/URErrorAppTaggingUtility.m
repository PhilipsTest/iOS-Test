//
//  URErrorAppTaggingUtility.m
//  Registration
//
//  Created by Abhishek on 01/02/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URErrorAppTaggingUtility.h"
#import "DIRegistrationConstants.h"
#import "URSettingsWrapper.h"
#import "RegistrationUIConstants.h"
#import "DILogger.h"

@implementation URErrorAppTaggingUtility

+ (void)trackAppMappedError:(NSError *)error serverErrorCode:(NSInteger)errorCode serverErrorMessage:(NSString *)errorMessage {
    switch (error.code) {
        case DIInvalidFieldsErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegInvalidInputFields];
            break;
        case DIInvalidCredentials:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegIncorrectEmailOrPassword];
            break;
        case DINotVerifiedEmailErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegEmailIsNotVerified];
            break;
        case DINotVerifiedMobileErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegMobileNoIsNotVerified];
            break;
        case DIEmailAddressAlreadyInUse:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegEmailAlreadyInUse];
            break;
        case DIMobileNumberAlreadyInUse:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegMobileNoAlreadyInUse];
            break;
        case DIMergeFlowErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kHandleMergingFailed];
            break;
        case DIRegNetworkSyncError:
            [self tagError:error errorCode:errorCode errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegServerTimeSyncError];
            break;
        case DIRegProviderNotSupported:
            [self tagError:error errorCode:errorCode errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegProviderNotSupported];
            break;
        case DIRegNoProviderErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegNoProviderChosen];
            break;
        case DISMSFailureErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegSMSIsNotVerified];
            break;
        case DIRegRecordNotFound:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegRecordNotFound];
            break;
        case DIUnexpectedErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegUnExpectedError];
            break;
        case DINetworkErrorCode:
            if (errorMessage == nil || [errorMessage isEqualToString:@""]) { errorMessage = LOCALIZE(@"USR_Generic_Network_ErrorMsg");}
            [self tagError:error errorCode:errorCode errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegCreateNetworkError];
            break;
        case DIRegWeChatAccountsError:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegWeChatNotInstalled];
            break;
        case DISessionExpiredErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegSessionExpired];
            break;
        case DIAcesssTokenIsNil:
            [self tagError:error errorCode:errorCode errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegAccessTokenNil];
            break;
        case DIRegAuthenticationError:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegSocialSignUpCancelled];
            break;
        case DIJanrainConnectionErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegJanrainConnectionError];
            break;
        case DIJanrainErrorInFlowErrorCode:
            [self tagError:error errorCode:errorCode errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegEmailAlreadyVerified];
            break;
        default:
            [self trackDefaultError:error errorType:kRegTechnicalError errorMessage:errorMessage];
            break;
    }
}
   
    
+ (void)trackURXAppServerError:(NSError *)error errorMessage:(NSString *)errorMessage {
    switch (error.code+URXSMSErrorGeneric) {
        case URXHTTPResponseCodeServerError:
            [self tagError:error errorCode:error.code errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegURXServerError];
            break;
        case URXHTTPResponseCodeInputValidationError:
            [self tagError:error errorCode:error.code errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegInputValidationError];
            break;
        case URXHTTPResponseCodeNotFoundError:
            [self tagError:error errorCode:error.code errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegCodeNotFound];
            break;
        case URXHTTPResponseCodeNotAuthorized:
            [self tagError:error errorCode:error.code errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegCodeNotAuthorized];
            break;
        case URXSMSErrorCodeInvalidNumber:
            [self tagError:error errorCode:error.code errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegInvalidPhoneNumber];
            break;
        case URXSMSErrorCodeNumberNotRegistered:
            [self tagError:error errorCode:error.code errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegInvalidPhoneNumber];
            break;
        case URXSMSErrorCodeUnAvailNumber:
            [self tagError:error errorCode:error.code errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegUnAvailPhoneNumber];
            break;
        case URXSMSErrorCodeUnSupportedCountry:
            [self tagError:error errorCode:error.code errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegUnSupportedCountry];
            break;
        case URXSMSErrorCodeLimitReached:
            [self tagError:error errorCode:error.code errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegLimitReached];
            break;
        case URXSMSErrorCodeInternalServerError:
            [self tagError:error errorCode:error.code errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegInternalServerError];
            break;
        case URXSMSErrorCodeNoInfo:
            [self tagError:error errorCode:error.code errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegCodeNoInfo];
            break;
        case URXSMSErrorCodeNotSent:
            [self tagError:error errorCode:error.code errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegCodeNotSent];
            break;
        case URXSMSErrorCodeAlreadyVerifed:
            [self tagError:error errorCode:error.code errorType:kRegUserError errorMessage:errorMessage errorCategory:kRegCodeAlreadyVerifed];
            break;
        case URXSMSErrorCodeFailureCode:
            [self tagError:error errorCode:error.code errorType:kRegTechnicalError errorMessage:errorMessage errorCategory:kRegFailureCode];
            break;
        default:
            [self trackDefaultError:error errorType:kRegUserError errorMessage:errorMessage];
            break;
    }
}

    
+ (void)trackDefaultError:(NSError *)error errorType:(NSString *)errorType errorMessage:(NSString *)errorMessage {
    [self tagError:error errorCode:error.code errorType:errorType errorMessage:errorMessage errorCategory:@"UnKnown"];
}


+ (void)tagError:(NSError *)error errorCode:(NSInteger)code errorType:(NSString *)errorType errorMessage:(NSString *)errorMessage errorCategory:(NSString *)errorCategory {
    NSString *technicalErrorString = [NSString stringWithFormat:@"UR:%@:%@:%ld:%@",errorCategory,error.domain,(long)code,errorMessage];
    DIRDebugLog(@"TrackAction : %@, %@:%@",kRegSendData,errorType,technicalErrorString);
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{errorType:technicalErrorString}];
}


+ (void)tagForcelogoutWithDomain:(NSString *)domain errorCode:(NSInteger)errorCode timeDifference:(NSInteger)difference wasNetworkTimeSynchronized:(BOOL)wasSynchronised {
    NSString *forceLogoutTag = [NSString stringWithFormat:@"UR:ForceLogout:%@:%ld:%ld:%d",domain, (long)errorCode, (long)difference, wasSynchronised];
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegTechnicalError:forceLogoutTag}];
}


+ (void)tagClearUserData:(NSInteger)errorCode errorMessage:(NSString *)errorMessage errorType:(NSString *)errorType {
    //format: UR:errorCategory:domain:errorCode:errorMessage
    NSString *clearUserDataTag = [NSString stringWithFormat:@"UR:ClearUserData:User:%ld:%@", (long)errorCode, errorMessage];
    DIRDebugLog(@"TrackAction : %@, %@:%@",kRegSendData,errorType,clearUserDataTag);
    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{errorType:clearUserDataTag}];
}

@end
