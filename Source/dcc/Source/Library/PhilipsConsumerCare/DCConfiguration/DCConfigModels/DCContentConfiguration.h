//
//  DCContentConfiguration.h
//  PhilipsConsumerCare
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

/**
*  DCContentConfiguration class is used for setting configurations
*
*  @since 2003.0.0
*/
@interface DCContentConfiguration : NSObject

/**
 *  Set the Live chat text of the Live-Chat Screen
 *
 *  @since 2003.0.0
 */
@property (nonatomic, strong) NSString *livechatDescText;

@end
