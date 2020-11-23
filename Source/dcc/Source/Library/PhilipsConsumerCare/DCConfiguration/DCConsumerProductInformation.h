//
//  DCConsumerProductInformation.h
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 10/02/16.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
#import <PhilipsPRXClient/PRXSummaryData.h>
#import <PhilipsPRXClient/PRXRequestEnums.h>

@interface DCConsumerProductInformation : NSObject

@property (nonatomic, assign)    Sector productSector;
@property (nonatomic, assign)    Catalog productCatalog;
@property (nonatomic, strong)    NSString *productCTN;
@property (nonatomic, strong)    NSString *productTitle;
@property (nonatomic, strong)    NSString *productLocale;
@property (nonatomic, strong)    NSString *productGroup;
@property (nonatomic, strong)    NSString *productCategory;
@property (nonatomic, strong)    NSString *productSubCategory;
@property (nonatomic, strong)    NSString *productReviewURL;
@property (nonatomic, strong)    NSString *productDomain;
@property (nonatomic, strong)    NSString *productImageURL;
@property (assign) BOOL success;
@property (nonatomic, retain) NSString *displayMessage;
@property (nonatomic, retain) NSString *exceptionMessage;
@property (assign) NSInteger responseCode;

-(id) initWithSummaryData:(PRXSummaryData *)productSummary withSector:(Sector)sector withCatalog:(Catalog)catalog;

@end
