//
//  DICoppaExtensionUtility.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DICoppaExtensionUtility.h"
#import "DIUser+Authentication.h"
#import "URSettingsWrapper.h"

@implementation DICoppaExtensionUtility

- (JRConsentsElement *)getConsentElementWithCampaignID:(NSString *)campaignID {
    NSArray *consents = [DIUser getInstance].consents;
    return [[consents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"campaignId MATCHES %@", campaignID]] lastObject];
}


- (DICOPPASTATUS)getCoppaStatusForConsent:(JRConsentsElement *)consent {
    DICOPPASTATUS coppaStatus;
    if (consent.given) {
        if ([consent.given boolValue]) {
            coppaStatus = kDICOPPAConsentGiven;
            if (consent.confirmationGiven) {
                coppaStatus = [consent.confirmationGiven boolValue] ? kDICOPPAConfirmationGiven : kDICOPPAConfirmationNotGiven;
            } else if (consent.confirmationCommunicationSentAt ||(!consent.confirmationCommunicationSentAt && !consent.confirmationCommunicationToSendAt && [self hoursSinceConsentWasSent:consent] >= 24)) {
                coppaStatus = kDICOPPAConfirmationPending;
            }
        } else {
            coppaStatus = kDICOPPAConsentNotGiven;
        }
    } else {
        coppaStatus = kDICOPPAConsentPending;
    }
    return coppaStatus;
}


- (NSInteger)hoursSinceConsentWasSent:(JRConsentsElement *)consent {
    NSDate *consentGivenDate = consent.storedAt;
    if (!consentGivenDate) {
        return 0;
    }
    NSDate *currentUTCDate = [DIRegistrationAppTime getUTCTime];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components:NSCalendarUnitHour fromDate:consentGivenDate toDate:currentUTCDate options:0];
    return [components hour];
}

@end
