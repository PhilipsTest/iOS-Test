//
//  ConsumerCareMicroAppSettings.m
//  ConsumerCareMicroApp
//
//  Created by Niharika Bundela on 3/22/17.
//  Copyright © 2017 Niharika Bundela. All rights reserved.
//

#import "ConsumerCareMicroAppSettings.h"

@implementation ConsumerCareMicroAppSettings
+ (instancetype) sharedInstance {
    static ConsumerCareMicroAppSettings *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [ConsumerCareMicroAppSettings new];
    });
    return sharedObject;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


@end
