//
//  PRXFaqRichText.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXFaqRichText.h"
#import "PRXFaqChapter.h"
#import "PRXFaqItem.h"
#import "PRXConstants.h"

@interface PRXFaqRichText ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXFaqRichText

@synthesize supportType = _supportType;
@synthesize chapter = _chapter;
@synthesize questionList = _questionList;


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
            self.supportType = [self objectOrNilForKey:kPRXFaqRichTextType fromDictionary:dict];
            self.chapter = [PRXFaqChapter modelObjectWithDictionary:[dict objectForKey:kPRXFaqRichTextChapter]];
    NSObject *receivedPRXFaqItem = [dict objectForKey:kPRXFaqRichTextItem];
    NSMutableArray *parsedPRXFaqItem = [NSMutableArray array];
    if ([receivedPRXFaqItem isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedPRXFaqItem) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedPRXFaqItem addObject:[PRXFaqItem modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedPRXFaqItem isKindOfClass:[NSDictionary class]]) {
       [parsedPRXFaqItem addObject:[PRXFaqItem modelObjectWithDictionary:(NSDictionary *)receivedPRXFaqItem]];
    }
    self.questionList = [NSArray arrayWithArray:parsedPRXFaqItem];
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
