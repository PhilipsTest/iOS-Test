//
//  PSNavigationViewController.m
//  ProductSelection
//
//  Created by sameer sulaiman on 1/18/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSNavigationViewController.h"
#import "UIViewController+PSChildViewController.h"
#include "PSHandler.h"

@interface PSNavigationViewController ()

@end

@implementation PSNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1) {
        [self closeProductSelectionInterface];
    }
}

- (void)closeProductSelectionInterface
{
    [self removeProductSelectionViewController];
    [PSHandler closeProductSelectionInterface:nil];
}

@end
