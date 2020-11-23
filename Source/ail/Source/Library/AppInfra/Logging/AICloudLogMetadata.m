//
//  AICloudLogMetadata.m
//  AppInfra
//
//  Created by Hashim MH on 30/04/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import "AICloudLogMetadata.h"
#import "AILogUtilities.h"
#import "AppInfra.h"

@interface AICloudLogMetadata()
@property(nonatomic,weak)id<AIAppInfraProtocol> appInfra;
@end

@implementation AICloudLogMetadata
@synthesize homeCountry = _homeCountry;
- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.appInfra = appInfra;
    }
    return self;
}

-(void)updateInfo{
    
    _appId = [self.appInfra.tagging getTrackingIdentifier] ? [self.appInfra.tagging getTrackingIdentifier]:@"NA";
    _appName = [self.appInfra.appIdentity getAppName]?[self.appInfra.appIdentity getAppName]:@"";
    _appState = [AILogUtilities stateString:[self.appInfra.appIdentity getAppState]];
    _appVersion = [self.appInfra.appIdentity getAppVersion]?[self.appInfra.appIdentity getAppVersion]:@"NA";
    _locale = [self.appInfra.internationalization getUILocaleString]?[self.appInfra.internationalization getUILocaleString]: @"";

    _homeCountry = [self.appInfra.serviceDiscovery getHomeCountry]?[self.appInfra.serviceDiscovery getHomeCountry]:@"";
    _networkType = [AILogUtilities networkTypeFromRESTClient:self.appInfra.RESTClient];

}

-(NSString*)homeCountry{
    if (!_homeCountry || _homeCountry.length == 0) {
      _homeCountry = [self.appInfra.serviceDiscovery getHomeCountry]?[self.appInfra.serviceDiscovery getHomeCountry]:@"";
    }
    return _homeCountry;
}

-(void)updateHomeCountry{
    _homeCountry = [self.appInfra.serviceDiscovery getHomeCountry]?[self.appInfra.serviceDiscovery getHomeCountry]:@"";
}

-(void)updateNetworkType{
      _networkType = [AILogUtilities networkTypeFromRESTClient:self.appInfra.RESTClient];
}


@end
