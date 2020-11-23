/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXSpecificationsRequest.h"
#import "PRXSpecificationsResponse.h"

@implementation PRXSpecificationsRequest

static NSString *const kPRXSpecificationsServiceID = @"prxclient.specification";

- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat {
    self = [super initWithSector:sec catalog:cat ctnNumber:ctnNumber serviceID:kPRXSpecificationsServiceID];
    return self;
}

-(PRXResponseData *)getResponse:(id)data
{
    return [[PRXSpecificationsResponse alloc] parseResponse:data];
}

@end
