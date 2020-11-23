//
//  secUtility.m
//  App Infra
//
//  Created by Abhinav Jha on 5/5/15.
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "AISSUtility.h"

#define AISSCaptureKeychainIdentifier @"capture_tokens_AppInfra"


@implementation AISSUtility

// method to get the service name
+ (NSString *)serviceNameForTokenName:(NSString *)tokenName
{
    return [NSString stringWithFormat:@"%@.%@.%@.", AISSCaptureKeychainIdentifier, tokenName,
            appBundleIdentifier()];
}

// method to fetch the bundle name
static NSString*appBundleIdentifier()
{
    NSDictionary *infoPlist = [[NSBundle bundleForClass:[AISSUtility class]] infoDictionary];
    NSString *identifier = [infoPlist objectForKey:@"CFBundleIdentifier"];
    return identifier;
}


@end

