//
//  ValidationHelper.m
//  Registration
//
//  Created by Adarsh Kumar Rai on 18/07/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import "ValidationHelper.h"
@import PhilipsUIKitDLS;
@import PhilipsIconFontDLS;

@implementation ValidationHelper

#pragma mark - Visibility Validation
#pragma mark -

+ (BOOL)isElementWithIdCompletelyVisible:(NSString *)accessibilityId {
    NSError *error = nil;
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(accessibilityId)] assertWithMatcher:grey_minimumVisiblePercent(0.98) error:&error];
    return (error == nil);
}


+ (BOOL)isElementWithIdSufficientlyVisible:(NSString *)accessibilityId {
    NSError *error = nil;
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(accessibilityId)] assertWithMatcher:grey_sufficientlyVisible() error:&error];
    return (error == nil);
}


+ (BOOL)isElementWithIdPartiallyVisible:(NSString *)accessibilityId {
    NSError *error = nil;
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(accessibilityId)] assertWithMatcher:grey_minimumVisiblePercent(0.25) error:&error];
    return (error == nil);
}


+ (BOOL)isDLSAlertForErrorIsDisplayed {
    __block BOOL isAlertShown = NO;
    GREYAssertionBlock *assertionBlock = [GREYAssertionBlock assertionWithName:@"" assertionBlockWithError:^BOOL(id element, NSError *__strong *errorOrNil) {
        NSString *errorReason = nil;
        if (element == nil) {
            errorReason = @"Window on this element is nil";
        }
        UIViewController *topPresentedController = [element rootViewController];
        while (topPresentedController.presentedViewController) {
            topPresentedController = topPresentedController.presentedViewController;
        }
        if ([topPresentedController isKindOfClass:[UIDAlertController class]]) {
            isAlertShown = YES;
        }
        return isAlertShown;
    }];

    NSError *assertionError;
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] assert:assertionBlock error:&assertionError];
    return (assertionError == nil);
}


+ (void)assertThatElementWithIdIsSufficientlyVisible:(NSString *)elementId {
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_sufficientlyVisible()];
}


+ (void)assertThatElementWithIdIsCompletelyVisible:(NSString *)elementId {
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_minimumVisiblePercent(0.98)];
}


+ (void)assertThatElementWithIdIsPartiallyVisible:(NSString *)elementId {
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_minimumVisiblePercent(0.25)];
}


+ (void)assertThatElementWithIdIsInvisible:(NSString *)elementId {
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_notVisible()];
}


+ (void)assertThatElementWithIdIsNotEnabled:(NSString *)elementId {
    NSError *assertionError;
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_enabled() error:&assertionError];
    NSString *assertionFailureReason = [NSString stringWithFormat:@"Element with id '%@' was expected to be disabled, but its found enabled", elementId];
    GREYAssertNotNil(assertionError, assertionFailureReason);
}


+ (void)assertThatElementWithIdIsEnabled:(NSString *)elementId {
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_enabled()];
}
#pragma mark - Tap Action
#pragma mark -

+ (void)tapButtonWithId:(NSString *)buttonAccessibilityId {
    [[[EarlGrey selectElementWithMatcher:grey_accessibilityID(buttonAccessibilityId)] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_tap()];
}


+ (void)tapElementWithText:(NSString *)elementText {
    GREYActionBlock *action = [GREYActionBlock actionWithName:@"something" performBlock:^BOOL(id element, NSError *__strong *errorOrNil) {
        CGFloat x = [(UILabel *)element frame].origin.x + 30;
        CGFloat y = [(UILabel *)element frame].size.height / 2;
        [[[EarlGrey selectElementWithMatcher:grey_text(elementText)] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_tapAtPoint(CGPointMake(x, y))];
        return YES;
    }];
    
    [[[EarlGrey selectElementWithMatcher:grey_text(elementText)] assertWithMatcher:grey_sufficientlyVisible()] performAction:action];
}


+ (void)tapDLSAlertActionWithTitle:(NSString *)actionTitle {
    [[[EarlGrey selectElementWithMatcher:grey_allOf(grey_ancestor(grey_kindOfClass(NSClassFromString(@"PhilipsUIKitDLS.DialogView"))), grey_kindOfClass([UIDButton class]), grey_buttonTitle(actionTitle), nil)] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_tap()];
}


+ (void)tapCloseErrorNotification {
    NSString *title = [PhilipsDLSIcon unicodeWithIconType:PhilipsDLSIconTypeCrossBold32];
    [[[EarlGrey selectElementWithMatcher:grey_allOf(grey_kindOfClass([UIButton class]), grey_ancestor(grey_kindOfClass([UIDNotificationBarView class])), grey_buttonTitle(title), nil)] assertWithMatcher:grey_sufficientlyVisible()] performAction:grey_tap()];
}

#pragma mark - Content Validation
#pragma mark -

+ (BOOL)buttonWithId:(NSString *)accessibilityId hasTitle:(NSString *)title {
    NSError *error = nil;
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(accessibilityId)] assertWithMatcher:grey_buttonTitle(title) error:&error];
    return (error == nil);
}


+ (void)assertThatElementWithId:(NSString *)elementId hasText:(NSString *)text {
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_text(text)];
}


