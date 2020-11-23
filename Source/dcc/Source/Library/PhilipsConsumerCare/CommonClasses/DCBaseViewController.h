//
//  DCBaseViewController.h
//  DigitalCare
//
//  Created by sameer sulaiman on 27/01/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <UIKit/UIKit.h>
#import "DCUtilities.h"
#import "DCLaunchInput.h"
@import PhilipsUIKitDLS;

@interface DCBaseViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic,assign)id <DCMenuDelegates> dCMenuDelegates;
@property (weak, nonatomic)IBOutlet UIImageView *backGroundImage;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint *LeftPadding;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint *RightPadding;
@property (nonatomic, weak)IBOutlet UIDProgressIndicator *progressIndicatorView;

- (void)startProgressIndicator;
- (void)stopProgressIndicator;
@end
