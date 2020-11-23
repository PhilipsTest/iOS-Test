//
//  URJanRainConfiguration.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 11/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DIRegistrationConstants.h"

@interface URJanRainConfiguration : NSObject

- (instancetype)initWithCountry:(NSString *)countryCode locale:(NSString *)locale serviceURLs:(NSDictionary *)serviceURLs flowDownloadCompletion:(void(^)(NSError *error))completion;

/**
 *  Get campaignId of your app only if you are using COPPA flow.
 */
@property (nonatomic, strong, readonly) NSString *campaignID;

/**
 *  Get micorsideID of your application.
 */
@property (nonatomic, strong, readonly) NSString *micrositeID;

/**
 Landing page URL for reset password.
 */
@property (nonatomic, strong, readonly) NSString *resetPasswordURL;

/**
 ClientId to be used for reset password request for mobile number flow.
 */
@property (nonatomic, strong, readonly) NSString *resetPasswordClientId;

/**
 Base URL for URX APIs.
 */
@property (nonatomic, strong, readonly) NSString *urxBaseURL;

@end
