/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRXSpecificationsRequest : PRXRequest

- (instancetype)initWithSector:(Sector) sec
                     ctnNumber:(NSString *) ctnNumber
                       catalog:(Catalog) cat;

@end

NS_ASSUME_NONNULL_END
