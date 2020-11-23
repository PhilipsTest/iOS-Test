//
//  AILogging.m
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved.
 Reproduction or dissemination in whole or in part is prohibited without
 the prior written consent of the copyright holder.
 */

#import "AILogging.h"
#import "AIClientComponent.h"
#import "AILoggingFormatter.h"
#import <AppInfra/AppInfra-Swift.h>
#import "AILogMetaData.h"
#import "AILoggingManager.h"
#import "AILogUtilities.h"

#define kAppInfra @"AppInfra"
#define kAILogEvent @"AILogging"
#define kCloudConsent   @"AIL_CloudConsent"

@interface AILogging() {
    AILoggingManager *logManager;
}

@property (nonatomic, strong) AIClientComponent *loggingComponent;
@property (nonatomic, strong) AICloudLogMetadata *cloudLogMetaData;

@end


#ifdef DEBUG
#define DEBUGMODE YES
#else
#define DEBUGMODE NO
#endif


@implementation AILogging

@synthesize hsdpUserUUID;

- (instancetype)initWithAppInfra:(id<AIAppInfraProtocol>)appInfra {
    self = [super init];
    if (self) {
        self.aiAppInfra = appInfra;
        self.logConfig = [self getConfiguration];
        [self.cloudLogMetaData  updateInfo];
        logManager = [[AILoggingManager alloc]initWithConfig:self.logConfig];
        [self initializeLogging];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(appInfraDependandInitialization) name:InfraComponentsInitialisationCompleteNotification
                                                  object:nil];
    }
    return self;
}


- (AICloudLogMetadata *)cloudLogMetaData {
    if (!_cloudLogMetaData){
        _cloudLogMetaData = [[AICloudLogMetadata alloc]initWithAppInfra:self.aiAppInfra];
    }
    return _cloudLogMetaData;
}


-(void)appInfraDependandInitialization {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:InfraComponentsInitialisationCompleteNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self.cloudLogMetaData
                                            selector:@selector(updateNetworkType)
                                                name:kAILReachabilityChangedNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateCountry)
                                                name:AILServiceDiscoveryHomeCountryChangedNotification
                                              object:nil];
    
    [self registerCloudLoggingConsentHandler];
    [self updateMetaInfo];
}


-(void)updateMetaInfo {
    [self.cloudLogMetaData updateInfo];
}


-(void)updateCountry {
    [self.cloudLogMetaData updateHomeCountry];
}


- (void)initializeLogging {
    static dispatch_once_t logOnceToken;
    dispatch_once(&logOnceToken, ^{
        [self defaultSetUp];
    });
}


- (void)defaultSetUp {
    [DDLog addLogger:[logManager fileLogger]];
    [DDLog addLogger:[logManager consoleLogger]];
    [DDLog addLogger:[logManager cloudLoggerWithAppInfra:self.aiAppInfra
                                                metaData:self.cloudLogMetaData]];
}


- (id<AILoggingProtocol>)createInstanceForComponent:(NSString *)componentId
                                   componentVersion:(NSString *)componentVersion {
    AIClientComponent *component = [[AIClientComponent alloc]
                                    initWithIdentifier:componentId version:componentVersion];
    AILogging *wrapper = [[AILogging alloc]init];
    wrapper.loggingComponent = component;
    wrapper.logConfig = self.logConfig;
    wrapper.aiAppInfra = self.aiAppInfra;
    // Requirement R-AI-LOG-6:
    [self setLevel:AILogLevelVerbose
           eventId:kAILogEvent
           message:[NSString stringWithFormat: @"Logger Created for %@", componentId]
        dictionary:nil];
    return wrapper;
}


- (void)log:(AILogLevel)level eventId:(NSString *)eventId message:(NSString *)message {
    [self setLevel:level eventId:eventId message:message  dictionary:nil];
}


