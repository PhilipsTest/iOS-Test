//
//  NSDictionary+HSDPQueryParams.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

@interface NSDictionary (HSDPQueryParams)

- (NSString *)asHSDPURLParamString;

@end
