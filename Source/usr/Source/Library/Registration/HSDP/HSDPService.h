//
//  HSDPService.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "HSDPUser.h"

typedef void (^HSDPServiceCompletionHandler)(HSDPUser *user, NSError *error);

@interface HSDPService : NSObject

+ (BOOL)isHSDPConfigurationAvailableForCountry:(NSString *)countryCode;
+ (BOOL)isHSDPSkipLoadingEnabled;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCountryCode:(NSString *)countryCode baseURL:(NSString *)baseURL NS_DESIGNATED_INITIALIZER;
- (void)loginWithSocialUsingEmail:(NSString *)email accessToken:(NSString *)accessToken refreshSecret:(NSString *)refreshSecret
                       completion:(HSDPServiceCompletionHandler)completion;
- (void)refreshSessionForUUID:(NSString *)uuid accessToken:(NSString *)accessToken refreshSecret:(NSString *)refreshSecret
                   completion:(HSDPServiceCompletionHandler)completion;
- (void)refreshSessionForUUID:(NSString *)uuid refreshToken:(NSString *)refreshToken completion:(HSDPServiceCompletionHandler)completion;
- (void)logoutUserWithUUID:(NSString *)uuid accessToken:(NSString *)accessToken completion:(void(^)(NSError *error))completion;

@end
