/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRXSpecificationsItemMeasure : NSObject

@property (nonatomic, strong) NSString *unitOfMeasureCode;
@property (nonatomic, strong) NSString *unitOfMeasureName;
@property (nonatomic, strong) NSString *unitOfMeasureSymbol;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
