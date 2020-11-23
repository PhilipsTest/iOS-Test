//
//  DIHTTPUtility.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DIHTTPUtility.h"
#import "DIRegistrationConstants.h"
#import "URSettingsWrapper.h"
#import "URResponseSerializer.h"
#import "RegistrationUtility.h"
#import "DILogger.h"

@implementation DIHTTPUtility

+ (void)startURLConnectionWithRequest:(NSURLRequest *)request completionHandler:(DIHTTPConnectionCompletionHandler)completionHandler {
    DIHTTPUtility *httpConnection = [[DIHTTPUtility alloc] init];
    [httpConnection startURLConnectionWithRequest:request completionHandler:completionHandler];
}


- (void)startURLConnectionWithRequest:(NSURLRequest *)request completionHandler:(DIHTTPConnectionCompletionHandler)completionHandler {
    if (request == nil) {
        NSError *error = [NSError errorWithDomain:@"NSURLRequest" code:DIInvalidFieldsErrorCode userInfo:@{NSLocalizedDescriptionKey: @"request is nil"}];
        completionHandler(nil, nil, error);
        return;
    }
    DIRInfoLog(@"Requested url-%@", request.URL);
    DIRDebugLog(@"Request description-%@",[RegistrationUtility convertURLRequestToString:request]);
    [[URSettingsWrapper.sharedInstance.restClient dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            DIRInfoLog(@"successful response received with status code-%ld and url-%@", httpResponse.statusCode, httpResponse.URL);
            DIRDebugLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        }
        completionHandler(response, responseObject, error);
    }] resume];
}

@end
