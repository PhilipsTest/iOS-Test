//
//  AIInternalTaggingUtility.m
//  AppInfra
//
//  Created by Hashim MH on 07/02/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AIInternalTaggingUtility.h"
#import "AppInfra.h"

@implementation AIInternalTaggingUtility
static id<AIAppTaggingProtocol> sharedTagging = nil;

+ (void)setSharedTagging:(id<AIAppTaggingProtocol>)tagInstance {
    @synchronized(self) {
        sharedTagging = tagInstance;
    }
}

+ (void)resetSharedTagging {
    @synchronized(self) {
        sharedTagging = nil;
    }
}

+ (BOOL)isNetworkError: (NSError *)error {
    return ([error code] == NSURLErrorNetworkConnectionLost || [error code] == NSURLErrorNotConnectedToInternet);
}

@end
