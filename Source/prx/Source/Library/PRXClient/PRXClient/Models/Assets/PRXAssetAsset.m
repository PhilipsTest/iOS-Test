//
//  PRXAssetAsset.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "PRXAssetAsset.h"
#import "PRXConstants.h"



@interface PRXAssetAsset ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXAssetAsset

@synthesize locale = _locale;
@synthesize number = _number;
@synthesize extent = _extent;
@synthesize lastModified = _lastModified;
@synthesize code = _code;
@synthesize type = _type;
@synthesize assetDescription = _assetDescription;
@synthesize extension = _extension;
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
            self.locale = [self objectOrNilForKey:kPRXAssetAssetLocale fromDictionary:dict];
            self.number = [self objectOrNilForKey:kPRXAssetAssetNumber fromDictionary:dict];
            self.extent = [self objectOrNilForKey:kPRXAssetAssetExtent fromDictionary:dict];
            self.lastModified = [self objectOrNilForKey:kPRXAssetAssetLastModified fromDictionary:dict];
            self.code = [self objectOrNilForKey:kPRXAssetAssetCode fromDictionary:dict];
            self.type = [self objectOrNilForKey:kPRXAssetAssetType fromDictionary:dict];
            self.assetDescription = [self objectOrNilForKey:kPRXAssetAssetDescription fromDictionary:dict];
            self.extension = [self objectOrNilForKey:kPRXAssetAssetExtension fromDictionary:dict];
            self.asset = [self objectOrNilForKey:kPRXAssetAssetAsset fromDictionary:dict];

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
