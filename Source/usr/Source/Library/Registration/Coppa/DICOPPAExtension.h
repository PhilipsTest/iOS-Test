//
//  DICOPPAExtension.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import "DICoppaExtensionConstants.h"


/**
 *  This class defines methods that can be used by applications to query COPPA Consent status of logged in user.
 *
 *  @since 1.0.0
 */
@interface DICOPPAExtension : NSObject

/**
 *  Gets the consent status on Coppa email
 *
 *  @return coppastatus DICOPPASTATUS
 *  @since 1.0.0
 */
- (DICOPPASTATUS)getCoppaEmailConsentStatus;

/**
 *  Fetches the latest COPPA consent status from server by fetching user profile.
 *
 *  @param completion Block will be called when consent status has been received successfully or has failed with error.
 *
 *  @since 1.0.0
 */
- (void)fetchCoppaEmailConsentStatusWithCompletion:(void(^)(DICOPPASTATUS status, NSError *error))completion;

/**
 *  Returns locale used in consent displayed for your app.
 *
 *  @return locale used in consent displayed for your app
 *  @since 1.0.0
 */
- (NSString *)getCoppaConsentLocale;

@end
