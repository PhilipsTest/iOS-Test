//
//  DIRegistrationVersion.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

@interface DIRegistrationVersion : NSObject

/**
 *  Returns the `PhilipsRegistration` version.
 *
 *  @return version
 *  @since 1.0.0
 */
+ (NSString *)version;

@end
