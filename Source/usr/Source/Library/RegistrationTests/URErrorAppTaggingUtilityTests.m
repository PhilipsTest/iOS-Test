//
//  DIErrorAppTaggingUtilityTests.m
//  Registration
//
//  Created by Sai Pasumarthy on 18/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URErrorAppTaggingUtility.h"
#import "DIRegistrationConstants.h"
#import "RegistrationUIConstants.h"
#import "URSettingsWrapper.h"
#import "Kiwi.h"

SPEC_BEGIN(DIErrorAppTaggingUtilitySpec)

describe(@"URErrorAppTaggingUtility", ^{
    
    context(@"method trackAppMappedError:serverErrorCode:serverErrorMessage:", ^{
        
        NSString *janrainErrorDomain = @"Janrain";
        NSString *urxErrorDomain = @"URX";
        id appTagging = [KWMock mockForProtocol:@protocol(AIAppTaggingProtocol)];
        
        beforeAll(^{
            URSettingsWrapper.sharedInstance.appTagging = appTagging;
        });

        it(@"should tag DIInvalidFieldsErrorCode when server error is Invalid input fields", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIInvalidFieldsErrorCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:200 serverErrorMessage:@"invalid_argument"];
        });
        
        it(@"should tag DIInvalidCredentials when server error is Username or password is wrong", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIInvalidCredentials userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:210 serverErrorMessage:@"invalid_credentials"];
        });

        it(@"should tag DINotVerifiedEmailErrorCode when server error is Email is not verified", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DINotVerifiedEmailErrorCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DINotVerifiedEmailErrorCode serverErrorMessage:@"email_is_not_verified"];
        });
        
        it(@"should tag DINotVerifiedMobileErrorCode when server error is Mobile is not verified", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DINotVerifiedMobileErrorCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DINotVerifiedMobileErrorCode serverErrorMessage:@"mobile_is_not_verified"];
        });
        
        it(@"should tag DIEmailAddressAlreadyInUse when server error is The email is already in use", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIEmailAddressAlreadyInUse userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:380 serverErrorMessage:@"email_address_in_use"];
        });
        
        it(@"should tag DIMobileNumberAlreadyInUse when server error is The Mobile is already in use", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIMobileNumberAlreadyInUse userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:390 serverErrorMessage:@"mobile_address_in_use"];
        });
        
        it(@"should tag DIMergeFlowErrorCode when server error is Handling Merge is failed", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIMergeFlowErrorCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DIMergeFlowErrorCode serverErrorMessage:@"handling_merge_is_failed"];
        });
        
        it(@"should tag DIRegNetworkSyncError when server error is Server time is not synced", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIRegNetworkSyncError userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DIRegNetworkSyncError serverErrorMessage:@"Server_time_is_not_synced"];
        });
        
        it(@"should tag DIRegProviderNotSupported when server error is Provider not supported", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIRegProviderNotSupported userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:106 serverErrorMessage:@"USR_Provider_Not_Supported"];
        });

        it(@"should tag DIRegNoProviderErrorCode when server error is No provider has been choosen", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIRegNoProviderErrorCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DIRegNoProviderErrorCode serverErrorMessage:@"No_provider_has_been_choosen"];
        });
        
        it(@"should tag DIRegRecordNotFound when server error is Record not found", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIRegRecordNotFound userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:310 serverErrorMessage:@"record_not_found"];
        });
        
        it(@"should tag DIUnexpectedErrorCode when server error is Unexpected error", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIUnexpectedErrorCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:500 serverErrorMessage:@"unexpected_error"];
        });
        
        it(@"should tag DINetworkErrorCode when server error is Network error", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DINetworkErrorCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:201 serverErrorMessage:@"error_connection_could_not_be_established"];
        });
        
        it(@"should tag DIRegWeChatAccountsError when server error is We chat not installed", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIRegWeChatAccountsError userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DIRegWeChatAccountsError serverErrorMessage:@"we_chat_not_installed"];
        });
        
        it(@"should tag DISessionExpiredErrorCode when server error is Session expired", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DISessionExpiredErrorCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DISessionExpiredErrorCode serverErrorMessage:@"session_expired"];
        });
        
        it(@"should tag DIAcesssTokenIsNil when server error is Access token nil", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIAcesssTokenIsNil userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DIAcesssTokenIsNil serverErrorMessage:@"access_token_nil"];
        });
        
        it(@"should tag DIRegAuthenticationError when authentication failed", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:DIRegAuthenticationError userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DIRegAuthenticationError serverErrorMessage:@"authentication_error"];
        });
        
        it(@"should tag DISMSFailureErrorCode when sms sending is failed", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:DISMSFailureErrorCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:DISMSFailureErrorCode serverErrorMessage:@"sms_sent_failed"];
        });
        
        it(@"should tag URXHTTPResponseCodeServerError when server error is URX server error", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXHTTPResponseCodeServerError userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXHTTPResponseCodeServerError serverErrorMessage:@"urx_server_error"];
        });
        
        it(@"should tag URXHTTPResponseCodeInputValidationError when server error is Input invalidation error", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXHTTPResponseCodeInputValidationError userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXHTTPResponseCodeInputValidationError serverErrorMessage:@"input_invalidation_error"];
        });
        
        it(@"should tag URXHTTPResponseCodeNotFoundError when server error is URX not found error", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXHTTPResponseCodeNotFoundError userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXHTTPResponseCodeNotFoundError serverErrorMessage:@"urx_not_found_error"];
        });
        
        it(@"should tag URXHTTPResponseCodeNotAuthorized when server error is URX not authorized", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXHTTPResponseCodeNotAuthorized userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXHTTPResponseCodeNotAuthorized serverErrorMessage:@"urx_not_authorized"];
        });
        
        it(@"should tag URXSMSErrorCodeInvalidNumber when server error is Invalid phone number provided", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeInvalidNumber userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeInvalidNumber serverErrorMessage:@"invalid_phone_number_provided"];
        });
        
        it(@"should tag URXSMSErrorCodeNumberNotRegistered when server error is phone number not registered", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeNumberNotRegistered userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeNumberNotRegistered serverErrorMessage:@"invalid_phone_number_provided"];
        });
        
        it(@"should tag URXSMSErrorCodeUnAvailNumber when server error is Phone number unavailable for SMS", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeUnAvailNumber userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeUnAvailNumber serverErrorMessage:@"phone_number_unavailable_for_sms"];
        });
        
        it(@"should tag URXSMSErrorCodeUnSupportedCountry when server error is Unsupported country for SMS services", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeUnSupportedCountry userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeUnSupportedCountry serverErrorMessage:@"unsupported_country_for_SMS_services"];
        });
        
        it(@"should tag URXSMSErrorCodeLimitReached when server error is SMS limit for phone number reached", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeLimitReached userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeLimitReached serverErrorMessage:@"sms_limit_for_phone_number_reached"];
        });
        
        it(@"should tag URXSMSErrorCodeInternalServerError when server error is Internal server error sending SMS", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeInternalServerError userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeInternalServerError serverErrorMessage:@"internal_server_error_sending_sms"];
        });
        
        it(@"should tag URXSMSErrorCodeNoInfo when server error is No information available", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeNoInfo userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeNoInfo serverErrorMessage:@"no_information_available"];
        });
        
        it(@"should tag URXSMSErrorCodeNotSent when server error is SMS not yet sent", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeNotSent userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeNotSent serverErrorMessage:@"sms_not_yet_sent"];
        });
        
        it(@"should tag URXSMSErrorCodeAlreadyVerifed when server error is SMS not sent. Account already verified", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeAlreadyVerifed userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeAlreadyVerifed serverErrorMessage:@"account_already_verified"];
        });
        
        it(@"should tag URXSMSErrorCodeFailureCode when server error is Mobile account failure case", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:urxErrorDomain code:URXSMSErrorCodeFailureCode userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:URXSMSErrorCodeFailureCode serverErrorMessage:@"mobile_account_failure_case"];
        });
        
        it(@"should tag UnKnown when server error is UnKnown error occured", ^{
            [[appTagging should] receive:@selector(trackActionWithInfo:params:)];
            NSError *serverError = [NSError errorWithDomain:janrainErrorDomain code:2678 userInfo:nil];
            [URErrorAppTaggingUtility trackAppMappedError:serverError serverErrorCode:2687 serverErrorMessage:@"unknown_error_occured"];
        });
    });
});
SPEC_END

