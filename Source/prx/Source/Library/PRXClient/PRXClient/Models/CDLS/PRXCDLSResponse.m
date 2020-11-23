/* Copyright (c) Koninklijke Philips N.V., 2020
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */


#import "PRXCDLSResponse.h"
#import "PRXConstants.h"
#import "PRXCDLSData.h"

@interface PRXCDLSResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXCDLSResponse

- (PRXResponseData *)parseResponse:(id)data {
    return [self initWithDictionary:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.success = [[self objectOrNilForKey:kPRXSummaryPRXResponseDataSuccess fromDictionary:dict] boolValue];
        self.data = [PRXCDLSData modelObjectWithDictionary:[dict objectForKey:kPRXFeaturesBaseClassData]];
    }
    return self;
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
