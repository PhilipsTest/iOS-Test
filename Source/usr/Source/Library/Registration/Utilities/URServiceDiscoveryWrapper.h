//
//  URServiceDiscoveryWrapper.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 10/05/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppInfra/AppInfra.h>

@interface URServiceDiscoveryWrapper : NSObject

@property (nonatomic, strong, readonly) NSString *countryCode;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithServiceDiscovery:(id<AIServiceDiscoveryProtocol>)serviceDiscovery NS_DESIGNATED_INITIALIZER;
- (void)getHomeCountryWithCompletion:(void(^)(NSString *countryCode, NSString *locale, NSDictionary *serviceURLs, NSError *error))completion;
- (void)setHomeCountry:(NSString *)countryCode withCompletion:(void(^)(NSString *locale, NSDictionary *serviceURLs, NSError *error))completion;

@end
