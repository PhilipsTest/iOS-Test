//
//  Configs.m
//
//  Created by Ravi Kiran HR on 6/14/16
/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "AISDConfigs.h"
#import "AISDTags.h"
#import "AIUtility.h"

NSString *const kConfigsMicrositeId = @"micrositeId";
NSString *const kConfigsTags = @"tags";
NSString *const kConfigsUrls = @"urls";



@implementation AISDConfigs

@synthesize micrositeId = _micrositeId;
@synthesize tags = _tags;
@synthesize urls = _urls;


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
        self.micrositeId = [AIUtility objectOrNilForKey:kConfigsMicrositeId fromDictionary:dict];
        self.urls = [AIUtility objectOrNilForKey:kConfigsUrls fromDictionary:dict];
        NSObject *receivedTags = dict[kConfigsTags];
        NSMutableArray *parsedTags = [NSMutableArray array];
        if ([receivedTags isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedTags) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedTags addObject:[AISDTags modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedTags isKindOfClass:[NSDictionary class]]) {
            [parsedTags addObject:[AISDTags modelObjectWithDictionary:(NSDictionary *)receivedTags]];
        }
        
        self.tags = [NSArray arrayWithArray:parsedTags];
        
        
    }
    
    return self;
    
}

@end
