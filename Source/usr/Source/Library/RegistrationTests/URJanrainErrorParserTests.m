//
//  JanrainErrorParserTests.m
//  Registration
//
//  Created by Sai Pasumarthy on 22/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "Kiwi.h"
#import "URJanrainErrorParser.h"
#import "DIRegistrationConstants.h"
#import "JRCaptureError.h"
#import "JREngageError.h"

SPEC_BEGIN(JanrainErrorParserSpec)

describe(@"URJanrainErrorParser", ^{
    
    context(@"method mappedErrorForJanrainError:", ^{
        
        NSString *janrainErrorDomain = @"Janrain";
        
        it(@"should return DIInvalidFieldsErrorCode when server error is JRCaptureApidErrorMissingArgument", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorMissingArgument userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIInvalidFieldsErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIInvalidFieldsErrorCode when server error is JRCaptureApidErrorInvalidArgument", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorInvalidArgument userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIInvalidFieldsErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIInvalidFieldsErrorCode when server error is JRCaptureApidErrorDuplicateArgument", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorDuplicateArgument userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIInvalidFieldsErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIInvalidFieldsErrorCode when server error is JRCaptureApidErrorInvalidAuthMethod", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorInvalidAuthMethod userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIInvalidFieldsErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorMissingRequiredAttribute", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorMissingRequiredAttribute userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });

        it(@"should return DIInvalidFieldsErrorCode when server error is JRCaptureLocalApidErrorInvalidArgument", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureLocalApidErrorInvalidArgument userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIInvalidFieldsErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });

        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorUnknownApplication", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorUnknownApplication userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorUnknownEntityType", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorUnknownEntityType userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorUnknownAttribute", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorUnknownAttribute userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIEmailOrMobileNumberAlreadyInUse when server error is JRCaptureApidErrorEntityTypeExists", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorEntityTypeExists userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIEmailOrMobileNumberAlreadyInUse)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Email_Phone_Label_Text"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorAttributeExists", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorAttributeExists userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorRecordNotFound", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorRecordNotFound userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorIdInNewRecord", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorIdInNewRecord userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorTimestampMismatch", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorTimestampMismatch userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorInvalidDataFormat", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorInvalidDataFormat userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorInvalidJsonType", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorInvalidJsonType userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorConstraintViolation", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorConstraintViolation userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorUniqueViolation", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorUniqueViolation userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorInvalidClientCredentials", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorInvalidClientCredentials userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorClientPermissionError", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorClientPermissionError userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainConnectionErrorCode when server error is JRCaptureApidErrorRedirectUriMismatch", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorRedirectUriMismatch userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainConnectionErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIJanrainInvalidDateTimeErrorCode when server error is JRCaptureApidErrorInvalidDateTime", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorInvalidDateTime userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainInvalidDateTimeErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_Janrain_HSDP_ServerErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIHTTPInputValidationErrorCode when server error is JRCaptureApidErrorLengthViolation", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorLengthViolation userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIHTTPInputValidationErrorCode)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_MaxiumCharacters_ErrorMsg")];
        });
        
        it(@"should return DIJanrainCodeExpiredErrorCode when server error is JRCaptureApidErrorAuthorizationCodeExpired", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorAuthorizationCodeExpired userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainCodeExpiredErrorCode)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_Error")];
        });
        
        it(@"should return DIJanrainCodeExpiredErrorCode when server error is JRCaptureApidErrorVerificationCodeExpired", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorVerificationCodeExpired userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainCodeExpiredErrorCode)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Janrain_VerificationCodeExpired_ErrorMsg")];
        });
        
        it(@"should return DIJanrainTokenExpiredErrorCode when server error is JRCaptureApidErrorCreationTokenExpired", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorCreationTokenExpired userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainTokenExpiredErrorCode)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_Error")];
        });
        
        it(@"should return DIJanrainApiLimitErrorCode when server error is JRCaptureApidErrorApiLimitError", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorApiLimitError userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainApiLimitErrorCode)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Janrain_LimitError_ErrorMsg")];
        });

        it(@"should return DIEmailAddressAlreadyInUse when server error is JRCaptureApidErrorFormValidation and userinfo doesn't contain mobileNumberRegistration", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorFormValidation userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIEmailAddressAlreadyInUse)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_Janrain_EntityAlreadyExists_ErrorMsg"), LOCALIZE(@"USR_DLS_Email_Label_Text"), serverError.code]];
        });
        
        it(@"should return DIMobileNumberAlreadyInUse when server error is JRCaptureApidErrorFormValidation and userinfo does contain mobileNumberRegistration", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorFormValidation userInfo:@{@"invalid_fields":@{@"mobileNumberRegistration":@"The mobile already in use"}}];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIMobileNumberAlreadyInUse)];
            [[mappedError.localizedDescription should] equal:@"The mobile already in use"];
        });
        
        it(@"should return DIEmailAddressAlreadyInUse when server error is JRCaptureApidErrorEmailAddressInUse", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorEmailAddressInUse userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIEmailAddressAlreadyInUse)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Janrain_EmailAddressInUse_ErrorMsg")];
        });

        it(@"should return DIInvalidCredentials when server error is JRCaptureErrorGenericBadPassword", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureErrorGenericBadPassword userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIInvalidCredentials)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Janrain_Invalid_Credentials")];
        });

        it(@"should return DISessionExpiredErrorCode when server error is JRCaptureApidErrorAccessTokenExpired", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorAccessTokenExpired userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DISessionExpiredErrorCode)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return DIUnexpectedErrorCode when server error is JRCaptureApidErrorUnexpectedError", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorUnexpectedError userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIUnexpectedErrorCode)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_UnexpectedInternalError_ErrorMsg")];
        });
        
        it(@"should return DIJanrainApiFeatureDisabledErrorCode when server error is JRCaptureApidErrorApiFeatureDisabled and userinfo doesn't contain mobileNumberRegistration", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorApiFeatureDisabled userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIJanrainApiFeatureDisabledErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_Janrain_HSDP_ServerErrorMsg"), serverError.code]];
        });
        
        it(@"should return DINetworkErrorCode when server error is JRCaptureLocalApidErrorUrlConnection", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureLocalApidErrorUrlConnection userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DINetworkErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });

        it(@"should return DINetworkErrorCode when server error is JRCaptureLocalApidErrorConnectionDidFail", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureLocalApidErrorConnectionDidFail userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DINetworkErrorCode)];
            [[mappedError.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_JanRain_Server_ConnectionLost_ErrorMsg"), serverError.code]];
        });
        
        it(@"should return DIRegWeChatAccountsError when server error is JRAuthenticationNoAccessToWeChatAccountsError", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRAuthenticationNoAccessToWeChatAccountsError userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIRegWeChatAccountsError)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return DIRegProviderNotSupported when server error is JRProviderNotConfiguredError", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRProviderNotConfiguredError userInfo:nil];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIRegProviderNotSupported)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Janrain error description if server error userinfo contains message", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorMissingArgument userInfo:@{@"message":@"This is janrain error message"}];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[mappedError.localizedDescription should] equal:@"This is janrain error message"];
        });

        it(@"should return Janrain error description if server error userinfo contains message", ^{
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:JRCaptureApidErrorRecordNotFound userInfo:@{@"message":@"No account with this email"}];
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:serverError];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[mappedError.localizedDescription should] equal:@"No account with this email"];
        });

        it(@"should return default error i.e, DIUnexpectedErrorCode if server error is nil", ^{
            NSError *mappedError = [URJanrainErrorParser mappedErrorForJanrainError:nil];
            [[mappedError shouldNot] beNil];
            [[mappedError.localizedDescription shouldNot] beNil];
            [[theValue(mappedError.code) should] equal:theValue(DIUnexpectedErrorCode)];
            [[mappedError.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

    });
    
});

SPEC_END
