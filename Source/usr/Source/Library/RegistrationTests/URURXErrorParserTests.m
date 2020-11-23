//
//  URXErrorParserTests.m
//  Registration
//
//  Created by Sai Pasumarthy on 08/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URURXErrorParser.h"
#import "DIRegistrationConstants.h"
#import "RegistrationUIConstants.h"
#import "DIConstants.h"
#import "Kiwi.h"

SPEC_BEGIN(URXErrorParserSpec)

describe(@"URURXErrorParser", ^{
    
    context(@"method mappedErrorForURXResponseData:", ^{
        
        __block NSError *error;
        __block NSError *serverError;
        __block NSDictionary *jsonDictionary;
        __block NSData *expectData;
        
        beforeEach(^{
            error = nil;
            serverError = nil;
            expectData = nil;
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-998 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-999 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1000 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1001 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1002 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1003 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1004 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1005 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1006 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1007 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1008 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1009 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1010 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1011 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1012 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1013 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1014 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1015 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1016 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1017 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1018 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1019 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1020 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1021 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1100 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1101 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1102 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });
        
        it(@"should return Generic Network Error when server error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:-1103 userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(7)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return Default UnExpected Error when unknown error occurs with data nil", ^{
            serverError = [NSError errorWithDomain:@"Registration.URX" code:DIUnexpectedErrorCode userInfo:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:nil statusCode:URXHTTPResponseCodeServerError serverError:serverError error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(5)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });

        it(@"should return URXSMSErrorCodeInvalidNumber Error when data exists with error code 10", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(10)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(10)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_URX_SMS_Invalid_PhoneNumber")];
        });
        
        it(@"should return URXSMSErrorCodeNumberNotRegistered Error when data exists with error code 15", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(15)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(15)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Phone_Number_Not_Found_Text")];
        });

        it(@"should return URXSMSErrorCodeUnAvailNumber Error when data exists with error code 20", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(20)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(20)];
            [[error.localizedDescription should] equal:LOCALIZE(@"URX_SMS_PhoneNumber_UnAvail_ForSMS")];
        });

        it(@"should return URXSMSErrorCodeUnSupportedCountry Error when data exists with error code 30", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(30)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(30)];
            [[error.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_UnSupported_Country_ForSMS"), LOCALIZE(@"USR_URX_SMS_Invalid_PhoneNumber")]];
        });

        it(@"should return URXSMSErrorCodeLimitReached Error when data exists with error code 40", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(40)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(40)];
            [[error.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_Limit_Reached"), DIURXSMSRetryTimeDuration]];
        });

        it(@"should return URXSMSErrorCodeInternalServerError Error when data exists with error code 50", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(50)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(50)];
            [[error.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_InternalServerError"), LOCALIZE(@"USR_Error_PleaseTryLater_Txt")]];
        });

        it(@"should return URXSMSErrorCodeNoInfo Error when data exists with error code 60", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(60)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(60)];
            [[error.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_NoInformation_Available"), LOCALIZE(@"USR_Error_PleaseTryLater_Txt")]];
        });

        it(@"should return URXSMSErrorCodeNotSent Error when data exists with error code 70", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(70)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(70)];
            [[error.localizedDescription should] equal:[NSString stringWithFormat:LOCALIZE(@"USR_URX_SMS_Not_Sent"), LOCALIZE(@"USR_Error_PleaseTryLater_Txt")]];
        });

        it(@"should return URXSMSErrorCodeAlreadyVerifed Error when data exists with error code 90", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(90)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(90)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_URX_SMS_Already_Verified")];
        });

        it(@"should return URXSMSErrorCodeFailureCode Error when data exists with error code 3200", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @(3200)};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(3200)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_VerificationCode_ErrorText")];
        });

        it(@"should return Generic Network Error when data exists with unknown error code", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @131};
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error shouldNot] beNil];
            [[error.localizedDescription shouldNot] beNil];
            [[jsonDictionary should] beNil];
            [[theValue(error.code) should] equal:theValue(131)];
            [[error.localizedDescription should] equal:LOCALIZE(@"USR_Generic_Network_ErrorMsg")];
        });


        it(@"should return JSON data when data exists with error code 0", ^{
            NSDictionary *expectedObject = @{@"stat"  : @"ok",
                                             @"errorCode" : @0};
            NSError *error;
            expectData = [NSJSONSerialization dataWithJSONObject:expectedObject options:kNilOptions error:nil];
            NSDictionary *jsonDictionary = [URURXErrorParser mappedErrorForURXResponseData:expectData statusCode:200 serverError:nil error:&error];
            [[error should] beNil];
            [[error.localizedDescription should] beNil];
            [[jsonDictionary shouldNot] beNil];
            [[theValue([jsonDictionary[@"errorCode"] integerValue]) should] equal:theValue(0)];
        });

    });
    
});

SPEC_END
