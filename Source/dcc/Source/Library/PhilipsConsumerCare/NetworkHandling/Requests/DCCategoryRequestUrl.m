//
//  DCCategoryRequest.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 16/06/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "DCCategoryRequestUrl.h"
#import "DCUtilities.h"
#import "DCHandler.h"
#import "DCConsumerProductInformation.h"
#import "DCAppInfraWrapper.h"

@implementation DCCategoryRequestUrl

- (id)init{
    self =[super init];
    self.parserClass =  [DCCategoryParser class];
    return self;
}

-(NSString*)requestUrl{
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"The URL used in Find philips near you" Message:self.subUrl];
    return  self.subUrl;
}


@end
