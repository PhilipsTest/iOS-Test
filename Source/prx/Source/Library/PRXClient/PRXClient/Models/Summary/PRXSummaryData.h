//
//  PRXSummaryData.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRXSummaryBrand, PRXSummaryPrice;

@interface PRXSummaryData : NSObject

@property (nonatomic, strong) NSString *productStatus;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, strong) NSString *leafletUrl;
@property (nonatomic, strong) NSString *familyName;
@property (nonatomic, strong) NSString *alphanumeric;
@property (nonatomic, strong) NSString *productPagePath;
@property (nonatomic, strong) NSString *descriptor;
@property (nonatomic, strong) PRXSummaryBrand *brand;
@property (nonatomic, strong) NSString *ctn;
@property (nonatomic, strong) NSString *productTitle;
@property (nonatomic, strong) NSString *subWOW;
@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *wow;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, assign) double priority;
@property (nonatomic, strong) NSString *subcategory;
@property (nonatomic, strong) NSString *productURL;
@property (nonatomic, strong) NSArray *versions;
@property (nonatomic, strong) NSString *sop;
@property (nonatomic, strong) NSString *careSop;
@property (nonatomic, strong) NSString *marketingTextHeader;
@property (nonatomic, strong) NSString *somp;
@property (nonatomic, strong) NSString *eop;
@property (nonatomic, strong) NSString *dtn;
@property (nonatomic, strong) PRXSummaryPrice *price;
@property (nonatomic, strong) NSArray *filterKeys;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
