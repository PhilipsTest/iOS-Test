//
//  Results.m
//
//  Created by Ravi Kiran HR on 6/14/16
 /* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/ 

#import "AISDResults.h"
#import "AISDConfigs.h"
#import "AIUtility.h"

NSString *const kResultsLocale = @"locale";
NSString *const kResultsConfigs = @"configs";



@implementation AISDResults

@synthesize locale = _locale;
@synthesize configs = _configs;


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
            self.locale = [AIUtility objectOrNilForKey:kResultsLocale fromDictionary:dict];
    NSObject *receivedConfigs = [dict objectForKey:kResultsConfigs];
    NSMutableArray *parsedConfigs = [NSMutableArray array];
    if ([receivedConfigs isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedConfigs) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedConfigs addObject:[AISDConfigs modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedConfigs isKindOfClass:[NSDictionary class]]) {
       [parsedConfigs addObject:[AISDConfigs modelObjectWithDictionary:(NSDictionary *)receivedConfigs]];
    }

    self.configs = [NSArray arrayWithArray:parsedConfigs];

    }
    
    return self;
    
}

@end
