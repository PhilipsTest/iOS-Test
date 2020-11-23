//
//  PRXFaqChapter.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import "PRXFaqChapter.h"
#import "PRXConstants.h"

@interface PRXFaqChapter ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXFaqChapter

@synthesize referenceName = _referenceName;
@synthesize code = _code;
@synthesize name = _name;
@synthesize rank = _rank;


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
            self.referenceName = [self objectOrNilForKey:kPRXFaqChapterReferenceName fromDictionary:dict];
            self.code = [self objectOrNilForKey:kPRXFaqChapterCode fromDictionary:dict];
            self.name = [self objectOrNilForKey:kPRXFaqChapterName fromDictionary:dict];
            self.rank = [self objectOrNilForKey:kPRXFaqChapterRank fromDictionary:dict];

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
