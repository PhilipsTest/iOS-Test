//
//  NSDictionary+ObjectOrNilForKey.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "NSDictionary+ObjectOrNilForKey.h"

@implementation NSDictionary (ObjectOrNilForKey)

- (id)objectOrNilForKey:(id)aKey
{
    id object = [self objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
