//
//  URGoogleLoginHandlerTests.m
//  RegistrationTests
//
//  Created by Adarsh Kumar Rai on 21/05/18.
//  Copyright © 2018 Philips. All rights reserved.
//

@import SafariServices;
#import <XCTest/XCTest.h>
#import "URGoogleLoginHandler.h"
#import "DIHTTPUtility.h"
#import "Kiwi.h"

#define client_id       @"346000571262-r3n50oucoenomggrfjvhdpfvm95kdl5q.apps.googleusercontent.com"
#define redirectURL     @"com.googleusercontent.apps.346000571262-r3n50oucoenomggrfjvhdpfvm95kdl5q:/oauthredirect"

SPEC_BEGIN(URGoogleLoginHandlerSPec)

describe(@"URGoogleLoginHandler", ^{
    context(@"when Safari returns a differen URL", ^{
        it(@"should return false", ^{
            URGoogleLoginHandler *handler = [[URGoogleLoginHandler alloc] initWithClientId:client_id redirectURI:redirectURL];
            NSURL *url = [NSURL URLWithString:@"www.google.com"];
            [[theValue([handler application:[UIApplication sharedApplication] openURL:url options:nil]) should] beFalse];
        });
    });
    
    context(@"when requested for login", ^{
        it(@"should launch safari controller", ^{
            URGoogleLoginHandler *handler = [[URGoogleLoginHandler alloc] initWithClientId:client_id redirectURI:redirectURL];
            UIViewController *controller = [KWMock mockForClass:[UIViewController class]];
            [[controller should] receive:@selector(presentViewController:animated:completion:)];
            [controller stub:@selector(presentViewController:animated:completion:) withBlock:^id(NSArray *params) {
                [[params[0] should] beKindOfClass:[SFSafariViewController class]];
                SFSafariViewController *safari = params[0];
                [[safari.preferredBarTintColor should] equal:[UINavigationBar appearance].barTintColor];
                [[safari.preferredControlTintColor should] equal:[UINavigationBar appearance].tintColor];
                return nil;
            }];
            [handler startGoogleLoginFrom:controller completion:^(NSString * _Nullable token, NSString * _Nullable email, NSError * _Nullable error) {}];
        });
    });
    
    context(@"when safari session returns error", ^{
        it(@"should return error in completion", ^{
            URGoogleLoginHandler *handler = [[URGoogleLoginHandler alloc] initWithClientId:client_id redirectURI:redirectURL];
            UIViewController *controller = [KWMock mockForClass:[UIViewController class]];
            [[controller should] receive:@selector(presentViewController:animated:completion:)];
            [handler startGoogleLoginFrom:controller completion:^(NSString * _Nullable token, NSString * _Nullable email, NSError * _Nullable error) {
                [[token should] beNil];
                [[email should] beNil];
                [[error shouldNot] beNil];
            }];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?error=cancelled&error_description=user_cancelled_operation&error_code=320", redirectURL]];
            [handler application:[UIApplication sharedApplication] openURL:url options:nil];
        });
    });
    
    context(@"when safari session returns auth code but token conversion returns error", ^{
        it(@"should return error with no token or email", ^{
            URGoogleLoginHandler *handler = [[URGoogleLoginHandler alloc] initWithClientId:client_id redirectURI:redirectURL];
            UIViewController *controller = [KWMock mockForClass:[UIViewController class]];
            [[controller should] receive:@selector(presentViewController:animated:completion:)];
            DIHTTPUtility *utility = [KWMock mockForClass:[DIHTTPUtility class]];
            [[utility should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            [utility stub:@selector(startURLConnectionWithRequest:completionHandler:) withBlock:^id(NSArray *params) {
                DIHTTPConnectionCompletionHandler completion = params[1];
                completion(nil, nil, [NSError errorWithDomain:@"NSURLErrorDomain" code:1005 userInfo:nil]);
                return nil;
            }];
            [handler setValue:utility forKey:@"httpUtility"];
            __block NSError *conversionError = nil;
            [handler startGoogleLoginFrom:controller completion:^(NSString * _Nullable token, NSString * _Nullable email, NSError * _Nullable error) {
                [[token should] beNil];
                [[email should] beNil];
                [[error shouldNot] beNil];
                conversionError = error;
            }];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?code=98yrhfn2938t7h2", redirectURL]];
            [handler application:[UIApplication sharedApplication] openURL:url options:nil];
            [[conversionError shouldNotEventuallyBeforeTimingOutAfter(1.0)] beNil];
        });
    });
    
    context(@"when safari session returns auth code and token conversion returns success", ^{
        it(@"should return valid token and email and no error", ^{
            URGoogleLoginHandler *handler = [[URGoogleLoginHandler alloc] initWithClientId:client_id redirectURI:redirectURL];
            UIViewController *controller = [KWMock mockForClass:[UIViewController class]];
            [[controller should] receive:@selector(presentViewController:animated:completion:)];
            DIHTTPUtility *utility = [KWMock mockForClass:[DIHTTPUtility class]];
            [[utility should] receive:@selector(startURLConnectionWithRequest:completionHandler:)];
            [utility stub:@selector(startURLConnectionWithRequest:completionHandler:) withBlock:^id(NSArray *params) {
                DIHTTPConnectionCompletionHandler completion = params[1];
                NSString *idToken = @"eyJhbGciOiJSUzI1NiIsImtpZCI6ImE3NDhlOWY3NjcxNTlmNjY3YTAyMjMzMThkZTBiMjMyOWU1NDQzNjIifQ.eyJhenAiOiIzNDYwMDA1NzEyNjItcjNuNTBvdWNvZW5vbWdncmZqdmhkcGZ2bTk1a2RsNXEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIzNDYwMDA1NzEyNjItcjNuNTBvdWNvZW5vbWdncmZqdmhkcGZ2bTk1a2RsNXEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDMyNDc1NzI5MDY0Mzg3MTMwMTkiLCJlbWFpbCI6ImFkcmFpNzVAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJLdlBkWmtpb1JiM2NIYVFBQkthdEN3IiwiZXhwIjoxNTI2MzcwNDQzLCJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJpYXQiOjE1MjYzNjY4NDMsIm5hbWUiOiJBRCBSQUkiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDYuZ29vZ2xldXNlcmNvbnRlbnQuY29tLy0wemFJQlZ3Y29aWS9BQUFBQUFBQUFBSS9BQUFBQUFBQUFBQS9BSWNmZFhDYmFDZXp5Q3JNNjB1WTIxZmk1OTd5bF8taG93L3M5Ni1jL3Bob3RvLmpwZyIsImdpdmVuX25hbWUiOiJBRCIsImZhbWlseV9uYW1lIjoiUkFJIiwibG9jYWxlIjoiZW4ifQ.mKN0e7v0QBNRb2PZgXiwU_--NgOwxOO-fh3Qs6863RmaEra9_32XfkDJoeTW4nxYf3DsIkPCIroQip-2j8meRMbFaOryAhwPrj8a5bs4vihlxQ691pyt-AXeopr0b7VjMwTXLLGATkt3CBosSw9gF849acP0wYzGQ318wu9yU0CB8ufE4BeMUS__G1r5N3jckVW3pyxuixvs-FYRO-zNOw6wT7KPVtsfSEs-p16WQAiEQIOW6Xg8-qOJqe4K2voN3dGo3p5mFJB781LfFQdMUWULTUa2wIiWTh6qC3Bw9CFBxXdcALq8aFOu1oe39qjjBMsL2Q2Bz3I3I8gV3hranQ";
                NSDictionary *response = @{@"access_token": @"safihuqr98972r3uhefj",
                                           @"expires_in": @"3600",
                                           @"id_token": idToken
                                           };
                completion(nil, [NSJSONSerialization dataWithJSONObject:response options:kNilOptions error:nil], nil);
                return nil;
            }];
            [handler setValue:utility forKey:@"httpUtility"];
            __block NSError *conversionError = nil;
            [handler startGoogleLoginFrom:controller completion:^(NSString * _Nullable token, NSString * _Nullable email, NSError * _Nullable error) {
                [[token shouldNot] beNil];
                [[email shouldNot] beNil];
                [[error should] beNil];
                conversionError = error;
            }];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?code=98yrhfn2938t7h2", redirectURL]];
            [handler application:[UIApplication sharedApplication] openURL:url options:nil];
            [[conversionError shouldEventuallyBeforeTimingOutAfter(1.0)] beNil];
        });
    });
});

SPEC_END
