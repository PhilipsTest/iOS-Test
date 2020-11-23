//
//  HSDPUser.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

@interface HSDPUser : NSObject<NSCoding>

@property (nonatomic, strong) NSString *userUUID;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *refreshSecret;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithSignInResponseDictionary:(NSDictionary *)dict refreshSecret:(NSString *)refreshSecret;
- (instancetype)initWithUUID:(NSString *)uuid tokenDictionary:(NSDictionary *)dict;
- (instancetype)initWithUUID:(NSString *)uuid refreshSecret:(NSString *)refreshSecret tokenDictionary:(NSDictionary *)dict;
- (BOOL)isSignedIn;

+ (HSDPUser *)loadPreviousInstance;
- (void)saveCurrentInstance;
- (void)removeCurrentInstance;
@end