+ (void)assertThatButtonWithId:(NSString *)buttonId hasTitle:(NSString *)title andWidth:(CGFloat)width {
    GREYAssertionBlock *assertionBlock = [GREYAssertionBlock assertionWithName:@"Button title and width assertion" assertionBlockWithError:^BOOL(id element, NSError *__strong *errorOrNil) {
        if ([element isKindOfClass:[UIDButton class]] || [element isKindOfClass:[UIDSocialButton class]]) {
            UIDButton *button = (UIDButton *)element;
            NSString *assertionFailureReason;
            if (title.length > 0) {
                assertionFailureReason = [NSString stringWithFormat:@"Button title '%@' is no equal to expected title '%@'", button.currentTitle, title];
                GREYAssertTrue([button.currentTitle isEqualToString:title], assertionFailureReason);
            }
            if (width > 0) {
                assertionFailureReason = [NSString stringWithFormat:@"Button width '%f' is not equal to expected width '%f'", button.frame.size.width, width];
                GREYAssertEqual(button.frame.size.width, width, assertionFailureReason);
            }
            assertionFailureReason = [NSString stringWithFormat:@"Button height '%f' is not equal to standard DLS button height '40'", button.frame.size.height];
            if ([element isKindOfClass:[UIDButton class]]) {
                GREYAssertEqual(lroundf(button.frame.size.height), 40, assertionFailureReason);
            } else {
                GREYAssertEqual(lroundf(button.frame.size.height), 32, assertionFailureReason);
            }
            return YES;
        } else {
            if (errorOrNil) {
                NSString *errorReason = @"Provided accessibility identifier does not belong to a UIDButton";
                *errorOrNil = [NSError errorWithDomain:kGREYInteractionErrorDomain code:kGREYInteractionElementNotFoundErrorCode
                                              userInfo:@{kGREYAssertionErrorUserInfoKey : errorReason,
                                                         NSLocalizedDescriptionKey: errorReason}];
            }
            return NO;
        }
    }];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(buttonId)] assert:assertionBlock];
}


+ (BOOL)isCurrentScreenTitleEqualTo:(NSString *)title {
    NSString *assertionTitle = [NSString stringWithFormat:@"Screen Title Assertion for title '%@'", title];
    GREYAssertionBlock *assertionBlock = [GREYAssertionBlock assertionWithName:assertionTitle assertionBlockWithError:^BOOL(id element, NSError *__strong *errorOrNil) {
        NSString *errorReason = nil;
        if ([element window] == nil) {
            errorReason = @"Window on this element is nil";
        }
        UINavigationItem *titleItem = [(UINavigationBar *)element topItem];
        if (![titleItem.title isEqualToString:title]) {
            errorReason = @"Title did not match";
        }
        if (errorReason) {
            if (errorOrNil) {
                *errorOrNil = [NSError errorWithDomain:kGREYInteractionErrorDomain code:kGREYInteractionElementNotFoundErrorCode
                                              userInfo:@{kGREYAssertionErrorUserInfoKey : errorReason,
                                                         NSLocalizedDescriptionKey: errorReason}];
            }
            return NO;
        }
        return YES;
    }];
    NSError *assertionError;
    [[EarlGrey selectElementWithMatcher:grey_kindOfClass([UINavigationBar class])] assert:assertionBlock error:&assertionError];
    return (assertionError == nil);
}


+ (void)assertThatCurrentScreenHasTitle:(NSString *)title {
    NSString *assertionDescription = [NSString stringWithFormat:@"Expected current screen title to be '%@' but could not match it", title];
    GREYAssertTrue([self isCurrentScreenTitleEqualTo:title], assertionDescription);
}


