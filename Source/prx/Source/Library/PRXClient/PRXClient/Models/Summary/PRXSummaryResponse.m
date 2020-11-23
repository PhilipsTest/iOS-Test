//
//  PRXSummaryPRXResponseData.m
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import "PRXSummaryResponse.h"
#import "PRXSummaryData.h"
#import "PRXConstants.h"


@interface PRXSummaryResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXSummaryResponse

@synthesize success = _success;
@synthesize data = _data;

- (PRXResponseData *)parseResponse:(id)data
{
    return [self initWithDictionary:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.success = [[self objectOrNilForKey:kPRXSummaryPRXResponseDataSuccess fromDictionary:dict] boolValue];
        self.data = [PRXSummaryData modelObjectWithDictionary:[dict objectForKey:kPRXSummaryPRXResponseDataData]];
        
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
