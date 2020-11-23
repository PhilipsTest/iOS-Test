//
//  NetworkHelper.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 25/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject

+ (void)verifyUserWithUUID:(NSString *)userUUID withCompletion:(void(^)(NSError *error))completion;
+ (void)verifyChinaUserWithUUID:(NSString *)userUUID withCompletion:(void(^)(NSError *error))completion;
+ (void)retrieveAccountVerificationCodeForUser:(NSString *)uuid fromChinaStagingWithCompletion:(void(^)(NSString *code, NSError *error))completion;
+ (void)deleteChinaUser:(NSString *)uuid fromChinaStagingWithCompletion:(void(^)(NSError *error))completion;

@end
