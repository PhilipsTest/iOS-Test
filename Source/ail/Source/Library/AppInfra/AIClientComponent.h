//
//  AIClientComponent.h
//  AppInfra
//
//  Created by Senthil on 22/06/16.
/*  Copyright ©  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/
//


#import <Foundation/Foundation.h>

/**
 *  This class encapsulates all details of a component that accesses AppInfra
 */
@interface AIClientComponent : NSObject

/**
 *  identifier of the component
 */
@property (nonatomic, strong) NSString *identifier;

/**
 *  version of the component
 */
@property (nonatomic, strong) NSString *version;


/**
 *  Convenience initializer
 *
 *  @param identifier unique identifier of the component
 *  @param version    version of the component
 *
 *  @return Returns a component object
 */
- (instancetype)initWithIdentifier:(NSString *)identifier version:(NSString *)version;

@end
