//
//  PRXAssetAssets.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PRXAssetAssets : NSObject

@property (nonatomic, strong) NSArray *asset;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
