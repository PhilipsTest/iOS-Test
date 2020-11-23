//
//  PRXAssetData.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "PRXAssetData.h"
#import "PRXAssetAssets.h"
#import "PRXConstants.h"

@implementation PRXAssetData

@synthesize assets = _assets;


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
            self.assets = [PRXAssetAssets modelObjectWithDictionary:[dict objectForKey:kPRXAssetDataAssets]];

    }
    
    return self;
    
}

@end