+ (void)assertThatDLSAlertIsDisplayedWithTitle:(NSString *)title message:(NSString *)message andActionTitles:(NSArray<NSString *> *)actionTitles {
    NSString *assertionTitle = [NSString stringWithFormat:@"Alert Displayed Assertion for alert title '%@'", title];
    GREYAssertionBlock *assertionBlock = [GREYAssertionBlock assertionWithName:assertionTitle assertionBlockWithError:^BOOL(id element, NSError *__strong *errorOrNil) {
        NSString *errorReason = nil;
        if (element == nil) {
            errorReason = @"Window on this element is nil";
        }
        UIViewController *topPresentedController = [element rootViewController];
        while (topPresentedController.presentedViewController) {
            topPresentedController = topPresentedController.presentedViewController;
        }
        if (![topPresentedController isKindOfClass:[UIDAlertController class]]) {
            errorReason = [NSString stringWithFormat:@"Top controller in keyWindow is not UIDAlertController. This could make the alert either non-visible or non-interactable to user."];
        } else {
            UIDAlertController *controller = (UIDAlertController *)topPresentedController;
            if (![controller.title isEqualToString:title]) {
                errorReason = [NSString stringWithFormat:@"Alert title '%@' is not equal to expected title '%@'.", controller.title, title];
            } else if (![controller.message isEqualToString:message]) {
                errorReason = [NSString stringWithFormat:@"Alert message '%@' is not equal to expected message '%@'.", controller.message, message];
            } else {
                for (NSUInteger index = 0; index < actionTitles.count; index++) {
                    NSString *actionTitle = controller.actions[index].title;
                    NSString *expectedTitle = actionTitles[index];
                    if (![actionTitle isEqualToString:expectedTitle]) {
                        errorReason = [NSString stringWithFormat:@"Action title '%@' is not equal to expected title '%@'.", actionTitle, expectedTitle];
                    }
                }
            }
        }
        
        if (errorReason) {
            if (errorOrNil) {
                *errorOrNil = [NSError errorWithDomain:kGREYInteractionErrorDomain code:kGREYInteractionElementNotFoundErrorCode
                                              userInfo:@{kGREYAssertionErrorUserInfoKey : errorReason,
                                                         NSLocalizedDescriptionKey: errorReason}];
            }
            return NO;
        }
        return YES;
    }];
    [[EarlGrey selectElementWithMatcher:grey_keyWindow()] assert:assertionBlock];
}


+ (void)assertThatErrorNotificationIsDisplayedWithMessage:(NSString *)errorMessage {
    NSString *assertionTitle = [NSString stringWithFormat:@"Error notification displayed for erorr message '%@'", errorMessage];
    GREYAssertionBlock *assertionBlock = [GREYAssertionBlock assertionWithName:assertionTitle assertionBlockWithError:^BOOL(id element, NSError *__strong *errorOrNil) {
        NSString *errorReason = nil;
        if (element == nil || ![element isKindOfClass:[UIDNotificationBarView class]]) {
            errorReason = @"Could not find the notfication in UI.";
        } else {
            UIDNotificationBarView *notification = (UIDNotificationBarView *)element;
            if (![errorMessage isEqualToString:notification.titleMessage]) {
                errorReason = [NSString stringWithFormat:@"Could not match provided error message '%@' with displayed error message '%@'.", errorMessage, notification.titleMessage];
            }
        }
        if (errorReason) {
            if (errorOrNil) {
                *errorOrNil = [NSError errorWithDomain:kGREYInteractionErrorDomain code:kGREYInteractionAssertionFailedErrorCode
                                              userInfo:@{kGREYAssertionErrorUserInfoKey : errorReason,
                                                         NSLocalizedDescriptionKey: errorReason}];
            }
            return NO;
        }
        return YES;
    }];
    [[EarlGrey selectElementWithMatcher:grey_allOf(grey_kindOfClass([UIDNotificationBarView class]), grey_sufficientlyVisible(), grey_interactable(), nil)] assert:assertionBlock];
}

#pragma mark - Layout Validation
#pragma mark - 

+ (void)assertThatElementWithId:(NSString *)elementId isOnLeftOfElementWithId:(NSString *)referenceElementId byPoints:(double)points {
    GREYLayoutConstraint *onTheLeft = [GREYLayoutConstraint layoutConstraintWithAttribute:kGREYLayoutAttributeRight
                                                                                 relatedBy:kGREYLayoutRelationEqual
                                                                      toReferenceAttribute:kGREYLayoutAttributeLeft
                                                                                multiplier:1.0
                                                                                  constant:-points];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_layout(@[onTheLeft], grey_accessibilityID(referenceElementId))];
}

