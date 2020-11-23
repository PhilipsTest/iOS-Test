//
//  AIABTest.m
//  AppInfra
//
//  Created by Hashim MH on 03/10/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,
//All rights are reserved. Reproduction or dissemination
//in whole or in part is prohibited without the prior
//written consent of the copyright holder.*/. All rights reserved.
//

#import "AIABTest.h"
#import "AppInfra.h"
#define ABTestComponentName @"AIABTesting"
#define ABTestIdentifier @"abTestConsent"

@interface AIABTest(){
    AIABTestCacheStatus cacheStatus;
}

@property(nonatomic,strong)NSMutableDictionary *abTestingCache;
@property(nonatomic,weak) id<AIAppInfraProtocol>aiAppInfra;
@end

@implementation AIABTest

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    
    self = [super init];
    if (self) {
        self.aiAppInfra = appInfra;
        cacheStatus = AIABTestCacheStatusExperiencesNotUpdated;
        self.abTestingCache = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(AIABTestCacheStatus)getCacheStatus{
    return cacheStatus;
}


-(void)updateCacheWithSuccess:(nullable void(^)(void))success
                        error:(nullable void(^)( NSError* _Nullable))error{
    
    [self.aiAppInfra.logging log:AILogLevelDebug eventId:ABTestComponentName message:@"Appinfra is not implementing ABTest Module it should be injected by propostion to make appinfra module to work"];
        return;
}


-(NSString*)getTestValue:(nonnull NSString*)requestNameKey
                          defaultContent:(nonnull NSString*)defaultValue
                              updateType:(AIABTestUpdateType)updateType {
    return defaultValue;
}

- (void)enableDeveloperMode:(BOOL)enable {
    return;
}

- (NSString *)getABTestConsentIdentifier {
    return ABTestIdentifier;
}

- (void)tageventWithInfo:(nonnull NSString *)eventName params:(nullable NSDictionary<NSString *,id> *)paramDict {
    return;
}

@end


