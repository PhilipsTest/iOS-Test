//
//  HSDPUser.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "HSDPUser.h"
#import "NSDictionary+ObjectOrNilForKey.h"
#import "URSettingsWrapper.h"


NSString *const kHSDPExchange = @"exchange";
NSString *const kHSDPAccessCredential = @"accessCredential";
NSString *const kHSDPAccessToken = @"accessToken";
NSString *const kHSDPRefreshToken = @"refreshToken";
NSString *const kHSDPRefreshSecret = @"refreshSecret";
NSString *const kHSDPUser = @"user";
NSString *const kHSDPUserUUID = @"userUUID";
NSString *const kHSDPUserKey = @"HSDP_USER_ARCHIVED";

@implementation HSDPUser

- (instancetype)initWithSignInResponseDictionary:(NSDictionary *)dict refreshSecret:(NSString *)refreshSecret {
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        _userUUID = [dict[kHSDPExchange][kHSDPUser] objectOrNilForKey:kHSDPUserUUID];
        _accessToken = [dict[kHSDPExchange][kHSDPAccessCredential] objectOrNilForKey:kHSDPAccessToken];
        _refreshToken = [dict[kHSDPExchange][kHSDPAccessCredential] objectOrNilForKey:kHSDPRefreshToken];
        _refreshSecret = refreshSecret;
    }
    return self;    
}

- (instancetype)initWithUUID:(NSString *)uuid tokenDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        _userUUID = uuid;
        _accessToken = [dict[kHSDPExchange] objectOrNilForKey:kHSDPAccessToken];
        _refreshToken = [dict[kHSDPExchange] objectOrNilForKey:kHSDPRefreshToken];
    }
    return self;
}

- (instancetype)initWithUUID:(NSString *)uuid refreshSecret:(NSString *)refreshSecret tokenDictionary:(NSDictionary *)dict {
    self = [super init];
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        _userUUID = uuid;
        _accessToken = [dict[kHSDPExchange][kHSDPAccessCredential] objectOrNilForKey:kHSDPAccessToken];
        _refreshSecret = refreshSecret;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _userUUID = [aDecoder decodeObjectForKey:kHSDPUserUUID];
        _accessToken = [aDecoder decodeObjectForKey:kHSDPAccessToken];
        _refreshToken = [aDecoder decodeObjectForKey:kHSDPRefreshToken];
        _refreshSecret = [aDecoder decodeObjectForKey:kHSDPRefreshSecret];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject: self.userUUID forKey:kHSDPUserUUID];
    [coder encodeObject:self.accessToken forKey:kHSDPAccessToken];
    [coder encodeObject:self.refreshToken forKey:kHSDPRefreshToken];
    [coder encodeObject:self.refreshSecret forKey:kHSDPRefreshSecret];
}

+ (HSDPUser *)loadPreviousInstance {
    return [DIRegistrationStorageProvider fetchValueForKey:kHSDPUserKey error:nil];
}

- (void)saveCurrentInstance {
    [DIRegistrationStorageProvider storeValueForKey:kHSDPUserKey value:self error:nil];
}

- (void)removeCurrentInstance {
    [DIRegistrationStorageProvider removeValueForKey:kHSDPUserKey];
}

- (BOOL)isSignedIn {
    return (self.userUUID != nil) && (self.accessToken != nil) && (self.refreshToken || self.refreshSecret);
}
@end
