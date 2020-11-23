//
//  URCOPPAConfiguration.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 22/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URCOPPAConfiguration : NSObject

/**
 *  Get campaignId of your app only if you are using COPPA flow.
 */
@property (nonatomic, strong, readonly) NSString *campaignID;

@end
