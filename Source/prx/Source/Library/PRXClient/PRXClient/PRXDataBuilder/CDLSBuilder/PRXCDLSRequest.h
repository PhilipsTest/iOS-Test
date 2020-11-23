/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */



#import "PRXRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRXCDLSRequest : PRXRequest
/**
 intializes the PRXCDLSRequest with sector, category and catalogue
 @param sec Sector
 @param category categoy name
 @param cat Catalog
 @return PRXCDLSRequest
 @since 2003.0
 */
- (instancetype)initWithSector:(Sector) sec
                     category:(NSString *) category
                       catalog:(Catalog) cat;
@end

NS_ASSUME_NONNULL_END
