//
//  URLayoutConstraint.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 08/08/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "URLayoutConstraint.h"

@implementation URLayoutConstraint

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateConstraint];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConstraint) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}


- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self updateConstraint];
}

- (void)updateConstraint {
    switch (self.constraintType) {
        case DLSConstraintTypeVerticalMargin:
            self.constant = 24;
            break;
        case DLSConstraintTypeHorizontalMargin:{
            if ([self sizeClassForCurrentScreen] == UIUserInterfaceSizeClassRegular) {
                CGFloat screenWidth = [UIApplication sharedApplication].keyWindow.bounds.size.width;
                self.constant = (screenWidth - 648)/2;
            } else if (self.isAddedToTableView) {
                self.constant = 0;
            } else {
                self.constant = 16;
            }
        }
            break;
        case DLSConstraintTypeOther:
        default:
            self.constant = self.constant;
            break;
    }
    [self.firstItem layoutIfNeeded];
    [self.secondItem layoutIfNeeded];
}


- (void)setConstraintType:(DLSConstraintType)constraintType {
    _constraintType = constraintType;
    [self updateConstraint];
}


- (UIUserInterfaceSizeClass)sizeClassForCurrentScreen {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    UITraitCollection *collection = controller.traitCollection;
    return collection.horizontalSizeClass;
}

@end
