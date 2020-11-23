/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


#import "PRXResponseData.h"

NS_ASSUME_NONNULL_BEGIN
@class PRXCDLSData;

@interface PRXCDLSResponse: PRXResponseData

@property (nonatomic, assign) BOOL success;
@property (nonatomic, nullable, strong) PRXCDLSData *data;

@end

NS_ASSUME_NONNULL_END
