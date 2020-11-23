//
//  PSHandler.h
//  ProductSelection
//
//  Created by sameer sulaiman on 1/20/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSProductModelSelectionType.h"
#import <AppInfra/AppInfra.h>

@class PRXSummaryData;
typedef void (^OnProductSelectionCompletionHandler)(PRXSummaryData *selectedPRXSummary);
typedef void (^OnProductFetchCompletionHandler)(NSArray *summaryList);

static UIImage *bgImage;
@interface PSHandler : NSObject

+ (void)invokeProductSelectionWithParentController:(UIViewController*)parentController productModelSelection:(PSProductModelSelectionType*)productModelSelectionType andCompletionHandler:(OnProductSelectionCompletionHandler)completionHandler;
+ (void)setProductSelectionViewControllerRemoveCompletionblock:(OnProductSelectionCompletionHandler)completionHandler;
+ (void)closeProductSelectionInterface:(PRXSummaryData*)summaryData;
+ (void)setProductSelectionsParentNavigationBarVsible:(BOOL)visible;
+ (BOOL)getProductSelectionsParentNavigationBarVsible;
+ (void)setBackGroundImage:(UIImage *)image;
+ (UIImage *)getBackGroundImage;
+ (NSString *)getVersion;
+ (void)setPSUITopConstraint:(float)topConstraint;
+ (float)getPSUITopConstraint;
+ (void) excecuteProductSelectionVCRemoveCompletionHandler:(PRXSummaryData*)selectedPRXSummary;
+ (void) setAppInfraTagging:(AIAppInfra *)appInfra;
+ (void)fetchProductDetailWithProductModelType:(PSProductModelSelectionType*)productModelSelectionType andCompletionHandler:(OnProductFetchCompletionHandler)completionHandler;
@end

