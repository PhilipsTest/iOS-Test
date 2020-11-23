//
//  PRXAssetData.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRXAssetAssets;

@interface PRXAssetData : NSObject

@property (nonatomic, strong) PRXAssetAssets *assets;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
