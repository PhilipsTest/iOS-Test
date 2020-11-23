//
//  URErrorAppTaggingUtility.h
//  Registration
//
//  Created by Abhishek on 01/02/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegistrationAnalyticsConstants.h"

@interface URErrorAppTaggingUtility : NSObject
+ (void)trackAppMappedError:(NSError *)error serverErrorCode:(NSInteger)errorCode serverErrorMessage:(NSString *)errorMessage;
+ (void)trackURXAppServerError:(NSError *)error errorMessage:(NSString *)errorMessage;
+ (void)tagForcelogoutWithDomain:(NSString *)domain errorCode:(NSInteger)errorCode timeDifference:(NSInteger)difference wasNetworkTimeSynchronized:(BOOL)wasSynchronised;
+ (void)tagClearUserData:(NSInteger)errorCode errorMessage:(NSString *)errorMessage errorType:(NSString *)errorType;
@end
