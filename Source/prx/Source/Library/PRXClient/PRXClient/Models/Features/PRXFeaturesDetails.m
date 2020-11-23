/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXFeaturesDetails.h"
#import "PRXConstants.h"

@interface PRXFeaturesDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXFeaturesDetails

@synthesize featureCode = _featureCode;
@synthesize featureReferenceName = _featureReferenceName;
@synthesize featureName = _featureName;
@synthesize featureLongDescription = _featureLongDescription;
@synthesize featureGlossary = _featureGlossary;
@synthesize featureRank = _featureRank;
@synthesize featureTopRank = _featureTopRank;

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
        self.featureCode = [self objectOrNilForKey:kPRXFeaturesFeatureCode fromDictionary:dict];
        self.featureReferenceName = [self objectOrNilForKey:kPRXFeaturesFeatureReferenceName fromDictionary:dict];
        self.featureName = [self objectOrNilForKey:kPRXFeaturesFeatureName fromDictionary:dict];
        self.featureLongDescription = [self objectOrNilForKey:kPRXFeaturesFeatureLongDescription fromDictionary:dict];
        self.featureGlossary = [self objectOrNilForKey:kPRXFeaturesFeatureGlossary fromDictionary:dict];
        self.featureRank = [self objectOrNilForKey:kPRXFeaturesFeatureRank fromDictionary:dict];
        self.featureTopRank = [self objectOrNilForKey:kPRXFeaturesFeatureTopRank fromDictionary:dict];
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
