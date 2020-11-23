//
//  PRXSupportRequest.h
//  PRXClient
//
//  Created by Sumit Prasad on 14/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "PRXRequest.h"

@interface PRXSupportRequest : PRXRequest

/**
 intializes the PRXSupportRequest with sector
 @param sec Sector
 @param ctnNumber CTNNumber NSString
 @param cat Catalog
 @return PRXSupportRequest
 @since 1.0.0
 */
- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat;
@end
