//
//  URBaseErrorParser.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import "RegistrationUIConstants.h"
#import "DILogger.h"

@interface URBaseErrorParser : NSObject
+ (NSInteger)mapCommonErrorCode:(NSInteger)errorCode;
+ (NSError *)errorForErrorCode:(NSInteger)errorCode;
+ (NSString *)getFormattedErrorLog:(NSError *)serverError andMappedError:(NSError *)mappedError;
+(NSError *)userNotLoggedInError;
+ (NSError *)unsupportedConsentError;
+ (NSError *)userNotProvidedConsentError;
@end
