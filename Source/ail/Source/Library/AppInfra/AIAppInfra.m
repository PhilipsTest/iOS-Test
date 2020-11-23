//
//  AIAppInfra.m
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import "AIAppInfra.h"
#import "AILoggingProtocol.h"
#import "AICloudLoggingProtocol.h"
#import "AIAppTaggingProtocol.h"
#import "AILogging.h"
#import "AIAppTagging.h"
#import "AIStorageProvider.h"
#import "AIServiceDiscovery.h"
#import "AITimeProtocol.h"
#import "AIAppConfiguration.h"
#import "AIRESTClientInterface.h"
#import "AIABTest.h"
#import "AILanguagePack.h"
#import "AIUtility.h"
#import <AppInfra/AppInfra-Swift.h>
#import "AIInternalTaggingUtility.h"
#import "AIInternalLogger.h"

NSString * const InfraComponentsInitialisationCompleteNotification = @"ail.componentInitialisationComplete";

#define AppInfraAcronym @"ail"

@interface AIAppInfra()
@property (nonatomic,strong) id<AIAppTaggingProtocol> appInfraTagging;
@property (nonatomic,strong) id<AILoggingProtocol> appInfraLogger;
@end

@implementation AIAppInfra

@synthesize logging,tagging,storageProvider,internationalization,RESTClient,serviceDiscovery,appIdentity,appConfig,time,abtest,languagePack,appUpdate,consentManager,deviceHandler,cloudLogging;

+ (instancetype)buildAppInfraWithBlock:(void(^)(AIAppInfraBuilder *builder))buildBlock {
    AIAppInfraBuilder *builder = [[AIAppInfraBuilder alloc] init];
    if (buildBlock)
        buildBlock(builder);
    
    return [builder build];
}


-(instancetype)initWithBuilder:(AIAppInfraBuilder *)builder {
    NSDate *startTime = [NSDate date];
    self = [super init];
    if (self) {
        
        // fetch version and name of appInfra framework
        NSDictionary *appInfraInfoPlist = [[NSBundle bundleForClass:[AIAppInfra class]] infoDictionary];
        self.appVersion = [appInfraInfoPlist objectForKey:@"CFBundleShortVersionString"];
        self.appName = AppInfraAcronym;
        
        // allocate time instance
        if (builder.time)
            self.time = builder.time;
        else{
            self.time = [[AINetworkTime alloc] init];
        }
        
        // allocate storageProvider instance
        if (builder.storageProvider)
            self.storageProvider = builder.storageProvider;
        else
            self.storageProvider = [[AISSSecureStorage alloc] init];
        
        // allocate App Configuration instance
        if (builder.appConfig)
            self.appConfig = builder.appConfig;
        else
            self.appConfig = [[AIAppConfiguration alloc] initWithAppInfra:self];
        
        // allocate logging instance
        if (builder.logging){
            self.logging = builder.logging;
            self.cloudLogging = builder.cloudLogging;
        }
        else
        {
            self.logging = [[AILogging alloc] initWithAppInfra:self];
            self.cloudLogging = (id<AICloudLoggingProtocol>)self.logging;
            self.appInfraLogger = [self.logging createInstanceForComponent:self.appName
                                                          componentVersion:self.appVersion];
            
            AIInternalLogger.appInfraLogger = self.appInfraLogger;
        }
        
        
        // allocate tagging instance
        if (builder.tagging)
            self.tagging = builder.tagging;
        else
        {
            self.tagging = [[AIAppTagging alloc] initWithAppInfra:self];
            self.appInfraTagging = [self.tagging createInstanceForComponent:self.appName
                                                           componentVersion:self.appVersion];
            [AIInternalTaggingUtility setSharedTagging:self.appInfraTagging];
        }
        
        
        // allocate appIdentity instance
        if (builder.appIdentity)
            self.appIdentity = builder.appIdentity;
        else
            self.appIdentity = [[AIAppIdentityInterface alloc] initWithAppInfra:self];
        
        // allocate serviceDiscovey instance
        if (builder.serviceDiscovery)
            self.serviceDiscovery = builder.serviceDiscovery;
        else
            self.serviceDiscovery = [[AIServiceDiscovery alloc] initWithAppInfra:self];
        
        // allocate Internationalization instance
        if (builder.internationalization)
            self.internationalization = builder.internationalization;
        else
            self.internationalization = [[AIInternationalizationInterface alloc] init];
        

        // allocate REST client instance
        if (builder.RESTClient)
            self.RESTClient = builder.RESTClient;
        else
            self.RESTClient = [[AIRESTClientInterface alloc] initWithAppInfra:self];
        
        //allocate abtest
        if (builder.abtest)
            self.abtest = builder.abtest;
        else
            self.abtest = [[AIABTest alloc]initWithAppInfra:self];
        
        //allocate languagePack
        if (builder.languagePack)
            self.languagePack = builder.languagePack;
        else
            self.languagePack = [[AILanguagePack alloc] initWithAppInfra:self];
        
        //allocate appupdate
        if (builder.appUpdate) {
            self.appUpdate = builder.appUpdate;
        }
        else{
            self.appUpdate = [[AIAppUpdate alloc]initWithAppinfra:self];
            [(AIAppUpdate*)self.appUpdate appInfraRefresh];
        }
        
        //allocate ConsentManager
        if (builder.consentManager) {
            self.consentManager = builder.consentManager;
        } else {
            self.consentManager = (id<AIConsentManagerProtocol>)[[AIConsentManager alloc] init];
        }
        
        //allocate DeviceHandlerProtocol
        if (builder.deviceHandler) {
            self.deviceHandler = builder.deviceHandler;
        } else {
            self.deviceHandler = (id<ConsentHandlerProtocol>)[[DeviceStoredConsentHandler alloc] initWith:self];
        }
        
        //register Click Stream Consent Handlers
        if([(AIAppTagging*)self.tagging respondsToSelector:@selector(registerClickStreamConsentHandler)]) {
            [(AIAppTagging*)self.tagging registerClickStreamConsentHandler];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:InfraComponentsInitialisationCompleteNotification object:self];
        
        [self logDeviceNameAndVersion];
        NSString *appName=[self.appIdentity getAppName];
        NSString *appVersion=[self.appIdentity getAppVersion];
        NSString* appState =[(AIAppIdentityInterface*)self.appIdentity getAppStateString];
        NSString *message = [NSString stringWithFormat:@"AppInfra initialized for application \"%@\" version \"%@\" in state \"%@\" . Init time : %f ms",appName,appVersion,appState, 1000* [[NSDate date] timeIntervalSinceDate:startTime]];
        [AIInternalLogger log:AILogLevelDebug eventId:@"AppInfra" message:message];
    }
    return self;
}

-(NSString *)getVersion
{
    return self.appVersion;
}
-(NSString *)getComponentId
{
    return @"ail";
}


- (void)logDeviceNameAndVersion {
    NSString * message = [NSString stringWithFormat:@"Device name: %@, OS version: %@", [AIUtility deviceModel], [UIDevice currentDevice].systemVersion];
    [self.appInfraLogger log:AILogLevelDebug eventId:@"Initialization" message:message];
}
- (void)dealloc
{
    [AIInternalTaggingUtility resetSharedTagging];
}

@end
