/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXFeaturesKeyBenefitArea.h"
#import "PRXConstants.h"
#import "PRXFeaturesDetails.h"

@interface PRXFeaturesKeyBenefitArea ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXFeaturesKeyBenefitArea

@synthesize keyBenefitAreaCode = _keyBenefitAreaCode;
@synthesize keyBenefitAreaName = _keyBenefitAreaName;
@synthesize keyBenefitAreaRank = _keyBenefitAreaRank;
@synthesize features = _features;

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
        self.keyBenefitAreaCode = [self objectOrNilForKey:kPRXFeaturesKeyBenefitAreaCode fromDictionary:dict];
        self.keyBenefitAreaName = [self objectOrNilForKey:kPRXFeaturesKeyBenefitAreaName fromDictionary:dict];
        self.keyBenefitAreaRank = [self objectOrNilForKey:kPRXFeaturesKeyBenefitAreaRank fromDictionary:dict];
        NSObject *receivedFeatures = [dict objectForKey:kPRXFeaturesFeature];
        NSMutableArray *parsedFeatures = [NSMutableArray array];
        if ([receivedFeatures isKindOfClass:[NSArray class]]) {
            for (NSDictionary *featureValue in (NSArray *)receivedFeatures) {
                if ([featureValue isKindOfClass:[NSDictionary class]]) {
                    [parsedFeatures addObject:[PRXFeaturesDetails modelObjectWithDictionary:featureValue]];
                }
            }
        }
        self.features = [NSArray arrayWithArray:parsedFeatures];
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
