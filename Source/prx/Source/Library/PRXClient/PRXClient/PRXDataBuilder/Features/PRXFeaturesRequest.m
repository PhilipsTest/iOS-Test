/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXFeaturesRequest.h"
#import "PRXFeaturesResponse.h"

@implementation PRXFeaturesRequest

static NSString *const kPRXFeaturesServiceID = @"prxclient.features";

- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat {
    self = [super initWithSector:sec catalog:cat ctnNumber:ctnNumber serviceID:kPRXFeaturesServiceID];
    return self;
}

-(PRXResponseData *)getResponse:(id)data
{
    return [[PRXFeaturesResponse alloc] parseResponse:data];
}

@end
