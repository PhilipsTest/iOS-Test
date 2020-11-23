//
//  HSDPService.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "HSDPService.h"
#import "DIHSDPConfiguration.h"
#import "DIRegistrationConstants.h"
#import "HSDPAPIInterfaceService.h"
#import "DIHTTPUtility.h"
#import "URSettingsWrapper.h"
#import "URHSDPErrorParser.h"
#import "URRSAEncryptor.h"
#import "NSDictionary+ObjectOrNilForKey.h"
#import "RegistrationAnalyticsConstants.h"
#import "DIConstants.h"

@interface HSDPService()

@property (nonatomic, strong) HSDPAPIInterfaceService *hsdpAPIInterface;
@property (nonatomic, strong) DIHTTPUtility *httpUtility;

@end

@implementation HSDPService

+ (BOOL)isHSDPConfigurationAvailableForCountry:(NSString *)countryCode {
    return [DIHSDPConfiguration isHSDPConfigurationAvailableForCountry:countryCode];
}

+ (BOOL)isHSDPSkipLoadingEnabled {
    return [DIHSDPConfiguration isHSDPSkipLoginConfigurationAvailable];
}

#pragma mark - Initializer Method
#pragma mark -

- (instancetype)initWithCountryCode:(NSString *)countryCode baseURL:(NSString *)baseURL {
    self = [super init];
    if (self) {
        DIHSDPConfiguration *hsdpConfiguration = [[DIHSDPConfiguration alloc] initWithCountryCode:countryCode baseURL:baseURL];
        if (!hsdpConfiguration) {
            return nil;
        }
        _hsdpAPIInterface = [[HSDPAPIInterfaceService alloc] initWithConfiguration:hsdpConfiguration];
        _httpUtility = [[DIHTTPUtility alloc] init];
    }
    return self;
}

#pragma mark - HSDP APIs
#pragma mark -

- (void)loginWithSocialUsingEmail:(NSString *)email accessToken:(NSString *)accessToken refreshSecret:(NSString *)refreshSecret
                       completion:(HSDPServiceCompletionHandler)completion {
    if (!email || !accessToken || !refreshSecret) {
        completion(nil, [URBaseErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
    }else {
        NSURLRequest *request = [self.hsdpAPIInterface socialSignInRequestWithEmail:email accessToken:accessToken refreshSecret:refreshSecret];
        [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *error) {
            NSError *parsedError;
            NSDictionary *parsedJSON = [self parsedJSONForData:data serverError:error parsedError:&parsedError];
            if (parsedError) {
                completion(nil, parsedError);
            }else {
                if ([[RegistrationUtility configValueForKey:HSDPUUIDUpload countryCode:nil error:nil] boolValue]) {
                    NSString *uuid = [parsedJSON[@"exchange"][@"user"] objectOrNilForKey:@"userUUID"];
                    NSString *secureId = [URRSAEncryptor encryptString:uuid withPublicKey:kHSDPSecurePubKey];
                    [DIRegistrationAppTagging trackActionWithInfo:kRegSendData params:@{kRegistrationUuidKey:secureId}];
                }
                completion([[HSDPUser alloc] initWithSignInResponseDictionary:parsedJSON refreshSecret:refreshSecret], nil);
            }
        }];
    }
}


- (void)refreshSessionForUUID:(NSString *)uuid accessToken:(NSString *)accessToken refreshSecret:(NSString *)refreshSecret
                   completion:(HSDPServiceCompletionHandler)completion {
    if (!uuid || !accessToken || !refreshSecret) {
        completion(nil, [URBaseErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
    }else {
        NSURLRequest *request = [self.hsdpAPIInterface refreshRequestWithAccessToken:accessToken refreshSecret:refreshSecret userUUID:uuid];
        [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *error) {
            NSError *parsedError;
            NSDictionary *parsedJSON = [self parsedJSONForData:data serverError:error parsedError:&parsedError];
            if (parsedError) {
                completion(nil, parsedError);
            }else {
                completion([[HSDPUser alloc] initWithUUID:uuid refreshSecret:refreshSecret tokenDictionary:parsedJSON], nil);
            }
        }];
    }
}


- (void)refreshSessionForUUID:(NSString *)uuid refreshToken:(NSString *)refreshToken completion:(HSDPServiceCompletionHandler)completion {
    if (!uuid || !refreshToken) {
        completion(nil, [URBaseErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
    }else {
        NSURLRequest *request = [self.hsdpAPIInterface refreshRequestWithRefreshToken:refreshToken userUUID:uuid];
        [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *error) {
            NSError *parsedError;
            NSDictionary *parsedJSON = [self parsedJSONForData:data serverError:error parsedError:&parsedError];
            if (parsedError) {
                completion(nil, parsedError);
            }else {
                completion([[HSDPUser alloc] initWithUUID:uuid tokenDictionary:parsedJSON], nil);
            }
        }];
    }
}


- (void)logoutUserWithUUID:(NSString *)uuid accessToken:(NSString *)accessToken completion:(void(^)(NSError *error))completion {
    if (!uuid || !accessToken) {
        completion([URBaseErrorParser errorForErrorCode:DIInvalidFieldsErrorCode]);
    }else {
        NSURLRequest *request = [self.hsdpAPIInterface logoutRequestForAccessToken:accessToken andUUID:uuid];
        [self.httpUtility startURLConnectionWithRequest:request completionHandler:^(id response, NSData *data, NSError *error) {
            NSError *parsedError;
            __unused NSDictionary *result = [self parsedJSONForData:data serverError:error parsedError:&parsedError];
            completion(parsedError);
        }];
    }
}

#pragma mark - Helper Method
#pragma mark -

- (NSDictionary *)parsedJSONForData:(NSData *)data serverError:(NSError *)serverError parsedError:(NSError * __autoreleasing *)error {
    if (serverError) {
        if (error != NULL) {
            *error = [URHSDPErrorParser mappedErrorForError:serverError response:nil];
        }
    }else {
        NSError *parsingError;
        id parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parsingError];
        if (parsingError || !parsedJSON) {
            if (error != NULL) {
                NSMutableDictionary *errorDict = [[NSMutableDictionary alloc]initWithDictionary:@{@"responseMessage":@"UnRecognisedResponse"}];
                if (parsingError.code) {
                    [errorDict setObject:[NSNumber numberWithInteger:parsingError.code] forKey:@"responseCode"];
                }
                *error = [URHSDPErrorParser mappedErrorForError:parsingError response:nil];
            }
        }else if ([parsedJSON isKindOfClass:[NSDictionary class]] && [[parsedJSON valueForKey:@"responseCode"] isEqualToString:@"200"]) {
            return parsedJSON;
        }else {
            if (error != NULL) {
                *error = [URHSDPErrorParser mappedErrorForError:nil response:parsedJSON];
            }
        }
    }
    return nil;
}


@end
