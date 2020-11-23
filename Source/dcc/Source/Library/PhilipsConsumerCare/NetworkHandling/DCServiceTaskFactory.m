//
//  DCServiceTaskFactory.m
//  DigitalCare
//
//  Created by sameer sulaiman on 18/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCServiceTaskFactory.h"

@implementation DCServiceTaskFactory

-(id)init{
    self=[super init];
    if(self == nil) return nil;
    return self;
}

- (DCServiceTaskHandler*) getInstanceforRequest:(DCRequestBaseUrl*)requestBase{
    DCServiceTaskHandler *handler = [[DCServiceTaskHandler alloc] init];
    handler.requestUrl = requestBase.requestUrl;
    handler.parserType = requestBase.parserType;
    handler.parserClass = requestBase.parserClass;
    return handler;    
}

@end
