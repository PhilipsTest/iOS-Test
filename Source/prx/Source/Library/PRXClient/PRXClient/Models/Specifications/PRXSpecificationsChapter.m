/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXSpecificationsChapter.h"
#import "PRXConstants.h"
#import "PRXSpecificationsChapterItem.h"

@implementation PRXSpecificationsChapter

@synthesize chapters = _chapters;

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
        NSObject *receivedSpecificationChapters = [dict objectForKey:kPRXSpecificationsChapter];
        NSMutableArray *parsedSpecifications = [NSMutableArray array];
        if ([receivedSpecificationChapters isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedSpecificationChapters) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedSpecifications addObject:[PRXSpecificationsChapterItem modelObjectWithDictionary:item]];
                }
            }
        }
        self.chapters = [NSArray arrayWithArray:parsedSpecifications];
    }
    return self;
}

@end
