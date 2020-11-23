//
//  ServiceDiscoveryModel.h
//
//  Created by Ravi Kiran HR on 6/14/16
 /* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/ 

#import <Foundation/Foundation.h>
#import "AISDMatchByCountry.h"
#import "AISDMatchByLanguage.h"
#import "AIAppInfraProtocol.h"

typedef NS_ENUM(NSUInteger, AISDPreference)
{   AISDLanguagePreference =1,
    AISDCountryPreference
};

@protocol AISDModelProtocol <NSObject>
@required

-(NSString *)getServiceURLWithServiceID:(NSString *)serviceID Preference:(AISDPreference)preference;

-(NSDictionary *)getServicesWithServiceID:(NSArray *)serviceIDs Preference:(AISDPreference)preference;

-(NSString *)getLocaleWithPreference:(AISDPreference)preference;

@end

@interface AISDModel : NSObject <AISDModelProtocol>

@property (nonatomic, strong) NSString *country;

@property (nonatomic, strong) AISDMatchByLanguage *matchByLanguage;

@property (nonatomic, strong) AISDMatchByCountry *matchByCountry;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary appInfra:(id<AIAppInfraProtocol>)appInfra;

@end
