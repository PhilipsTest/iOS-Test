/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import "PRXFeaturesData.h"
#import "PRXConstants.h"
#import "PRXFeaturesKeyBenefitArea.h"
#import "PRXFeaturesHighlight.h"
#import "PRXFeaturesAssetDetails.h"

@implementation PRXFeaturesData

@synthesize keyBenefitArea = _keyBenefitArea;
@synthesize featureHighlight = _featureHighlight;
@synthesize assetDetails = _assetDetails;

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
        NSObject *receivedKeyBenefitAreas = [dict objectForKey:kPRXFeaturesKeyBenefitArea];
        NSMutableArray *parsedKeyBenefitAreas = [NSMutableArray array];
        if ([receivedKeyBenefitAreas isKindOfClass:[NSArray class]]) {
            for (NSDictionary *keyBenefitArea in (NSArray *)receivedKeyBenefitAreas) {
                if ([keyBenefitArea isKindOfClass:[NSDictionary class]]) {
                    [parsedKeyBenefitAreas addObject:[PRXFeaturesKeyBenefitArea modelObjectWithDictionary:keyBenefitArea]];
                }
            }
        }
        self.keyBenefitArea = [NSArray arrayWithArray:parsedKeyBenefitAreas];
        
        NSObject *receivedFeatureHighlights = [dict objectForKey:kPRXFeaturesFeatureHighlight];
        NSMutableArray *parsedFeatureHighlights = [NSMutableArray array];
        if ([receivedFeatureHighlights isKindOfClass:[NSArray class]]) {
            for (NSDictionary *featureHighlight in (NSArray *)receivedFeatureHighlights) {
                if ([featureHighlight isKindOfClass:[NSDictionary class]]) {
                    [parsedFeatureHighlights addObject:[PRXFeaturesHighlight modelObjectWithDictionary:featureHighlight]];
                }
            }
        }
        self.featureHighlight = [NSArray arrayWithArray:parsedFeatureHighlights];
        
        NSObject *receivedFeatureAssetDetails = [dict objectForKey:kPRXFeaturesCode];
        NSMutableArray *parsedFeatureAssetDetails = [NSMutableArray array];
        if ([receivedFeatureAssetDetails isKindOfClass:[NSArray class]]) {
            for (NSDictionary *featureAssetDetail in (NSArray *)receivedFeatureAssetDetails) {
                if ([featureAssetDetail isKindOfClass:[NSDictionary class]]) {
                    [parsedFeatureAssetDetails addObject:[PRXFeaturesAssetDetails modelObjectWithDictionary:featureAssetDetail]];
                }
            }
        }
        self.assetDetails = [NSArray arrayWithArray:parsedFeatureAssetDetails];
    }
    return self;
}

@end
