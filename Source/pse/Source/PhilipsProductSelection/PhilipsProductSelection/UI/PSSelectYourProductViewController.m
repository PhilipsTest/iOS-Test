//
//  PSSelectYourProductViewController.m
//  ProductSelection
//
//  Created by sameer sulaiman on 1/18/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSSelectYourProductViewController.h"
#import "PSProductListViewController.h"
#import "PSConstants.h"
#import "PSUtility.h"
#import "PSAppInfraWrapper.h"
#import "PSHandler.h"
@import PhilipsUIKitDLS;

@interface PSSelectYourProductViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgProductDisplay;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIDButton *btnFindProduct;


@end

@implementation PSSelectYourProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LOCALIZE(kSelectYourProductTitle);
    _imgProductDisplay.image = [UIImage imageNamed:kProductBannerImage inBundle:StoryboardBundle compatibleWithTraitCollection:nil];
    _imgProductDisplay.layer.masksToBounds=YES;
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Loading" Message:@"Product selection welcome screen shown for user to find products"];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ((([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) && [self isKindOfClass:[PSSelectYourProductViewController class]])) {
        [PSHandler closeProductSelectionInterface:nil];
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackPageWithInfo:kHomePage paramKey:nil andParamValue:nil];
}

- (IBAction)showProductList:(id)sender
{
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Button Click" Message:@"User clicked on \"find products\""];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryBoardName bundle:StoryboardBundle];
    if([PSUtility isNetworkReachable])
    {
        PSProductListViewController *listViewController = [storyboard instantiateViewControllerWithIdentifier:kProductListViewController];
        [listViewController setProductModel:self.productModel];
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    else
        [self showErrorMessage];
    
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackActionWithInfo:kSendData paramKey:kSpecialEvent andParamValue:kFindProductAction];
}

- (void)showErrorMessage
{
    UIDAlertController *alert = [[UIDAlertController alloc]initWithTitle:nil icon:nil message:LOCALIZE(kNoNetwork)];
    UIDAction *defaultAction = [[UIDAction alloc]initWithTitle:@"OK" style:UIDActionStylePrimary handler:^(UIDAction * acion) {
        [self dismissViewControllerAnimated:NO completion:nil];
        }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Alert" Message:@"User device is not connected to internet/mobile data"];
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackActionWithInfo:kSetError paramKey:kTechnicalError andParamValue:kNetworkError];
    return;
}

@end
