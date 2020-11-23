//
//  UIViewController+PSChildViewController.m
//  ProductSelection
//
//  Created by sameer sulaiman on 2/9/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "UIViewController+PSChildViewController.h"
#import "PSHandler.h"

@implementation UIViewController (PSChildViewController)

#pragma mark - add/remove ChildView Controller

- (void)addProductSelectionViewController:(UIViewController *)childController container:(UIView *)container
{
    if (childController && ![self.childViewControllers containsObject:childController]){
        [PSHandler setProductSelectionsParentNavigationBarVsible:!self.navigationController.navigationBarHidden];
        if (!self.navigationController) {
            UIView *destinationView = childController.view;
            [self addChildViewController:childController];
            [container addSubview:destinationView];
            [childController didMoveToParentViewController:self];
            //Add AutoLayout Constraints
            destinationView.translatesAutoresizingMaskIntoConstraints = NO;
            NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[destinationView]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(destinationView)];
            NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[destinationView]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:NSDictionaryOfVariableBindings(destinationView)];
            [container addConstraints:horizontalConstraints];
            [container addConstraints:verticalConstraints];
        }
    }
}

- (void)removeProductSelectionViewController
{
    if (self) {
        if ([PSHandler getProductSelectionsParentNavigationBarVsible]) {
            [self.parentViewController.navigationController setNavigationBarHidden:NO];
        }
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

@end
