//
//  AIATUtility.m
//  AppInfra
//
//  Created by leslie on 20/09/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import "AIATUtility.h"

#import "AIAppTaggingProtocol.h"
#import "AIInternalTaggingUtility.h"

static AIATUtility *sharedInstance;

@implementation AIATUtility

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AIATUtility alloc] init];
    });
    
    return sharedInstance;
}

- (NSString *)getTaggingErrorCategory:(AITaggingErrorCategory) errorCategory {
    NSString *taggingKey = nil;
    switch (errorCategory) {
        case AITaggingTechnicalError:
            taggingKey = kAilTechnicalError;
            break;
        case AITaggingUserError:
            taggingKey = kAilUserError;
            break;
        case AITaggingInformationalError:
            taggingKey = kAilInformationalError;
            break;
        default:
            NSAssert(1, @"Please provide valid tagging error category, refer AITaggingErrorCategory enum");
            break;
    }
    return taggingKey;
}

@end
