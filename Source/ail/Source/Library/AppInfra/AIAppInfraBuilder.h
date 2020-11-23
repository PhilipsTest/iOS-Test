//
//  AIAppInfraBuilder.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/24/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//

#import <Foundation/Foundation.h>
#import "AIAppInfraProtocol.h"

@class AIAppInfra;

/**
 Appinfra builder class
 */
@interface AIAppInfraBuilder : NSObject<AIAppInfraProtocol>

/**
 Used for creating appinfra instance from builder object
 @return new appinfra instance
 @since 1.0.0
 */
-(AIAppInfra *)build;

@end
