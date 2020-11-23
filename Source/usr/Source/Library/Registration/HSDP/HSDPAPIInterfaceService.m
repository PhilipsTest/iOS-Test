// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "HSDPAPIInterfaceService.h"
#import "NSDictionary+HSDPQueryParams.h"
#import "DIHSDPConfiguration.h"
#import "URSettingsWrapper.h"
#import "DIRefreshSecretSignature.h"

@interface HSDPAPIInterfaceService()

@property (nonatomic, strong) DIHSDPConfiguration *hsdpConfiguration;

@end

@implementation HSDPAPIInterfaceService

#pragma mark -
#pragma mark - Public Methods

- (instancetype)initWithConfiguration:(DIHSDPConfiguration *)configuration {
    self = [super init];
    if (self) {
        _hsdpConfiguration = configuration;
    }
    return self;
}


- (NSURLRequest *)refreshRequestWithRefreshToken:(NSString *)refreshToken userUUID:(NSString *)uuid {
    if (!refreshToken || !uuid) {
        return nil;
    }
    NSDictionary *params = @{@"refreshToken": refreshToken};
    NSString *pathURL=[NSString stringWithFormat:@"/authentication/users/%@/refreshToken", uuid];
    return [self requestWithURLPath:pathURL
                             method:@"PUT"
                             params:params
                         andHeaders:nil];
}


- (NSURLRequest *)refreshRequestWithAccessToken:(NSString *)accessToken refreshSecret:(NSString *)refreshSecret userUUID:(NSString *)uuid {
    if (!accessToken || !uuid) {
        return nil;
    }
    NSString *signatureDate = [self stringFromDateTime:[DIRegistrationAppTime getUTCTime]];
    NSString *pathURL=[NSString stringWithFormat:@"/authentication/users/%@/refreshAccessToken", uuid];
    NSString *refreshSecretSignatureValue = [DIRefreshSecretSignature buildRefreshSignatureFromDate:signatureDate refreshSecret:refreshSecret accessToken:accessToken];
    return [self requestWithURLPath:pathURL
                             method:@"POST"
                             params:nil
                         andHeaders:@{
                                 @"accessToken":accessToken,
                                 @"refreshSignature":refreshSecretSignatureValue,
                                 @"refreshSignatureDate":signatureDate,
                                 @"api-version":@"2"
                         }];
}


- (NSURLRequest *)logoutRequestForAccessToken:(NSString*)accessToken andUUID:(NSString*)uuid {
    if (!accessToken || !uuid) {
        return nil;
    }
    NSString *pathURL=[NSString stringWithFormat:@"/authentication/users/%@/logout", uuid];
    return [self requestWithURLPath:pathURL
                             method:@"PUT"
                             params:nil
                         andHeaders:@{@"accessToken":accessToken}];
}


- (NSURLRequest *)socialSignInRequestWithEmail:(NSString *)email accessToken:(NSString *)accessToken refreshSecret:(NSString *)refreshSecret {
    if (!email || !accessToken || !refreshSecret) {
        return nil;
    }
    return [self requestWithURLPath:@"/authentication/login/social"
                             method:@"POST"
                             params:@{@"loginId": email}
                         andHeaders:@{@"accessToken":accessToken,
                                      @"refreshSecret":refreshSecret,
                                      @"api-version":@"2"}];
}

#pragma mark -
#pragma mark - Helper Method

- (NSURLRequest*)requestWithURLPath:(NSString*)urlPath method:(NSString*)method params:(NSDictionary*)params andHeaders:(NSDictionary*)headers{
    NSURL *url=[NSURL URLWithString:[self.hsdpConfiguration.baseURL stringByAppendingFormat:@"%@?applicationName=%@", urlPath, self.hsdpConfiguration.applicationName]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    if (params) {
        [request setHTTPBody:[[params asHSDPURLParamString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [request addValue:[formatter stringFromDate:[DIRegistrationAppTime getUTCTime]] forHTTPHeaderField:@"SignedDate"];
    id <AIAPISigningProtocol> apiSigning = [[AIHSDPPHSApiSigning alloc]initApiSigner:self.hsdpConfiguration.sharedKey andhexKey:self.hsdpConfiguration.secretKey];
    NSString * authorizationString = [apiSigning createSignature:request.HTTPMethod dhpUrl:urlPath queryString:[request.URL query] headers:[request allHTTPHeaderFields] requestBody:request.HTTPBody];
    [request addValue:authorizationString forHTTPHeaderField:@"Authorization"];
    [request addValue:@"Application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"Application/json" forHTTPHeaderField:@"Content-Type"];
    for (NSString *key in headers.allKeys) {
        [request addValue:headers[key] forHTTPHeaderField:key];
    }
    return request;
}


- (NSString *)stringFromDateTime:(NSDate *)date
{
    NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [dateFormatter stringFromDate:date];
}

@end
