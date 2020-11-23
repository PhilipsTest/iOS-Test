//
//  DIHTTPUtility.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 26/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DIHTTPUtility.h"
#import "Kiwi.h"
#import "URSettingsWrapper.h"

SPEC_BEGIN(DIHTTPUtilitySpec)

describe(@"DIHTTPUtility", ^{
    
    __block DIHTTPUtility *httpUtility = [[DIHTTPUtility alloc] init];
    
    it(@"should not be nil when new object is created", ^{
        [[httpUtility shouldNot] beNil];
    });
    
    context(@"instance method startURLConnectionWithRequest:completionHandler:", ^{
        
        it(@"should return failure if no request object is supplied.", ^{
            [httpUtility startURLConnectionWithRequest:nil completionHandler:^(id response, NSData *data, NSError *error) {
                [[error shouldNot] beNil];
                [[response should] beNil];
                [[data should] beNil];
            }];
        });
        
        it(@"should not return error if server returns correct response", ^{
            
            NSURLRequest *dummyRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"SomeString"]];
            id restMock = [KWMock mockForProtocol:@protocol(AIRESTClientProtocol)];
            id restNew = URSettingsWrapper.sharedInstance.restClient;
            [restMock stub:@selector(dataTaskWithRequest:completionHandler:) withBlock:^id(NSArray *params) {
                void(^completionHandler)(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error);
                NSURLResponse *response = [[NSURLResponse alloc] initWithURL:dummyRequest.URL MIMEType:nil expectedContentLength:10 textEncodingName:nil];
                id _Nullable responseObject = @{@"message" : @"success",
                                                @"status"  : @200};
                NSData *expectData = [NSJSONSerialization dataWithJSONObject:responseObject options:kNilOptions error:nil];
                completionHandler = params[1];
                completionHandler(response, expectData, nil);
                return nil;
            }];
            
            URSettingsWrapper.sharedInstance.restClient = restMock;
            __block NSURLResponse *receivedResponse = nil;
            
            [httpUtility startURLConnectionWithRequest:dummyRequest completionHandler:^(id response, NSData *data, NSError *error) {
                [[error should] beNil];
                [[response shouldNot] beNil];
                [[[(NSURLResponse *)response URL] should] equal:dummyRequest.URL];
                [[data shouldNot] beNil];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                [[dict shouldNot] beNil];
                [[dict[@"message"] should] equal:@"success"];
                receivedResponse = response;
            }];
            URSettingsWrapper.sharedInstance.restClient = restNew;
        });
        
        it(@"should return error if server returns error or communication to server failed", ^{
            
            NSURLRequest *dummyRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dummy.philips.com"]];
            id restMock = [KWMock mockForProtocol:@protocol(AIRESTClientProtocol)];
            id restNew = URSettingsWrapper.sharedInstance.restClient;
            [restMock stub:@selector(dataTaskWithRequest:completionHandler:) withBlock:^id(NSArray *params) {
                void(^completionHandler)(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error);
                NSURLResponse *response;
                NSError * _Nullable error = [[NSError alloc] initWithDomain:@"Dummy Error Domain" code:1001 userInfo:nil];
                completionHandler = params[1];
                completionHandler(response, nil, error);
                return nil;
            }];
            
            URSettingsWrapper.sharedInstance.restClient = restMock;
            
            [httpUtility startURLConnectionWithRequest:dummyRequest completionHandler:^(id response, NSData *data, NSError *error) {
                [[response should] beNil];
                [[data should] beNil];
                [[error shouldNot] beNil];
            }];
            URSettingsWrapper.sharedInstance.restClient = restNew;
        });
    });
    
    context(@"class method startURLConnectionWithRequest:completionHandler:", ^{
        
        it(@"should return failure if no request object is supplied.", ^{
            [DIHTTPUtility startURLConnectionWithRequest:nil completionHandler:^(id response, NSData *data, NSError *error) {
                [[error shouldNot] beNil];
                [[response should] beNil];
                [[data should] beNil];
            }];
        });
    });
});

SPEC_END

