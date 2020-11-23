/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@class UAPPLaunchInput;
@class UAPPDependencies;
@class UAPPSettings;

@protocol DataInterface;
/**
 * UAPPProtocol provides basic rules for uApps to follow.
 * @since 1.0.0
 */
@protocol UAPPProtocol <NSObject>
@required
/**
 * Documenting UAPPProtocol
 * @param dependencies Object of uAppDependencies class,for injecting Dependencies needed by uApp
 * @param settings Object of UAPPSettings class,for injecting one time initialisation parameters needed for uAPP Initialisation
 * @return Returns instance of uAPP
 * @since 1.0.0
 */
- (instancetype _Nonnull)initWithDependencies:(UAPPDependencies * _Nonnull) dependencies andSettings : (UAPPSettings * _Nullable) settings;

/**
 * Documenting UAPPProtocol
 * @param completionHandler Block for handling error
 * @param launchInput Instance of UAPPLaunchInput class,for setting the parameters needed for launch of uAPP
 * @return Returns an instance of uApp's UIViewController which will be used for launching the uApp
 * @since 1.0.0
 */
- (UIViewController * _Nullable)instantiateViewController:(UAPPLaunchInput * _Nonnull) launchInput withErrorHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler;

@end
