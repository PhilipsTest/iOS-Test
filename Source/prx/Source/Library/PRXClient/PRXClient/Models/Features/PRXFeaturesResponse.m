/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXFeaturesResponse.h"
#import "PRXConstants.h"
#import "PRXFeaturesData.h"

@interface PRXFeaturesResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXFeaturesResponse

@synthesize success = _success;
@synthesize data = _data;

- (PRXResponseData *)parseResponse:(id)data
{
    return [self initWithDictionary:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.success = [[self objectOrNilForKey:kPRXSummaryPRXResponseDataSuccess fromDictionary:dict] boolValue];
        self.data = [PRXFeaturesData modelObjectWithDictionary:[dict objectForKey:kPRXFeaturesBaseClassData]];
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
