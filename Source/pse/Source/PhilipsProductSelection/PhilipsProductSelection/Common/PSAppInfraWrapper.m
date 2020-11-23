//
//  PSAppInfraWrapper.m
//  PhilipsProductSelection
//
//  Created by KRISHNA KUMAR on 09/06/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSAppInfraWrapper.h"
#import "PSUtility.h"

@implementation PSAppInfraWrapper

+ (instancetype)sharedInstance
{
    static PSAppInfraWrapper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PSAppInfraWrapper alloc] init];
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

- (void) setAppInfra:(id<AIAppInfraProtocol>)appInfra
{
    _appInfra = appInfra;
    self.productSelectionTagging = [self.appInfra.tagging createInstanceForComponent:@"pse" componentVersion:[PSUtility getVersion]];
    self.productSelectionLogging = [self.appInfra.logging createInstanceForComponent:@"pse" componentVersion:[PSUtility getVersion]];
}

-(void)log:(AILogLevel)level Event:(NSString *)event Message:(NSString *)message
{
    [_productSelectionLogging log:level eventId:event message:message];
}

@end
