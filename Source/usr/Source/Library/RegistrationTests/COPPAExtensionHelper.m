//
//  COPPAExtensionHelper.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 28/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "COPPAExtensionHelper.h"

@implementation COPPAExtensionHelper


+ (JRConsentsElement *)getConsent:(NSString *)campaignId consentGiven:(NSNumber *)consentGiven
                confirmationGiven:(NSNumber *)confirmationGiven addDate:(BOOL)addDate {
    JRConsentsElement *dummyconsent =[JRConsentsElement consentsElement];
    dummyconsent.campaignId = campaignId;
    dummyconsent.given = consentGiven;
    if (addDate) {
        dummyconsent.storedAt = [NSDate dateWithTimeIntervalSinceNow:-86500];
    }
    dummyconsent.locale = @"en_US";
    dummyconsent.confirmationGiven = confirmationGiven;
    return dummyconsent;
}


@end
