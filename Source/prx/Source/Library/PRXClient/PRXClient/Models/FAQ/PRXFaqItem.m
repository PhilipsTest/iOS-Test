//
//  PRXFaqItem.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXFaqItem.h"
#import "PRXConstants.h"



@interface PRXFaqItem ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXFaqItem

@synthesize code = _code;
@synthesize asset = _asset;
@synthesize lang = _lang;
@synthesize rank = _rank;
@synthesize head = _head;


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
            self.code = [self objectOrNilForKey:kPRXFaqItemCode fromDictionary:dict];
            self.asset = [self objectOrNilForKey:kPRXFaqItemAsset fromDictionary:dict];
            self.lang = [self objectOrNilForKey:kPRXFaqItemLang fromDictionary:dict];
            self.rank = [self objectOrNilForKey:kPRXFaqItemRank fromDictionary:dict];
            self.head = [self objectOrNilForKey:kPRXFaqItemHead fromDictionary:dict];

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
