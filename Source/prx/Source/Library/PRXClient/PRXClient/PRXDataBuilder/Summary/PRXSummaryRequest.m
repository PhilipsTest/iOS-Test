//
//  PRXSummaryRequest.m
//  PRXClient
//
//  Created by Sumit Prasad on 11/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "PRXSummaryRequest.h"
#import "PRXSummaryResponse.h"
@import AppInfra;

static NSString *const kPRXSummaryDataServiceID = @"prxclient.summary";

@implementation PRXSummaryRequest

- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat{
    self = [super initWithSector:sec catalog:cat ctnNumber:ctnNumber serviceID:kPRXSummaryDataServiceID];

    return self;
}

-(PRXResponseData *)getResponse:(id)data
{
    return [[PRXSummaryResponse alloc] parseResponse:data];
}


@end
