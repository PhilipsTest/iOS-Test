//
//  COPPAExtensionHelper.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 28/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRConsentsElement.h"

@interface COPPAExtensionHelper : NSObject

+ (JRConsentsElement *)getConsent:(NSString *)campaignId consentGiven:(NSNumber *)consentGiven
                confirmationGiven:(NSNumber *)confirmationGiven addDate:(BOOL)addDate;

@end
