//
//  PRXSummaryData.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXSummaryData.h"
#import "PRXSummaryBrand.h"
#import "PRXSummaryPrice.h"
#import "PRXConstants.h"



@interface PRXSummaryData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXSummaryData

@synthesize productStatus = _productStatus;
@synthesize isDeleted = _isDeleted;
@synthesize leafletUrl = _leafletUrl;
@synthesize familyName = _familyName;
@synthesize alphanumeric = _alphanumeric;
@synthesize productPagePath = _productPagePath;
@synthesize descriptor = _descriptor;
@synthesize brand = _brand;
@synthesize ctn = _ctn;
@synthesize productTitle = _productTitle;
@synthesize subWOW = _subWOW;
@synthesize locale = _locale;
@synthesize wow = _wow;
@synthesize imageURL = _imageURL;
@synthesize brandName = _brandName;
@synthesize domain = _domain;
@synthesize priority = _priority;
@synthesize subcategory = _subcategory;
@synthesize productURL = _productURL;
@synthesize versions = _versions;
@synthesize sop = _sop;
@synthesize careSop = _careSop;
@synthesize marketingTextHeader = _marketingTextHeader;
@synthesize somp = _somp;
@synthesize eop = _eop;
@synthesize dtn = _dtn;
@synthesize price = _price;
@synthesize filterKeys = _filterKeys;


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
            self.productStatus = [self objectOrNilForKey:kPRXSummaryDataProductStatus fromDictionary:dict];
            self.isDeleted = [[self objectOrNilForKey:kPRXSummaryDataIsDeleted fromDictionary:dict] boolValue];
            self.leafletUrl = [self objectOrNilForKey:kPRXSummaryDataLeafletUrl fromDictionary:dict];
            self.familyName = [self objectOrNilForKey:kPRXSummaryDataFamilyName fromDictionary:dict];
            self.alphanumeric = [self objectOrNilForKey:kPRXSummaryDataAlphanumeric fromDictionary:dict];
            self.productPagePath = [self objectOrNilForKey:kPRXSummaryDataProductPagePath fromDictionary:dict];
            self.descriptor = [self objectOrNilForKey:kPRXSummaryDataDescriptor fromDictionary:dict];
            self.brand = [PRXSummaryBrand modelObjectWithDictionary:[dict objectForKey:kPRXSummaryDataBrand]];
            self.ctn = [self objectOrNilForKey:kPRXSummaryDataCtn fromDictionary:dict];
            self.productTitle = [self objectOrNilForKey:kPRXSummaryDataProductTitle fromDictionary:dict];
            self.subWOW = [self objectOrNilForKey:kPRXSummaryDataSubWOW fromDictionary:dict];
            self.locale = [self objectOrNilForKey:kPRXSummaryDataLocale fromDictionary:dict];
            self.wow = [self objectOrNilForKey:kPRXSummaryDataWow fromDictionary:dict];
            self.imageURL = [self objectOrNilForKey:kPRXSummaryDataImageURL fromDictionary:dict];
            self.brandName = [self objectOrNilForKey:kPRXSummaryDataBrandName fromDictionary:dict];
            self.domain = [self objectOrNilForKey:kPRXSummaryDataDomain fromDictionary:dict];
            self.priority = [[self objectOrNilForKey:kPRXSummaryDataPriority fromDictionary:dict] doubleValue];
            self.subcategory = [self objectOrNilForKey:kPRXSummaryDataSubcategory fromDictionary:dict];
            self.productURL = [self objectOrNilForKey:kPRXSummaryDataProductURL fromDictionary:dict];
            self.versions = [self objectOrNilForKey:kPRXSummaryDataVersions fromDictionary:dict];
            self.sop = [self objectOrNilForKey:kPRXSummaryDataSop fromDictionary:dict];
            self.careSop = [self objectOrNilForKey:kPRXSummaryDataCareSop fromDictionary:dict];
            self.marketingTextHeader = [self objectOrNilForKey:kPRXSummaryDataMarketingTextHeader fromDictionary:dict];
            self.somp = [self objectOrNilForKey:kPRXSummaryDataSomp fromDictionary:dict];
            self.eop = [self objectOrNilForKey:kPRXSummaryDataEop fromDictionary:dict];
            self.dtn = [self objectOrNilForKey:kPRXSummaryDataDtn fromDictionary:dict];
            self.price = [PRXSummaryPrice modelObjectWithDictionary:[dict objectForKey:kPRXSummaryDataPrice]];
            self.filterKeys = [self objectOrNilForKey:kPRXSummaryDataFilterKeys fromDictionary:dict];

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
