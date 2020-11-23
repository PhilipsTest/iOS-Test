//
//  PRXSummaryPrice.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRXSummaryPrice : NSObject

@property (nonatomic, strong) NSString *formattedPrice;
@property (nonatomic, strong) NSString *displayPriceType;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *formattedDisplayPrice;
@property (nonatomic, strong) NSString *displayPrice;
@property (nonatomic, strong) NSString *productPrice;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
