//
//  UIView+Helper.m
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "RegistrationUIView+Helper.h"
@import PhilipsUIKitDLS;

@implementation UIView (Helper)


- (void)setExclusiveTouchForButtons {
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            [button setExclusiveTouch:YES];
        } else {
            [obj setExclusiveTouchForButtons];
        }
    }];
}


-(void)removeTextFieldErrors {
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIDTextField class]]) {
            UIDTextField *textField = (UIDTextField *)obj;
            [textField setValidationView:NO animated:NO];
        } else {
            [obj removeTextFieldErrors];
        }
    }];
}

@end
