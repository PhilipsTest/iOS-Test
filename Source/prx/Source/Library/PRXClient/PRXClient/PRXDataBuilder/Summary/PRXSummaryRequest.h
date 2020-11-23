//
//  PRXSummaryRequest.h
//  PRXClient
//
//  Created by Sumit Prasad on 11/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "PRXRequest.h"

@interface PRXSummaryRequest : PRXRequest

/**
 intializes the PRXSummaryRequest with sector,CTNNumber and Catalog
 @param sec Sector
 @param ctnNumber CTNNumber NSString
 @param cat Catalog
 @return PRXSummaryRequest
 @since 1.0.0
 */
- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat;
@end
