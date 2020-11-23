//
//  DIRegistrationVersion.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DIRegistrationVersion.h"

@implementation DIRegistrationVersion

+ (NSString *)version {
    NSDictionary *info = [[NSBundle bundleForClass:[DIRegistrationVersion class]] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    return [version stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
