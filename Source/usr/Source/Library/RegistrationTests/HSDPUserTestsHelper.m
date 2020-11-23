//
//  HSDPUserTestsHelper.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 29/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "HSDPUserTestsHelper.h"

@implementation HSDPUserTestsHelper

+ (NSDictionary*)mockJsonResponse {
    return @{@"exchange":@{
                     @"accessCredential":@{
                             @"accessToken":@"r8djvjc8syu2pzcu",
                             @"expiresIn":@"3600",
                             @"refreshToken":@"qkfsp5vacbce7ny6k9gc"
                             },
                     @"user":@{
                             @"loginId":@"philips991@mailinator.com",
                             @"profile":@{
                                     @"givenName" : @"philips",
                                     @"height" : @"0",
                                     @"locale" : @"en-US",
                                     @"photos" : @[],
                                     @"preferredLanguage" : @"en",
                                     @"primaryAddress" :@{
                                             @"country" : @"US"
                                             },
                                     @"receiveMarketingEmail" : @"No",
                                     @"weight" : @"0",
                                     },
                             @"userIsActive" : @"1",
                             @"userUUID" : @"41d55c9c-f21c-4bc9-a5a6-24702c52ed8f"
                             }
                     },
             @"responseCode" : @"200",
             @"responseMessage" : @"Success"
             };
}


+ (NSDictionary*)mockInvalidJsonResponse {
    return @{
             @"exchange" :     @{
                     @"user" :         @{
                             @"loginId" : @"philips991@mailinator.com",
                             @"profile" :             @{
                                     @"givenName" : @"philips",
                                     @"height" : @"0",
                                     @"locale" : @"en-US",
                                     @"photos" : @[],
                                     @"preferredLanguage" : @"en",
                                     @"primaryAddress" :@{
                                             @"country" : @"US"
                                             },
                                     @"receiveMarketingEmail" : @"No",
                                     @"weight" : @"0",
                                     },
                             @"userIsActive" : @"1",
                             @"userUUID" : @"41d55c9c-f21c-4bc9-a5a6-24702c52ed8f"
                             }
                     },
             @"responseCode" : @"200",
             @"responseMessage" : @"Success"
             };
}

+ (NSDictionary *)mockTokenDictionary {
    return @{@"exchange": @{@"accessToken"  :@"some-dummy-data",
                            @"refreshToken" :@"some-dummy-token"},
             @"responseCode" : @"200"
             };
}


+ (NSDictionary *)mockRefreshSecretDictionary {
    return @{@"exchange":@{@"accessCredential":@{@"accessToken":@"some-dummy-value"}},
             @"responseCode": @"200"};
}

@end
