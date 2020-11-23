//
//  PRXProductMetaDataRequest.h
//  PRXClient
//
//  Created by Sumit Prasad on 07/03/16.
//  Copyright (c) 2017 Koninklijke Philips N.V.. All rights reserved.
//

#import "PRXRequest.h"

@interface PRXAssetRequest : PRXRequest

/**
 intializes the PRXAssetRequest with sector,CTNNumber and Catalog
 @param sec Sector
 @param ctnNumber CTNNumber NSString
 @param cat Catalog
 @return PRXAssetRequest
 @since 1.0.0
 */
- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat;
@end
