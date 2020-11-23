//
//  PRXFaqRichTexts.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXFaqRichTexts.h"
#import "PRXFaqRichText.h"
#import "PRXConstants.h"

@implementation PRXFaqRichTexts

@synthesize richText = _richText;


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
    NSObject *receivedPRXFaqRichText = [dict objectForKey:kPRXFaqRichTextsRichText];
    NSMutableArray *parsedPRXFaqRichText = [NSMutableArray array];
    if ([receivedPRXFaqRichText isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedPRXFaqRichText) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedPRXFaqRichText addObject:[PRXFaqRichText modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedPRXFaqRichText isKindOfClass:[NSDictionary class]]) {
       [parsedPRXFaqRichText addObject:[PRXFaqRichText modelObjectWithDictionary:(NSDictionary *)receivedPRXFaqRichText]];
    }

    self.richText = [NSArray arrayWithArray:parsedPRXFaqRichText];

    }
    
    return self;
    
}

@end
