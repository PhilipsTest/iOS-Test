//
//  HSDPUserTestsHelper.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 29/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSDPUserTestsHelper : NSObject

+ (NSDictionary*)mockJsonResponse;
+ (NSDictionary*)mockInvalidJsonResponse;
+ (NSDictionary *)mockTokenDictionary;
+ (NSDictionary *)mockRefreshSecretDictionary;

@end
