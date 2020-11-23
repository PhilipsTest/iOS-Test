//
//  PRXProductMetaDataRequest.m
//  PRXClient
//
//  Created by Sumit Prasad on 07/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "PRXAssetRequest.h"
#import "PRXAssetResponse.h"
@import AppInfra;

static NSString *const kPRXAssetServiceID = @"prxclient.assets";

@implementation PRXAssetRequest

- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat{
    self = [super initWithSector:sec catalog:cat ctnNumber:ctnNumber serviceID:kPRXAssetServiceID];
    return self;
}

-(PRXResponseData *)getResponse:(id)data
{
    return [[PRXAssetResponse alloc] parseResponse:data];
}
@end
