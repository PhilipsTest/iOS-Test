/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXSpecificationsItemMeasure.h"
#import "PRXConstants.h"

@interface PRXSpecificationsItemMeasure ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXSpecificationsItemMeasure

@synthesize unitOfMeasureCode = _unitOfMeasureCode;
@synthesize unitOfMeasureName = _unitOfMeasureName;
@synthesize unitOfMeasureSymbol = _unitOfMeasureSymbol;

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
        self.unitOfMeasureCode = [self objectOrNilForKey:kPRXSpecificationsItemMeasureCode fromDictionary:dict];
        self.unitOfMeasureName = [self objectOrNilForKey:kPRXSpecificationsItemMeasureName fromDictionary:dict];
        self.unitOfMeasureSymbol = [self objectOrNilForKey:kPRXSpecificationsItemMeasureSymbol fromDictionary:dict];
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
