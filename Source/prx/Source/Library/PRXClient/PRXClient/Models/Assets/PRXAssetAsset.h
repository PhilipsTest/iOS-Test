//
//  PRXAssetAsset.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PRXAssetAsset : NSObject

@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *extent;
@property (nonatomic, strong) NSString *lastModified;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *assetDescription;
@property (nonatomic, strong) NSString *extension;
@property (nonatomic, strong) NSString *asset;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
