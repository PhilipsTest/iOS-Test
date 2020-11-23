/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXResponseData.h"

NS_ASSUME_NONNULL_BEGIN
@class PRXFeaturesData;

@interface PRXFeaturesResponse : PRXResponseData

@property (nonatomic, assign) BOOL success;
@property (nonatomic, nullable, strong) PRXFeaturesData *data;

@end

NS_ASSUME_NONNULL_END
