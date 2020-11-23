/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXSpecificationsItemValue.h"
#import "PRXConstants.h"

@interface PRXSpecificationsItemValue()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXSpecificationsItemValue

@synthesize valueCode = _valueCode;
@synthesize valueName = _valueName;
@synthesize valueRank = _valueRank;

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
        self.valueCode = [self objectOrNilForKey:kPRXSpecificationsItemValueCode fromDictionary:dict];
        self.valueName = [self objectOrNilForKey:kPRXSpecificationsItemValueName fromDictionary:dict];
        self.valueRank = [self objectOrNilForKey:kPRXSpecificationsItemValueRank fromDictionary:dict];
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
