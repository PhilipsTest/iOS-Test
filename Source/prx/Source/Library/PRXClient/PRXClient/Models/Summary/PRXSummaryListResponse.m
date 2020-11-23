/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXSummaryListResponse.h"
#import "PRXFaqData.h"
#import "PRXConstants.h"
#import "PRXSummaryData.h"

@interface PRXSummaryListResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXSummaryListResponse

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
        NSMutableArray *summaryList = [NSMutableArray new];
        for (NSDictionary *summary in [dict objectForKey:kPRXSummaryPRXResponseDataData]) {
            [summaryList addObject:[PRXSummaryData modelObjectWithDictionary:summary]];
        }
        self.data = summaryList;
        self.invalidCTNs = [dict objectForKey:kPRXSummaryInvalidCTNs];
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
