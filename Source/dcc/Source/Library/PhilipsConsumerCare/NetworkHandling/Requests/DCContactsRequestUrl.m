//
//  DCContactsRequest.m
//  DigitalCare
//
//  Created by sameer sulaiman on 18/02/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

#import "DCContactsRequestUrl.h"
#import "DCUtilities.h"
#import "DCHandler.h"
#import "DCConsumerProductInformation.h"
#import "DCAppInfraWrapper.h"
#import "DCPluginManager.h"

@implementation DCContactsRequestUrl

- (id)init{
    self =[super init];
    self.parserClass =  [DCContactsParser class];
    return self;
}

-(NSString*)requestUrl{
    self.subUrl = [self.subUrl stringByReplacingOccurrencesOfString:@"%productCategory%" withString:self.productCategory];
    [[DCAppInfraWrapper sharedInstance] log:AILogLevelDebug Event:@"Find philipes request URL is" Message:self.subUrl];
    return  self.subUrl;
}

@end
