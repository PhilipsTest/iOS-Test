//
//  DCBaseViewController.m
//  DigitalCare
//
//  Created by sameer sulaiman on 27/01/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "DCBaseViewController.h"
#import "NSString+DCAdditions.h"
#import "DCPluginManager.h"
#import "DCConstants.h"
#import "DCHandler.h"

@interface DCBaseViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consumerCareUITopConstraint;
@property (nonatomic, strong) UIView  *progressTransparentView;

@end

@implementation DCBaseViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    SharedInstance.themeConfig.backGroundImage?[self.backGroundImage setImage:[UIImage imageNamed:SharedInstance.themeConfig.backGroundImage]]:nil;
    self.backGroundImage.backgroundColor = SharedInstance.themeConfig.screenBackgroundColor?[SharedInstance.themeConfig.screenBackgroundColor  getHexColor]:nil;
    
    self.progressTransparentView = [[UIView alloc]init];
    self.progressTransparentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.progressTransparentView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[progressTransparentView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"progressTransparentView":self.progressTransparentView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[progressTransparentView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:@{@"progressTransparentView":self.progressTransparentView}]];
    self.progressTransparentView.backgroundColor = [UIColor clearColor];
    self.progressTransparentView.hidden = YES;
}

- (void)startProgressIndicator {
    [self.progressIndicatorView startAnimating];
    [self.view bringSubviewToFront:self.progressTransparentView];
    [self.view bringSubviewToFront:self.progressIndicatorView];
    [UIView animateWithDuration:0.5 animations:^{
        self.progressTransparentView.hidden = NO;
    }];
}

- (void)stopProgressIndicator {
    [self.progressIndicatorView stopAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        self.progressTransparentView.hidden = YES;
    }];
}

@end
