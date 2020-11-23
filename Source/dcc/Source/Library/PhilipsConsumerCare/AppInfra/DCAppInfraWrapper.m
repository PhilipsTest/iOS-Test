//
//  DCAppInfraWrapper.m
//  PhilipsConsumerCare
//
//  Created by KRISHNA KUMAR on 24/06/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "DCAppInfraWrapper.h"
@implementation DCAppInfraWrapper

+ (instancetype)sharedInstance
{
    static DCAppInfraWrapper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DCAppInfraWrapper alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) setAppInfra:(AIAppInfra *)appInfra
{
    _appInfra = appInfra;
    self.consumerCareTagging = [self.appInfra.tagging createInstanceForComponent:@"dcc" componentVersion: [_appInfra appVersion]];
    self.consumerCareLog = [self.appInfra.logging createInstanceForComponent:@"dcc" componentVersion:[_appInfra appVersion]];
}

-(void)log:(AILogLevel)level Event:(NSString *)event Message:(NSString *)message
{
    [_consumerCareLog log:level eventId:event message:message];
}

@end