+ (void)assertThatElementWithId:(NSString *)elementId isOnRightOfElementWithId:(NSString *)referenceElementId byPoints:(double)points {
    GREYLayoutConstraint *onTheRight = [GREYLayoutConstraint layoutConstraintWithAttribute:kGREYLayoutAttributeLeft
                                                                                 relatedBy:kGREYLayoutRelationEqual
                                                                      toReferenceAttribute:kGREYLayoutAttributeRight
                                                                                multiplier:1.0
                                                                                  constant:points];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_layout(@[onTheRight], grey_accessibilityID(referenceElementId))];
}

+ (void)assertThatElementWithId:(NSString *)elementId isAboveElementWithId:(NSString *)referenceElementId byPoints:(double)points {
    GREYLayoutConstraint *above = [GREYLayoutConstraint layoutConstraintWithAttribute:kGREYLayoutAttributeBottom
                                                                            relatedBy:kGREYLayoutRelationEqual
                                                                 toReferenceAttribute:kGREYLayoutAttributeTop
                                                                           multiplier:1.0
                                                                             constant:-points];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_layout(@[above], grey_accessibilityID(referenceElementId))];
}

+ (void)assertThatElementWithId:(NSString *)elementId isBelowElementWithId:(NSString *)referenceElementId byPoints:(double)points {
    GREYLayoutConstraint *below = [GREYLayoutConstraint layoutConstraintWithAttribute:kGREYLayoutAttributeTop
                                                                                 relatedBy:kGREYLayoutRelationEqual
                                                                      toReferenceAttribute:kGREYLayoutAttributeBottom
                                                                                multiplier:1.0
                                                                                  constant:points];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_layout(@[below], grey_accessibilityID(referenceElementId))];
}

+ (void)assertThatElementWithId:(NSString *)elementId hasMarginOf:(double)points inDirection:(GREYLayoutDirection)direction {
    GREYLayoutAttribute attribute;
    switch (direction) {
        case kGREYLayoutDirectionLeft:
            attribute = kGREYLayoutAttributeLeft;
            break;
        case kGREYLayoutDirectionRight:{
            attribute = kGREYLayoutAttributeRight;
            points *= -1;
        }
            break;
        case kGREYLayoutDirectionUp: {
            attribute = kGREYLayoutAttributeTop;
            UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
            CGFloat navBarHeight = 0;
            if ([controller isKindOfClass:[UINavigationController class]]) {
                navBarHeight = [(UINavigationController *)controller navigationBar].frame.size.height;
            } else if (controller.navigationController) {
                navBarHeight = [controller.navigationController navigationBar].frame.size.height;
            }
            points += UIApplication.sharedApplication.statusBarFrame.size.height;
            points += navBarHeight;
        }
            break;
        case kGREYLayoutDirectionDown:{
            attribute = kGREYLayoutAttributeBottom;
            points *= -1;
        }
            break;
    }
    GREYLayoutConstraint *below = [GREYLayoutConstraint layoutConstraintWithAttribute:attribute
                                                                            relatedBy:kGREYLayoutRelationEqual
                                                                 toReferenceAttribute:attribute
                                                                           multiplier:1.0
                                                                             constant:points];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(elementId)] assertWithMatcher:grey_layout(@[below], grey_keyWindow())];
}


+ (void)assertThatTextFieldWithId:(NSString *)textFieldId hasErrorMessageDisplayed:(NSString *)errorMessage {
    NSString *assertionTitle = [NSString stringWithFormat:@"UIDTextField Error Assertion for error '%@'", errorMessage];
    GREYAssertionBlock *assertionBlock = [GREYAssertionBlock assertionWithName:assertionTitle assertionBlockWithError:^BOOL(id element, NSError *__strong *errorOrNil) {
        NSString *errorReason = nil;
        if ([element window] == nil) {
            errorReason = @"Window on this element is nil";
        } else if (![(UIDTextField *)element isValidationVisible]) {
            errorReason = @"Validation message not visible on text field";
        } else if (![[(UIDTextField *)element validationMessage] isEqualToString:errorMessage]) {
            errorReason = [NSString stringWithFormat:@"TextField error message '%@' does not match the message provided '%@'", [(UIDTextField *)element validationMessage], errorMessage];
        }
        if (errorReason) {
            if (errorOrNil) {
                *errorOrNil = [NSError errorWithDomain:kGREYInteractionErrorDomain code:kGREYInteractionElementNotFoundErrorCode
                                              userInfo:@{kGREYAssertionErrorUserInfoKey : errorReason,
                                                         NSLocalizedDescriptionKey: errorReason}];
            }
            return NO;
        }
        return YES;
    }];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(textFieldId)] assert:assertionBlock];
}


