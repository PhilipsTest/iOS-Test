//
//  DCConsumerProductInformation.m
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 10/02/16.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCConsumerProductInformation.h"

@implementation DCConsumerProductInformation

-(id) initWithSummaryData:(PRXSummaryData *)productSummary withSector:(Sector)sector withCatalog:(Catalog)catalog
{
    if (self = [super init]) {
        _productSector=sector;
        _productCatalog=catalog;
        _productCTN=productSummary.ctn;
        _productTitle=productSummary.productTitle;
        _productLocale=productSummary.locale;
        _productReviewURL=productSummary.productURL;
        _productDomain=productSummary.domain;
        _productImageURL=productSummary.imageURL;
        _productSubCategory=productSummary.subcategory;

    }
    return self;
}
@end
