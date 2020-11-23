//
//  DCFeedbackConfig.h
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 21/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

@interface DCFeedbackConfig : NSObject

@property (nonatomic, strong) NSString *appStoreId;

-(id)initWithDictionary:(NSDictionary*)dict;

@end
