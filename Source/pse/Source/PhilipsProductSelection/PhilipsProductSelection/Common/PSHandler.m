//
//  PSHandler.m
//  ProductSelection
//
//  Created by sameer sulaiman on 1/20/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSHandler.h"
#import "PSSelectYourProductViewController.h"
#import "PSProductListViewController.h"
#import "PSConstants.h"
#import "UIViewController+PSChildViewController.h"
#import "PSDataHandler.h"
#import <PhilipsPRXClient/PRXSummaryData.h>
#import "PSUtility.h"
#import "PSAppInfraWrapper.h"

static OnProductSelectionCompletionHandler productSelectionVCRemoveCompletionHandler;
static BOOL isParentNavigationBarVisible, isParentHasNavigationViewController;
static NSString *lMLocale;
static NSString *libraryVersion;
static NSString *applicationID;
static NSString *sectorType;
static NSString *catalogType;
static NSString *previousPageName;
static NSMutableArray *summaryListArray;
static float uiTopConstraint;

@implementation PSHandler

UINavigationController *productSelectionNavigationViewController;
NSInteger indexSelectionViewController;

+ (void)invokeProductSelectionWithParentController:(UIViewController*)parentController productModelSelection:(PSProductModelSelectionType*)productModelSelectionType andCompletionHandler:(OnProductSelectionCompletionHandler)completionHandler
{
    UIStoryboard *productSelectionStoryboard = [UIStoryboard storyboardWithName:kProductSelStoryboard bundle:StoryboardBundle];
    UIViewController *viewController;
    productSelectionNavigationViewController=[parentController isKindOfClass:[UINavigationController class]]?(UINavigationController*)parentController:parentController.navigationController;
    viewController = [self getCurrentViewController:viewController withStoryboard:productSelectionStoryboard];
    [(PSBaseViewController *)viewController setProductModel:productModelSelectionType];
    if (productSelectionNavigationViewController)
    {
        isParentHasNavigationViewController = YES;
        [productSelectionNavigationViewController.navigationBar setHidden:NO];
        [productSelectionNavigationViewController pushViewController:viewController animated:YES];
        indexSelectionViewController = [productSelectionNavigationViewController.viewControllers count]-1;
    }
    else
    {
        productSelectionNavigationViewController = [productSelectionStoryboard instantiateViewControllerWithIdentifier:kPSNavigation];
        [productSelectionNavigationViewController setViewControllers:@[viewController] animated:NO];
        [parentController addProductSelectionViewController:productSelectionNavigationViewController container:parentController.view];
    }
    [PSHandler setProductSelectionViewControllerRemoveCompletionblock:completionHandler];
}

+ (void)fetchProductDetailWithProductModelType:(PSProductModelSelectionType*)productModelSelectionType andCompletionHandler:(OnProductFetchCompletionHandler)completionHandler{
    PSDataHandler *dataHandler = [[PSDataHandler alloc] init];
    NSArray *summaryList = productModelSelectionType.prxSummaryList;
    if (!summaryList || summaryList.count < 1) {
        [dataHandler requestPRXSummaryWith:productModelSelectionType completion:^(NSArray *productList) {
            if([productList count]>0){
                [productModelSelectionType setPrxSummaryList:productList];
                completionHandler(productList);
            }
            else
            return ;
        } failure:^(NSString *error) {
            completionHandler(nil);
            [PSHandler excecuteProductSelectionVCRemoveCompletionHandler:nil];
        }];
    }else{
        completionHandler(summaryList);
    }
}

+ (UIViewController*)getCurrentViewController:(UIViewController*)viewController withStoryboard:(UIStoryboard*)productSelectionStoryboard
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:kSelectedProductKey]) {
            viewController= [productSelectionStoryboard instantiateViewControllerWithIdentifier:kProductListViewController];
    } else
    {
        viewController= [productSelectionStoryboard instantiateViewControllerWithIdentifier:kSelectYourProduct];
    }
    return viewController;
}

+ (void)closeProductSelectionInterface:(PRXSummaryData*)summaryData
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if(isParentHasNavigationViewController)
    {
        NSInteger indexParentController = MAX(0, indexSelectionViewController-1);
        [productSelectionNavigationViewController popToViewController:[productSelectionNavigationViewController.viewControllers objectAtIndex:indexParentController] animated:YES];
    }
    else
    {
        [productSelectionNavigationViewController removeProductSelectionViewController] ;
    }
    [PSHandler excecuteProductSelectionVCRemoveCompletionHandler:summaryData];
    
}

+ (void)setProductSelectionViewControllerRemoveCompletionblock:(OnProductSelectionCompletionHandler)completionHandler
{
    productSelectionVCRemoveCompletionHandler = completionHandler;
}

+ (void)setProductSelectionsParentNavigationBarVsible:(BOOL)visible
{
    isParentNavigationBarVisible = visible;
}

+ (BOOL)getProductSelectionsParentNavigationBarVsible
{
    return isParentNavigationBarVisible;
}

+ (void)setBackGroundImage:(UIImage *)image
{
    bgImage=image;
}

+ (UIImage *)getBackGroundImage
{
    return bgImage;
}

+ (void) excecuteProductSelectionVCRemoveCompletionHandler:(PRXSummaryData*)selectedPRXSummary
{
    if (productSelectionVCRemoveCompletionHandler != nil) {
        productSelectionVCRemoveCompletionHandler(selectedPRXSummary);
    }
}

+ (NSString *)getVersion
{
    return [PSUtility getVersion];
}

+ (void)setPSUITopConstraint:(float)topConstraint
{
    uiTopConstraint = topConstraint;
}

+ (float)getPSUITopConstraint
{
    return uiTopConstraint;
}

+ (void) setAppInfraTagging:(AIAppInfra *)appInfra
{
    [PSAppInfraWrapper sharedInstance].appInfra = appInfra;
}

-(void)dealloc
{
    productSelectionVCRemoveCompletionHandler = nil;
}

@end
