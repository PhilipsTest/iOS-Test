/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRXSummaryListRequest : PRXRequest

/**
 intializes the PRXSummaryListRequest with sector
 @param sec Sector
 @param ctnNumbers list of CTNNumber NSArray
 @param cat Catalog
 @return PRXSummaryListRequest
 @since 1.0.0
 */
- (instancetype)initWithSector:(Sector) sec
                     ctnNumbers:(NSArray *) ctnNumbers
                       catalog:(Catalog) cat;
@end

NS_ASSUME_NONNULL_END
