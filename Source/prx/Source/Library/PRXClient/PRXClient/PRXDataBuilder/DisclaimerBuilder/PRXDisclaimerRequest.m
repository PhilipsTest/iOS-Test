//
//  PRXDisclaimerRequest.m
//  PRXClient
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "PRXDisclaimerRequest.h"
#import "PRXDisclaimerResponse.h"

@implementation PRXDisclaimerRequest

static NSString *const kPRXDisclaimerServiceID = @"prxclient.disclaimers";

- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat {
    self = [super initWithSector:sec catalog:cat ctnNumber:ctnNumber serviceID:kPRXDisclaimerServiceID];
    return self;
}

-(PRXResponseData *)getResponse:(id)data
{
    return [[PRXDisclaimerResponse alloc] parseResponse:data];
}

@end
