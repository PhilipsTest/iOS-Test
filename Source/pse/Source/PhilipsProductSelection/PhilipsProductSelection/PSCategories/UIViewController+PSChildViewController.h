//
//  UIViewController+PSChildViewController.h
//  ProductSelection
//
//  Created by sameer sulaiman on 2/9/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PSChildViewController)

- (void)addProductSelectionViewController:(UIViewController *)childController container:(UIView *)container;
- (void)removeProductSelectionViewController;

@end
