/* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/


#import <Foundation/Foundation.h>
@import AppInfra;

/**
 * UAPPDependencies provides base class for Injecting uApp dependencies.
 * Any uApp can inherit this base class and inject dependencies for their component.
 * @since 1.0.0
 */

@interface UAPPDependencies : NSObject

/**
 * Instance of AIAppInfra
 * @since 1.0.0
 */
@property (nonatomic , strong) AIAppInfra *appInfra;

@end
