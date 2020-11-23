//
//  PRXSupportRequest.m
//  PRXClient
//
//  Created by Sumit Prasad on 14/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "PRXSupportRequest.h"
#import "PRXSupportResponse.h"


static NSString *const kPRXFAQServiceID = @"prxclient.support";

@implementation PRXSupportRequest
- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat{
    self = [super initWithSector:sec catalog:cat ctnNumber:ctnNumber serviceID:kPRXFAQServiceID];
    return self;
}

-(PRXResponseData *)getResponse:(id)data
{
    return [[PRXSupportResponse alloc] parseResponse:data];
}

@end
