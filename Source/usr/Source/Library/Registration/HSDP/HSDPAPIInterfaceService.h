// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
@class DIHSDPConfiguration;

@interface HSDPAPIInterfaceService : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(DIHSDPConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

- (NSURLRequest *)logoutRequestForAccessToken:(NSString*)accessToken andUUID:(NSString*)uuid;
- (NSURLRequest *)refreshRequestWithAccessToken:(NSString *)accessToken refreshSecret:(NSString *)refreshSecret userUUID:(NSString *)uuid;
- (NSURLRequest *)refreshRequestWithRefreshToken:(NSString *)refreshToken userUUID:(NSString *)uuid;
- (NSURLRequest *)socialSignInRequestWithEmail:(NSString *)email accessToken:(NSString *)accessToken refreshSecret:(NSString *)refreshSecret;

@end
