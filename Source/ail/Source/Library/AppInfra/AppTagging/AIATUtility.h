//
//  AIATUtility.h
//  AppInfra
//
//  Created by leslie on 20/09/16.
//  Copyright © 2016 /* Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIAppTaggingProtocol.h"
@interface AIATUtility : NSObject

/**
 *  The previousPage for tracking the previous page in analytics.
 */
@property(nonatomic,strong)NSString *previousPage;

+ (instancetype)sharedInstance;

- (NSString *)getTaggingErrorCategory:(AITaggingErrorCategory) category;
@end
