//
//  DemoUAppSettings.m
//  DemoUApp
//
//  Created by Sai Pasumarthy on 19/06/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "DemoUAppSettings.h"

@implementation DemoUAppSettings

+ (instancetype) sharedInstance {
    static DemoUAppSettings *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[DemoUAppSettings alloc] init];
    });
    return sharedObject;
}
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

@end