- (void)log:(AILogLevel)level
    eventId:(NSString *)eventId
    message:(NSString *)message
 dictionary:(NSDictionary *)dictionary {
    if (dictionary && [dictionary description].length) {
        [self setLevel:level
               eventId:eventId
               message:[NSString stringWithFormat:@"%@",message]
            dictionary:dictionary];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (NSString *)getCloudLoggingConsentIdentifier {
    return kCloudConsent;
}
#pragma clang diagnostic pop


-(void)setLevel:(AILogLevel)aiLogLevelFlag
        eventId:(NSString *)eventId
        message:(NSString *)message
     dictionary:(NSDictionary *)dictionary {
    
    if ([self shouldComponentFilteredOut]) {
        return;
    }
    NSString * logEventId = [eventId copy];
    NSString * logMessage = [message copy];
    if (eventId == nil || eventId.length <= 0) {
        logEventId = @"NA";
    }
    if (message == nil || message.length <= 0) {
        logMessage = @"NA";
    }
    
    NSString *componentString;
    if(self.loggingComponent){
        componentString = [NSString stringWithFormat: @"%@:%@", self.loggingComponent.identifier, self.loggingComponent.version];
    }
    AILogMetaData *tagData = [[AILogMetaData alloc]init];
    
    tagData.eventId = logEventId;
    tagData.component = componentString;
    tagData.params = dictionary;
    tagData.originatingUser = self.aiAppInfra.cloudLogging.hsdpUserUUID;
    tagData.networkDate = [self.aiAppInfra.time getUTCTime];
    
    DDLogLevel logLevel = self.logConfig.logLevel;
    DDLogFlag flag = [AILogUtilities aiFlagtoDDLogFlag:aiLogLevelFlag];
    
    
    [self log:LOG_ASYNC_ENABLED
        level:logLevel
         flag:flag
      message:logMessage
          tag:tagData];
}

/* Passing Logging message details with Log Level, Log Flag, File,
 Line, ComponentID Name, Component Version, Event and Message
 Sending Log parameters to 3rd Party Library (CocoaLumberjack)
 */
- (void)log:(BOOL)asynchronous
      level:(DDLogLevel)level
       flag:(DDLogFlag)flag
    message:(NSString *)message
       tag :(AILogMetaData*)tag {
    
    // Checking Log Level Flag
    if (!(level & flag)) {
        return;
    }
    
    [DDLog log:asynchronous
         level:level
          flag:flag
       context:0
          file:__FILE__
      function:__PRETTY_FUNCTION__
          line:__LINE__
           tag:tag
        format:@"%@", message];
}


-(BOOL)shouldComponentFilteredOut {
    if (self.loggingComponent && self.logConfig.componentLevelLogEnabled &&
        ![self.logConfig.componentIds containsObject:self.loggingComponent.identifier]) {
        return true;
    }
    return false;
}


-(AILoggingConfig *)getConfiguration {
    NSError * error;
    NSString * configKey;
    BOOL releaseConfig = NO;
    if (DEBUGMODE) {
        configKey = @"logging.debugConfig";
    }
    else {
        configKey = @"logging.releaseConfig";
        releaseConfig = YES;
    }
    NSDictionary * logConfigDict = [self.aiAppInfra.appConfig getPropertyForKey:configKey
                                                                          group:@"appinfra"
                                                                          error:&error];
    BOOL validated = logConfigDict && [logConfigDict isKindOfClass:[NSDictionary class]];
    if (validated) {
        AILoggingConfig * config = [[AILoggingConfig alloc]initWithConfig:logConfigDict];
        config.isReleaseConfig = releaseConfig;
        [self setLevel:AILogLevelVerbose
               eventId:kAILogEvent
               message:[NSString stringWithFormat: @"Using logging config:\n %@", [config description]]
            dictionary:nil];
        return config;
    }
    NSAssert(validated, @"Logging configuration not added in AppConfig | %@", error.localizedDescription);
    return nil;
}


- (void)registerCloudLoggingConsentHandler {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    [self.aiAppInfra.consentManager registerHandlerWithHandler:self.aiAppInfra.deviceHandler
                                               forConsentTypes:@[[self getCloudLoggingConsentIdentifier]]
                                                         error:nil];
#pragma clang diagnostic pop
}

@end
