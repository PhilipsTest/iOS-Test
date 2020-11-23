//
//  AISDURLs.m
//  AppInfra
//
//  Created by leslie on 23/01/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AISDURLs.h"
#import "AISDService.h"
#import "AISDManager.h"
#import "AIInternalLogger.h"
static NSString *const SDEmptyURL = @"https://delete.delete";
static NSString *const evenID = @"Service Discovery";

@interface AISDURLs()

@property(nonatomic, weak)id<AIAppInfraProtocol> aiAppInfra;

@end

@implementation AISDURLs

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.aiAppInfra = appInfra;
    }
    return self;
}

-(NSString *)getServiceURLWithServiceID:(NSString *)serviceID Preference:(AISDPreference)preference {
    NSString * URLProposition, *URLPlatform;
    if (self.propositionURLs) {
         URLProposition = [self.propositionURLs getServiceURLWithServiceID:serviceID Preference:preference];
    }
    
    if (self.platformURLs) {
        URLPlatform = [self.platformURLs getServiceURLWithServiceID:serviceID Preference:preference];
    }
    
    if (URLPlatform && URLProposition) {
        [AIInternalLogger log:AILogLevelVerbose eventId:evenID
                                           message:@"Platform URL is overridden by proposition URL"];
    }
    
    if (URLProposition) {
        if ([URLProposition isEqualToString:SDEmptyURL]) {
            [AIInternalLogger log:AILogLevelVerbose
                                               eventId:evenID
                                               message:@"Proposition has empty URL. So ignoring platform URL"];
            return nil;
        }
        return URLProposition;
    }
    
    return URLPlatform;
}

-(NSDictionary *)getServicesWithServiceID:(NSArray *)serviceIDs Preference:(AISDPreference)preference {
    NSDictionary * propositionDict, * platformDict;
    propositionDict = [self.propositionURLs getServicesWithServiceID:serviceIDs Preference:preference];
    platformDict = [self.platformURLs getServicesWithServiceID:serviceIDs Preference:preference];
    
    if (propositionDict || platformDict) {
        NSMutableDictionary * outputDict = [NSMutableDictionary new];
        for (NSString * serviceID in serviceIDs) {
            AISDService * serviceProposition = [propositionDict objectForKey:serviceID];
            AISDService * servicePlatform = [platformDict objectForKey:serviceID];
            NSString *logMessage;
            
            if (serviceProposition.url && servicePlatform.url) {
                logMessage = [[NSString alloc]initWithFormat:@"Platform URL is overridden by proposition URL for serviceId:%@",serviceID];
                [AIInternalLogger log:AILogLevelDebug
                                                   eventId:evenID
                                                   message:logMessage];
            }
            
            
            if (serviceProposition.url) {
                if ([serviceProposition.url isEqualToString:SDEmptyURL]) {
                    serviceProposition.url = nil;
                    serviceProposition.error = [AISDManager getSDError:AISDCannotFindURLError];
                    
                    logMessage = [[NSString alloc]initWithFormat:@"Proposition has empty URL. So ignoring platform URL for serviceId:%@",serviceID];
                    [AIInternalLogger log:AILogLevelDebug
                                                       eventId:evenID
                                                       message:logMessage];
                }
                [outputDict setObject:serviceProposition forKey:serviceID];
            }
            else if (servicePlatform) {
                [outputDict setObject:servicePlatform forKey:serviceID];
            }
        }
        return outputDict;
    }
    return nil;
}

-(NSString *)getLocaleWithPreference:(AISDPreference)preference {
    NSString * locale;
    if (self.propositionURLs) {
        locale = [self.propositionURLs getLocaleWithPreference:preference];
        if (locale) {
            return locale;
        }
    }
    
    if (self.platformURLs) {
        locale = [self.platformURLs getLocaleWithPreference:preference];
        if (locale) {
            return locale;
        }
    }
    
    return nil;
}

-(NSString *)getCountryCode {
    if (self.propositionURLs) {
        return self.propositionURLs.country;
    }
    else if(self.platformURLs) {
        return self.platformURLs.country;
    }
    
    return nil;
}

@end
