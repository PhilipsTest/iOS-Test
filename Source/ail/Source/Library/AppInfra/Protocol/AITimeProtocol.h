//
//  AITimeProtocol.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 6/28/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 protocol for defining network time methods
 */
@protocol AITimeProtocol <NSObject>

/**
 *  method to get server UTC time
 *
 * @return returns the local time
 * @since 1.0.0
 */
-(NSDate *) getUTCTime;

/**
 * method to refresh UTC time could call
 * @since 1.0.0
 */
-(void)refreshTime;

/**
 * check the status of synchronization
 * @since 1.0.0
 */
-(BOOL)isSynchronized;

@end
