/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PRXFeaturesKeyBenefitArea;
@class PRXFeaturesHighlight;
@class PRXFeaturesAssetDetails;

@interface PRXFeaturesData : NSObject

@property (nonatomic, nullable, strong) NSArray<PRXFeaturesKeyBenefitArea *> *keyBenefitArea;
@property (nonatomic, nullable, strong) NSArray<PRXFeaturesHighlight *> *featureHighlight;
@property (nonatomic, nullable, strong) NSArray<PRXFeaturesAssetDetails *> *assetDetails;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
