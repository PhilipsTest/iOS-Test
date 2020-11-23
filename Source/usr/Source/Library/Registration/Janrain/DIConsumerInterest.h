//
//  ConsumerInterest.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>


/**
 *  This class defines attributes that represent a custom interest of consumers.
 *
 *  @since 1.0.0
 */
@interface DIConsumerInterest : NSObject

/**
 *  The object's campaignName property
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *campaignName;

/**
 *  The object's subjectArea property
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *subjectArea;

/**
 *  The object's topicCommunicationKey property
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *topicCommunicationKey;

/**
 *  The object's topicValue property
 *
 *  @since 1.0.0
 */
@property (nonatomic, strong) NSString *topicValue;

@end
