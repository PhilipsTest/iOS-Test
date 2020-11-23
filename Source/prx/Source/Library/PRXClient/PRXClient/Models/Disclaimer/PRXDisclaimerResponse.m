//
//  PRXDisclaimerResponse.m
//  PRXClient
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "PRXDisclaimerResponse.h"
#import "PRXDisclaimerData.h"
#import "PRXConstants.h"


@interface PRXDisclaimerResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXDisclaimerResponse

- (PRXResponseData *)parseResponse:(id)data {
    return [self initWithDictionary:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.success = [[self objectOrNilForKey:kPRXDisclaimerBaseClassSuccess fromDictionary:dict] boolValue];
        self.data = [PRXDisclaimerData modelObjectWithDictionary:[dict objectForKey:kPRXDisclaimerBaseClassData]];
    }
    return self;
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict {

    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end
