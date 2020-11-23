/* Copyright (c) Koninklijke Philips N.V., 2018
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "AIAppTaggingPrivacyStatus.h"

static NSString *const adbTaggingStatusKey = @"ail_adb_status";
static ADBMobilePrivacyStatus adbTrackingStatus;

@implementation AIAppTaggingPrivacyStatus

+(void)setPrivacyStatus:(ADBMobilePrivacyStatus)status {
    [NSUserDefaults.standardUserDefaults setObject:@(status) forKey:adbTaggingStatusKey];
    [NSUserDefaults.standardUserDefaults synchronize];
    adbTrackingStatus = status;
}

+(ADBMobilePrivacyStatus)getPrivacyStatus {
    return adbTrackingStatus == 0 ? [AIAppTaggingPrivacyStatus getActualPrivacyStatus] : adbTrackingStatus;
}

+(ADBMobilePrivacyStatus)getActualPrivacyStatus {
    id adbConsentStoredStatus = [NSUserDefaults.standardUserDefaults objectForKey:adbTaggingStatusKey];
    ADBMobilePrivacyStatus status = adbConsentStoredStatus ? [adbConsentStoredStatus integerValue] : [ADBMobile privacyStatus];
    return status;
}

@end