+ (void)assertThatTextFieldWithIdHasNoErrorMessageDisplayed:(NSString *)textFieldId {
    NSString *assertionTitle = [NSString stringWithFormat:@"UIDTextField No-Error Assertion"];
    GREYAssertionBlock *assertionBlock = [GREYAssertionBlock assertionWithName:assertionTitle assertionBlockWithError:^BOOL(id element, NSError *__strong *errorOrNil) {
        NSString *errorReason = nil;
        if ([element window] == nil) {
            errorReason = @"Window on this element is nil";
        } else if ([(UIDTextField *)element isValidationVisible]) {
            errorReason = @"Validation message visible on text field";
        }
        if (errorReason) {
            if (errorOrNil) {
                *errorOrNil = [NSError errorWithDomain:kGREYInteractionErrorDomain code:kGREYInteractionElementNotFoundErrorCode
                                              userInfo:@{kGREYAssertionErrorUserInfoKey : errorReason,
                                                         NSLocalizedDescriptionKey: errorReason}];
            }
            return NO;
        }
        return YES;
    }];
    [[EarlGrey selectElementWithMatcher:grey_accessibilityID(textFieldId)] assert:assertionBlock];
}

#pragma mark - Utility Methods
#pragma mark -

+ (void)tapNavigationBackButton {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if ([topController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)topController popViewControllerAnimated:YES];
    }
}


+ (void)waitForElementWithName:(NSString *)name elementMatcher:(id<GREYMatcher>)matcher timeout:(CGFloat)timeout {
    [[GREYCondition conditionWithName:[@"Wait For Element With Name: " stringByAppendingString:name]
                                block:^BOOL {
                                    NSError *error = nil;
                                    [[EarlGrey selectElementWithMatcher:matcher]
                                     assertWithMatcher:grey_sufficientlyVisible() error:&error];
                                    return error == nil;
                                }] waitWithTimeout:timeout];
}


+ (void)waitForElementToBeEnabled:(NSString *)name elementId:(id<GREYMatcher>)matcher timeout:(CGFloat)timeout {
    [[GREYCondition conditionWithName:[@"Wait For Element With Name: " stringByAppendingString:name]
                                block:^BOOL {
                                    NSError *error = nil;
                                    [[EarlGrey selectElementWithMatcher:matcher]
                                     assertWithMatcher:grey_enabled() error:&error];
                                    return error == nil;
                                }] waitWithTimeout:timeout];
}


+ (CGFloat)horizontalMarginForCurrentSizeClass {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (topController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        return ([UIApplication sharedApplication].keyWindow.bounds.size.width - 648)/2;
    }
    return 16;
}


+ (CGFloat)verticalMarginForCurrentSizeClass {
    return 24;
}


+ (void)scrollToElementWithId:(NSString *)elementId inDirection:(GREYDirection)direction {
    [[[EarlGrey selectElementWithMatcher:grey_allOf(grey_accessibilityID(elementId), grey_sufficientlyVisible(), nil)] usingSearchAction:grey_scrollInDirection(direction, 50) onElementWithMatcher:grey_allOf(grey_kindOfClass([UIScrollView class]), grey_descendant(grey_accessibilityID(elementId)), nil)] assertWithMatcher:grey_sufficientlyVisible()];
}


+ (void)scrollToElementWithId:(NSString *)elementId inDirection:(GREYDirection)direction andPerformAction:(id<GREYAction>)action {
    [[[[EarlGrey selectElementWithMatcher:grey_allOf(grey_accessibilityID(elementId), grey_sufficientlyVisible(), nil)] usingSearchAction:grey_scrollInDirection(direction, 50) onElementWithMatcher:grey_allOf(grey_kindOfClass([UIScrollView class]), grey_descendant(grey_accessibilityID(elementId)), nil)] assertWithMatcher:grey_sufficientlyVisible()] performAction:action];
}


+ (BOOL)isScrollViewContainingElement:(NSString *)elementId scrolledToEdge:(GREYContentEdge)edge {
    NSError *error;
    [[EarlGrey selectElementWithMatcher:grey_allOf(grey_kindOfClass([UIScrollView class]), grey_descendant(grey_accessibilityID(elementId)), nil)] assertWithMatcher:grey_scrolledToContentEdge(edge) error:&error];
    return error == nil;
}

@end
