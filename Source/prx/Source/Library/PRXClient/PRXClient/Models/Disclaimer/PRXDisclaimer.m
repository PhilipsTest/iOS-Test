//
//  PRXDisclaimer.m
//  PRXClient
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "PRXDisclaimer.h"
#import "PRXConstants.h"

@interface PRXDisclaimer ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PRXDisclaimer

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
        self.disclaimerText = [self objectOrNilForKey:kPRXDisclaimerText fromDictionary:dict];
        self.code = [self objectOrNilForKey:kPRXDisclaimerCode fromDictionary:dict];
        self.rank = [self objectOrNilForKey:kPRXDisclaimerRank fromDictionary:dict];
        self.referenceName = [self objectOrNilForKey:kPRXDisclaimerReferenceName fromDictionary:dict];
        self.disclaimElements = [self objectOrNilForKey:kPRXDisclaimerDisclaimElements fromDictionary:dict];
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
