//
//  PRXDisclaimerData.m
//  PRXClient
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "PRXDisclaimerData.h"
#import "PRXDisclaimers.h"
#import "PRXConstants.h"

@implementation PRXDisclaimerData

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
        self.disclaimers = [PRXDisclaimers modelObjectWithDictionary:[dict objectForKey:kPRXDisclaimers]];
    }
    return self;
}

@end
