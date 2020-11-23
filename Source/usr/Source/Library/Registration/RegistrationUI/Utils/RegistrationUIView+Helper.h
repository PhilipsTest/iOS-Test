//
//  UIView+Helper.h
//  Registration
//
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <UIKit/UIKit.h>

@interface UIView (Helper)
/*!
 @author Manish Rathi
 @method setExclusiveTouchForButtons
 @brief Set ExclusiveTouch Yes for All- buttons.
 @discussion We need to Set the ExclusiveTouch as `YES` for all the buttons in UIView, because sometime If user pressed two buttons same time,the result is unexpected. (App crashing some-time.)
 */
- (void)setExclusiveTouchForButtons;

/** Remove all UIDTextField errors*/
- (void)removeTextFieldErrors;

@end

