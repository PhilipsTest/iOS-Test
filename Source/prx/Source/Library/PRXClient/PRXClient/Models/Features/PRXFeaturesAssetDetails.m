/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXFeaturesAssetDetails.h"
#import "PRXConstants.h"

@interface PRXFeaturesAssetDetails ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXFeaturesAssetDetails

@synthesize featureCode = _featureCode;
@synthesize featureDescription = _featureDescription;
@synthesize extension = _extension;
@synthesize extent = _extent;
@synthesize lastModified = _lastModified;
@synthesize locale = _locale;
@synthesize number = _number;
@synthesize type = _type;
@synthesize asset = _asset;

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
        self.featureCode = [self objectOrNilForKey:kPRXFeaturesCode fromDictionary:dict];
        self.featureDescription = [self objectOrNilForKey:kPRXFeaturesDescription fromDictionary:dict];
        self.extension = [self objectOrNilForKey:kPRXFeaturesExtension fromDictionary:dict];
        self.extent = [self objectOrNilForKey:kPRXFeaturesExtent fromDictionary:dict];
        self.lastModified = [self objectOrNilForKey:kPRXFeaturesLastModified fromDictionary:dict];
        self.locale = [self objectOrNilForKey:kPRXFeaturesLocale fromDictionary:dict];
        self.number = [self objectOrNilForKey:kPRXFeaturesNumber fromDictionary:dict];
        self.type = [self objectOrNilForKey:kPRXFeaturesType fromDictionary:dict];
        self.asset = [self objectOrNilForKey:kPRXFeaturesAsset fromDictionary:dict];
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
