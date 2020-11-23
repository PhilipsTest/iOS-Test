/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXSpecificationsItem.h"
#import "PRXSpecificationsItemValue.h"
#import "PRXSpecificationsItemMeasure.h"
#import "PRXConstants.h"

@interface PRXSpecificationsItem ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXSpecificationsItem

@synthesize itemCode = _itemCode;
@synthesize itemName = _itemName;
@synthesize itemRank = _itemRank;
@synthesize itemIsFreeFormat = _itemIsFreeFormat;
@synthesize itemValues = _itemValues;
@synthesize itemUnitOfMeasure = _itemUnitOfMeasure;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.itemCode = [self objectOrNilForKey:kPRXSpecificationsItemCode fromDictionary:dict];
        self.itemName = [self objectOrNilForKey:kPRXSpecificationsItemName fromDictionary:dict];
        self.itemRank = [self objectOrNilForKey:kPRXSpecificationsItemRank fromDictionary:dict];
        self.itemIsFreeFormat = [self objectOrNilForKey:kPRXSpecificationsItemIsFreeFormat fromDictionary:dict];
        NSObject *receivedSpecificationItemValues = [dict objectForKey:kPRXSpecificationsItemValue];
        NSMutableArray *parsedSpecificationItemValues = [NSMutableArray array];
        if ([receivedSpecificationItemValues isKindOfClass:[NSArray class]]) {
            for (NSDictionary *itemValue in (NSArray *)receivedSpecificationItemValues) {
                if ([itemValue isKindOfClass:[NSDictionary class]]) {
                    [parsedSpecificationItemValues addObject:[PRXSpecificationsItemValue modelObjectWithDictionary:itemValue]];
                }
            }
        }
        self.itemValues = [NSArray arrayWithArray:parsedSpecificationItemValues];
        self.itemUnitOfMeasure = [PRXSpecificationsItemMeasure modelObjectWithDictionary:[dict objectForKey:kPRXSpecificationsItemMeasure]];
    }
    return self;
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
