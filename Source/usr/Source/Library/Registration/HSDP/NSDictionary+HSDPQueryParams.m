//
//  NSDictionary+HSDPQueryParams.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "NSDictionary+HSDPQueryParams.h"

@implementation NSDictionary (HSDPQueryParams)

- (NSString *)asHSDPURLParamString {
    NSMutableString *retVal = [NSMutableString string];
    if ([self allKeys].count != 0)[retVal appendFormat:@"{"];
    for (id key in [self allKeys]) {
        if ([retVal length] > 1) [retVal appendString:@","];
        NSString *value = self[key];
        [retVal appendFormat:@"\"%@\":\"%@\"", key, value];
    }
    if ([self allKeys].count != 0)[retVal appendFormat:@"}"];
    return retVal;
}

@end
