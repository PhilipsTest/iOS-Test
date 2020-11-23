//
//  PSDataHandler.h
//  ProductSelection
//
//  Created by sameer sulaiman on 2/11/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSProductModelSelectionType.h"

@interface PSDataHandler : NSObject

- (void)requestPRXSummaryWith:(PSProductModelSelectionType*)productModelSelectionType completion:(void (^)(NSArray *summaryList))success failure:(void(^)(NSString *error))failure;

@end
