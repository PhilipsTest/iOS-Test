/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PRXSpecificationsItemMeasure;

@interface PRXSpecificationsItem : NSObject

@property (nonatomic, strong) NSString *itemCode;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *itemRank;
@property (nonatomic, strong) NSString *itemIsFreeFormat;
@property (nonatomic, strong) NSArray *itemValues;
@property (nonatomic, strong, nullable) PRXSpecificationsItemMeasure *itemUnitOfMeasure;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
