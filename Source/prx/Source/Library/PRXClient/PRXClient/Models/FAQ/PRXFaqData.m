//
//  PRXFaqData.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXFaqData.h"
#import "PRXFaqRichTexts.h"
#import "PRXConstants.h"

@implementation PRXFaqData

@synthesize richTexts = _richTexts;


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
        self.richTexts = [PRXFaqRichTexts modelObjectWithDictionary:[dict objectForKey:kPRXFaqDataRichTexts]];
        
    }
    
    return self;
    
}

@end
