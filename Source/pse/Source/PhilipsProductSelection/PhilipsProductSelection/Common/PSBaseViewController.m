//
//  PSBaseViewController.m
//  ProductSelection
//
//  Created by sameer sulaiman on 1/18/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSBaseViewController.h"
#import "PSHandler.h"
#import "PSConstants.h"
@import PhilipsUIKitDLS;

@interface PSBaseViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productSelectionUITopConstraint;

@end

@implementation PSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backGroundImage.image=[PSHandler getBackGroundImage]?[PSHandler getBackGroundImage]:nil;
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
    [UIApplication sharedApplication].delegate.window.backgroundColor = [UIDThemeManager sharedInstance].defaultTheme.contentSecondary;
}

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:NO];
    self.productSelectionUITopConstraint.constant = [PSHandler getPSUITopConstraint];
}

-(PSProductModelSelectionType *)getProductModelSelectionType
{
    return self.productModel;
}
@end
