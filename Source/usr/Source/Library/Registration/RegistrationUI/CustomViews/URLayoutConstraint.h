//
//  URLayoutConstraint.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 08/08/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DLSConstraintType) {
    DLSConstraintTypeHorizontalMargin = 0,
    DLSConstraintTypeVerticalMargin = 1,
    DLSConstraintTypeOther = 2
};

@interface URLayoutConstraint : NSLayoutConstraint

#if TARGET_INTERFACE_BUILDER
@property (nonatomic) IBInspectable int constraintType;
#else
@property (nonatomic) DLSConstraintType constraintType;
#endif

@property (nonatomic, assign) IBInspectable BOOL isAddedToTableView;

@end
