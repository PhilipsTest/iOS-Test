//
//  PRXAssetAssets.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "PRXAssetAssets.h"
#import "PRXAssetAsset.h"
#import "PRXConstants.h"


@implementation PRXAssetAssets

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
    NSObject *receivedPRXAssetAsset = [dict objectForKey:kPRXAssetAssetsAsset];
    NSMutableArray *parsedPRXAssetAsset = [NSMutableArray array];
    if ([receivedPRXAssetAsset isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedPRXAssetAsset) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedPRXAssetAsset addObject:[PRXAssetAsset modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedPRXAssetAsset isKindOfClass:[NSDictionary class]]) {
       [parsedPRXAssetAsset addObject:[PRXAssetAsset modelObjectWithDictionary:(NSDictionary *)receivedPRXAssetAsset]];
    }

    self.asset = [NSArray arrayWithArray:parsedPRXAssetAsset];

    }
    
    return self;
    
}

@end
