//
//  PRXSummaryPrice.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXSummaryPrice.h"
#import "PRXConstants.h"


@interface PRXSummaryPrice ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXSummaryPrice

@synthesize formattedPrice = _formattedPrice;
@synthesize displayPriceType = _displayPriceType;
@synthesize currencyCode = _currencyCode;
@synthesize formattedDisplayPrice = _formattedDisplayPrice;
@synthesize displayPrice = _displayPrice;
@synthesize productPrice = _productPrice;


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
            self.formattedPrice = [self objectOrNilForKey:kPRXSummaryPriceFormattedPrice fromDictionary:dict];
            self.displayPriceType = [self objectOrNilForKey:kPRXSummaryPriceDisplayPriceType fromDictionary:dict];
            self.currencyCode = [self objectOrNilForKey:kPRXSummaryPriceCurrencyCode fromDictionary:dict];
            self.formattedDisplayPrice = [self objectOrNilForKey:kPRXSummaryPriceFormattedDisplayPrice fromDictionary:dict];
            self.displayPrice = [self objectOrNilForKey:kPRXSummaryPriceDisplayPrice fromDictionary:dict];
            self.productPrice = [self objectOrNilForKey:kPRXSummaryPriceProductPrice fromDictionary:dict];

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
