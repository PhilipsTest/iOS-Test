//
//  AISDMatchByObject.m
//
//  Created by Ravi Kiran HR on 6/14/16
 /* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/ 

#import "AISDMatchByCountry.h"
#import "AISDResults.h"
#import "AISDMatchByObject.h"
#import "AIUtility.h"

NSString *const kMatchByCountryResults = @"results";
NSString *const kMatchByCountryAvailable = @"available";



@implementation AISDMatchByCountry

@synthesize results = _results;
@synthesize available = _available;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedResults = [dict objectForKey:kMatchByCountryResults];

    self.results = [NSArray arrayWithArray:[AISDMatchByObject getMatchingObjects:receivedResults]];
            self.available = [[AIUtility objectOrNilForKey:kMatchByCountryAvailable fromDictionary:dict] boolValue];

    }
    return self;
}

@end
