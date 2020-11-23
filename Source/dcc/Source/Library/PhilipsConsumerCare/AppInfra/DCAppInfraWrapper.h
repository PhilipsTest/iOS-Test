//
//  DCAppInfraWrapper.h
//  PhilipsConsumerCare
//
//  Created by KRISHNA KUMAR on 24/06/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UAPPFramework/UAPPFramework.h>

@interface DCAppInfraWrapper : NSObject

@property (nonatomic) id<AIAppTaggingProtocol> consumerCareTagging;
@property (nonatomic) id<AILoggingProtocol> consumerCareLog;
@property (nonatomic, strong) UAPPDependencies *dependencies;
@property (nonatomic , strong) AIAppInfra *appInfra;

+ (instancetype)sharedInstance;
-(void)log:(AILogLevel)level Event:(NSString *)event Message:(NSString *)message;
@end
