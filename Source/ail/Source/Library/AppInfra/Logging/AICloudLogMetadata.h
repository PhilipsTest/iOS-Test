//
//  AICloudLogMetadata.h
//  AppInfra
//
//  Created by Hashim MH on 30/04/18.
//  Copyright © 2018 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol AIAppInfraProtocol;
@interface AICloudLogMetadata : NSObject
typedef NS_ENUM(NSUInteger, AIAIAppState);
- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra;

@property(nonatomic,strong,readonly)NSString *appId;
@property(nonatomic,strong,readonly)NSString *appName;
@property(nonatomic,strong,readonly)NSString *appState;
@property(nonatomic,strong,readonly)NSString *appVersion;
@property(nonatomic,strong,readonly)NSString *homeCountry;
@property(nonatomic,strong,readonly)NSString *locale;
@property(nonatomic,strong,readonly)NSString *networkType;

-(void)updateInfo;
-(void)updateHomeCountry;
-(void)updateNetworkType;
@end
