/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRXFeaturesAssetDetails : NSObject

@property (nonatomic, nullable, strong) NSString *featureCode;
@property (nonatomic, nullable, strong) NSString *featureDescription;
@property (nonatomic, nullable, strong) NSString *extension;
@property (nonatomic, nullable, strong) NSString *extent;
@property (nonatomic, nullable, strong) NSString *lastModified;
@property (nonatomic, nullable, strong) NSString *locale;
@property (nonatomic, nullable, strong) NSString *number;
@property (nonatomic, nullable, strong) NSString *type;
@property (nonatomic, nullable, strong) NSString *asset;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
