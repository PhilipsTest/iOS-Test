/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>
#import <AdobeMobileSDK/ADBMobile.h>

@interface AIAppTaggingPrivacyStatus : NSObject

+(ADBMobilePrivacyStatus)getPrivacyStatus;
+(void)setPrivacyStatus:(ADBMobilePrivacyStatus)status;

@end
