//
//  ValidationHelper.h
//  Registration
//
//  Created by Adarsh Kumar Rai on 18/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EarlGrey/EarlGrey.h>

@interface ValidationHelper : NSObject

#pragma mark - Visibility Validation
#pragma mark -

+ (BOOL)isElementWithIdCompletelyVisible:(NSString *)accessibilityId;
+ (BOOL)isElementWithIdSufficientlyVisible:(NSString *)accessibilityId;
+ (BOOL)isElementWithIdPartiallyVisible:(NSString *)accessibilityId;
+ (BOOL)isDLSAlertForErrorIsDisplayed;
+ (void)assertThatElementWithIdIsSufficientlyVisible:(NSString *)elementId;
+ (void)assertThatElementWithIdIsCompletelyVisible:(NSString *)elementId;
+ (void)assertThatElementWithIdIsPartiallyVisible:(NSString *)elementId;
+ (void)assertThatElementWithIdIsInvisible:(NSString *)elementId;

+ (void)assertThatElementWithIdIsNotEnabled:(NSString *)elementId;
+ (void)assertThatElementWithIdIsEnabled:(NSString *)elementId;
#pragma mark - Tap Action
#pragma mark -

+ (void)tapButtonWithId:(NSString *)buttonAccessibilityId;//The button is tapped only if sufficiently visible. Visibility assertion will fail the test if button is not sufficiently visible.
+ (void)tapElementWithText:(NSString *)elementText;//The element is tapped only if sufficiently visible. Visibility assertion will fail the test if element is not sufficiently visible.
+ (void)tapDLSAlertActionWithTitle:(NSString *)actionTitle;//The alert action is tapped only if sufficiently visible. Visibility assertion will fail the test if element is not sufficiently visible.
+ (void)tapCloseErrorNotification;

#pragma mark - Content Validation
#pragma mark -

+ (BOOL)buttonWithId:(NSString *)accessibilityId hasTitle:(NSString *)title;

+ (void)assertThatElementWithId:(NSString *)elementId hasText:(NSString *)text;
+ (void)assertThatButtonWithId:(NSString *)buttonId hasTitle:(NSString *)title andWidth:(CGFloat)width;
+ (BOOL)isCurrentScreenTitleEqualTo:(NSString *)title;
+ (void)assertThatCurrentScreenHasTitle:(NSString *)title;
+ (void)assertThatTextFieldWithId:(NSString *)textFieldId hasErrorMessageDisplayed:(NSString *)errorMessage;
+ (void)assertThatTextFieldWithIdHasNoErrorMessageDisplayed:(NSString *)textFieldId;
+ (void)assertThatDLSAlertIsDisplayedWithTitle:(NSString *)title message:(NSString *)message andActionTitles:(NSArray<NSString *> *)actionTitles;
+ (void)assertThatErrorNotificationIsDisplayedWithMessage:(NSString *)errorMessage;

#pragma mark - Layout Validation
#pragma mark -

+ (void)assertThatElementWithId:(NSString *)elementId isOnLeftOfElementWithId:(NSString *)referenceElementId byPoints:(double)points;
+ (void)assertThatElementWithId:(NSString *)elementId isOnRightOfElementWithId:(NSString *)referenceElementId byPoints:(double)points;
+ (void)assertThatElementWithId:(NSString *)elementId isAboveElementWithId:(NSString *)referenceElementId byPoints:(double)points;
+ (void)assertThatElementWithId:(NSString *)elementId isBelowElementWithId:(NSString *)referenceElementId byPoints:(double)points;

+ (void)assertThatElementWithId:(NSString *)elementId hasMarginOf:(double)points inDirection:(GREYLayoutDirection)direction;

#pragma mark - Utility Methods
#pragma mark -

+ (void)tapNavigationBackButton;
+ (void)waitForElementWithName:(NSString *)name elementMatcher:(id<GREYMatcher>)matcher timeout:(CGFloat)timeout;
+ (CGFloat)horizontalMarginForCurrentSizeClass;
+ (CGFloat)verticalMarginForCurrentSizeClass;
+ (void)scrollToElementWithId:(NSString *)elementId inDirection:(GREYDirection)direction;
+ (void)scrollToElementWithId:(NSString *)elementId inDirection:(GREYDirection)direction andPerformAction:(id<GREYAction>)action;
+ (void)waitForElementToBeEnabled:(NSString *)name elementId:(id<GREYMatcher>)matcher timeout:(CGFloat)timeout;
+ (BOOL)isScrollViewContainingElement:(NSString *)elementId scrolledToEdge:(GREYContentEdge)edge;

@end
