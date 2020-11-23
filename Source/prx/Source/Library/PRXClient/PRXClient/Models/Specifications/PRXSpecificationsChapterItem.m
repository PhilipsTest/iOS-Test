/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXSpecificationsChapterItem.h"
#import "PRXConstants.h"
#import "PRXSpecificationsResponse.h"
#import "PRXSpecificationsItem.h"

@interface PRXSpecificationsChapterItem ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXSpecificationsChapterItem

@synthesize chapterCode = _chapterCode;
@synthesize chapterName = _chapterName;
@synthesize chapterRank = _chapterRank;
@synthesize items = _items;

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
        self.chapterCode = [self objectOrNilForKey:kPRXSpecificationsChapterCode fromDictionary:dict];
        self.chapterName = [self objectOrNilForKey:kPRXSpecificationsChapterName fromDictionary:dict];
        self.chapterRank = [self objectOrNilForKey:kPRXSpecificationsChapterRank fromDictionary:dict];
        NSObject *receivedSpecificationItems = [dict objectForKey:kPRXSpecificationsItem];
        NSMutableArray *parsedSpecificationItems = [NSMutableArray array];
        if ([receivedSpecificationItems isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedSpecificationItems) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedSpecificationItems addObject:[PRXSpecificationsItem modelObjectWithDictionary:item]];
                }
            }
        }
        self.items = [NSArray arrayWithArray:parsedSpecificationItems];
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
