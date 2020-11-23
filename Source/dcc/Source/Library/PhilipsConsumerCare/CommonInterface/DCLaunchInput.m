//
//  CCLaunchInput.m
//  PhilipsConsumerCare
//
//  Created by sameer sulaiman on 8/11/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "DCLaunchInput.h"

@implementation DCLaunchInput

/**
 Description: Convenience initializer
 @return return instance of DCLaunchInput
 @since 1.0.0
 */
- (instancetype) init {
    self = [super init];
    if (self) {
        self.productModelSelectionType = [[PSProductModelSelectionType alloc] init];
    }
    return self;
}

@end
