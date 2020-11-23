//
//  AIAppTaggingWrapper.m
//  AppInfra
//
//  Created by Ravi Kiran HR on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import "AIAppTaggingWrapper.h"
#import "AIAppTagging.h"

@interface AIAppTaggingWrapper ()

@property (nonatomic, strong) AIClientComponent *component;

@end

@implementation AIAppTaggingWrapper

- (instancetype)initWithComponent:(AIClientComponent *)component {
    self = [super init];
    if (self) {
        self.component = component;
    }
    return self;
}

- (NSDictionary *)getAnalyticsDefaultParams {
    NSMutableDictionary *contextData = [[NSMutableDictionary alloc]initWithDictionary:[super getAnalyticsDefaultParams]];
    [contextData setObject:self.component.identifier forKey:@"componentId"];
    [contextData setObject:self.component.version forKey:@"componentVersion"];
    return contextData;
}

@end
