//
//  PRXDisclaimers.m
//  PRXClient
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import "PRXDisclaimers.h"
#import "PRXDisclaimer.h"
#import "PRXConstants.h"

@implementation PRXDisclaimers

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
        NSObject *receivedPRXAssetAsset = [dict objectForKey:kPRXDisclaimer];
        NSMutableArray *parsedPRXAssetAsset = [NSMutableArray array];
        if ([receivedPRXAssetAsset isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in (NSArray *)receivedPRXAssetAsset) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedPRXAssetAsset addObject:[PRXDisclaimer modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedPRXAssetAsset isKindOfClass:[NSDictionary class]]) {
            [parsedPRXAssetAsset addObject:[PRXDisclaimer modelObjectWithDictionary:(NSDictionary *)receivedPRXAssetAsset]];
        }

        self.disclaimer = [NSArray arrayWithArray:parsedPRXAssetAsset];

    }

    return self;

}

@end
