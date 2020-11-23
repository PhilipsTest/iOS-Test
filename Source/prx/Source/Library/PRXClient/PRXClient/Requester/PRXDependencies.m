//
//  PRXDependencies.m
//  PRXClient
//
//  Created by Hashim MH on 13/12/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "PRXDependencies.h"

@implementation PRXDependencies


- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra{
    if (self = [super init]){
        _appInfra = appInfra;
    }
    return self;
}

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra parentTLA:(NSString*)parentTLA{
    if (self = [super init]){
        _appInfra = appInfra;
        _parentTLA = parentTLA;
    }
    return self;
}

@end
