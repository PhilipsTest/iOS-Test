//
//  AIComponentVersionInfoProtocol.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 09/03/17.
//  Copyright © 2017 Koninklijke Philips N.V.
//  Reproduction or dissemination
//  in whole or in part is prohibited without the prior written
//  consent of the copyright holder. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 protocol for defining component version and info
 */
@protocol AIComponentVersionInfoProtocol <NSObject>

/**
 Description : This method is used to get component's three letter acronym
 @return returns component's three letter acronym
 @since 2.1.0
 */
-(NSString *)getComponentId;

/**
 Description : This method is used to get component version number
 @return returns component version
 @since 2.1.0
 */
-(NSString *)getVersion;

@end
