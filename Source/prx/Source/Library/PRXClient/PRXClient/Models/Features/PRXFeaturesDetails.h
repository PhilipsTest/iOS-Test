/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRXFeaturesDetails : NSObject

@property (nonatomic, nullable, strong) NSString *featureCode;
@property (nonatomic, nullable, strong) NSString *featureReferenceName;
@property (nonatomic, nullable, strong) NSString *featureName;
@property (nonatomic, nullable, strong) NSString *featureLongDescription;
@property (nonatomic, nullable, strong) NSString *featureGlossary;
@property (nonatomic, nullable, strong) NSString *featureRank;
@property (nonatomic, nullable, strong) NSString *featureTopRank;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
