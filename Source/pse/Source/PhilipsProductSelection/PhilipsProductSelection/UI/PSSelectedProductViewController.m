//
//  PSSelectedProductViewController.m
//  ProductSelection
//
//  Created by sameer sulaiman on 2/1/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSSelectedProductViewController.h"
#import "PSProductListViewController.h"
#import "PSConstants.h"
#import "PSUtility.h"
#import "UIImageView+AFNetworking.h"
#import "PSHandler.h"
#import "PSAppInfraWrapper.h"
@import PhilipsUIKitDLS;
@import PhilipsIconFontDLS;

@interface PSSelectedProductViewController ()
{
    __weak IBOutlet UIImageView *productIcon;
    __weak IBOutlet UIDLabel *productName;
    __weak IBOutlet UIDLabel *productCTN;
    __weak IBOutlet UIDLabel *selectionTick;
}

@end

@implementation PSSelectedProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZE(@"Confirmation_Title");
    [selectionTick setFont:[UIFont iconFontWithSize:22.0]];
    [selectionTick setTextColor:[UIDThemeManager sharedInstance].defaultTheme.buttonPrimaryFocusBackground];
    [selectionTick setText:[PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeCheckCircle]];
    productCTN.text=_selectedProductSummary.ctn;
    productName.text= _selectedProductSummary.productTitle;
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Loading" Message:@"Product confirmation screen is diplayed to confirm the user selected product"];
    [self loadSelectedProductImage];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackPageWithInfo:kConfirmationPage paramKey:nil andParamValue:nil];
}


- (IBAction)onContinue:(id)sender {
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Clicked" Message:@"User clicked on \"Continue\" button"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSelectedProductKey];
    [PSHandler closeProductSelectionInterface:_selectedProductSummary];
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackActionWithInfo:kSendData paramKey:kSpecialEvent andParamValue:kContinueAction];
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackActionWithInfo:kSendData paramKey:@"productModel" andParamValue: _selectedProductSummary.ctn];
}

- (IBAction)changeProduct:(id)sender {
    [[PSAppInfraWrapper sharedInstance] log:AILogLevelInfo  Event:@"Clicked" Message:@"User clicked on \"Change\" button"];
    NSMutableArray *stackControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *controller in stackControllers) {
        if ([controller isKindOfClass:[PSProductListViewController class]]) {
            [(PSProductListViewController *)controller setProductModel:self.productModel];
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    [[PSAppInfraWrapper sharedInstance].productSelectionTagging trackActionWithInfo:kSendData paramKey:kSpecialEvent andParamValue:kChangeProductAction];
}

-(void)loadSelectedProductImage
{
    [productIcon setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_selectedProductSummary.imageURL]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self->productIcon.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        self->productIcon.backgroundColor = [UIColor blackColor];
    }];
}

@end
