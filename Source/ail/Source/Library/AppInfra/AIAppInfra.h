//
//  AIAppInfra.h
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
#import "AIAppInfraProtocol.h"
#import "AIAppInfraBuilder.h"
#import "AIComponentVersionInfoProtocol.h"

@class AIAppUpdateInfo;
@class AIAppUpdate;
@class AIInternationalizationInterface;
@class AIAppIdentityInterface;
/**
   App Infra provides a range of modules that are the basis for any mobile application
   App Infra provides various utility services for the application such as Logging, Tagging, Service discovery etc.
 */
@interface AIAppInfra : NSObject<AIAppInfraProtocol,AIComponentVersionInfoProtocol>

/**
 Gives the application version
 @since 1.0.0
  */
@property (nonatomic,retain) NSString *appVersion;
/**
 Gives the application name
 @since 1.0.0
 */
@property (nonatomic,retain) NSString *appName;

/**
 To enable an application developer to create his own implementation for specific App Infra modules and have all components integrated in the app use that alternative module implementation; App Infra supports a builder pattern. By the use of the builder pattern, it is possible to create an instance of App Infra with alternative module implementations that overwrite one or more of the default module implementations.
 The most common use case for providing alternative implementations is for testing purposes where a (component test-) app wants to test its functionality in isolation without having to implicitly test the App Infra implementation or any cloud services abstracted by App Infra. In such a case, the app developer can create an App Infra instance with dummy implementations.
 Another use case for implementation replacement is to provide the ability to maintain compatibility with another cloud back-end (version).
 @param buildBlock block object used for alternate module injection
 @retun appinfra instance
 @since 1.0.0
 */
+ (instancetype)buildAppInfraWithBlock:(void(^)(AIAppInfraBuilder *builder))buildBlock;

/**
 Instance method for appinfra creation
 @param builder appinfra builder object for module injection. Can pass nil if there are no alternate implementations
 @return appinfra instance
 @since 1.0.0
 */
- (instancetype)initWithBuilder:(AIAppInfraBuilder *)builder;

@end
