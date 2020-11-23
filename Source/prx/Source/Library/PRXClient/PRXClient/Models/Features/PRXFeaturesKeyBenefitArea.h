/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PRXFeaturesDetails;

@interface PRXFeaturesKeyBenefitArea : NSObject

@property (nonatomic, nullable, strong) NSString *keyBenefitAreaCode;
@property (nonatomic, nullable, strong) NSString *keyBenefitAreaName;
@property (nonatomic, nullable, strong) NSString *keyBenefitAreaRank;
@property (nonatomic, nullable, strong) NSArray<PRXFeaturesDetails *> *features;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
