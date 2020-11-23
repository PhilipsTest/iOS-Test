//
//  PSSelectedProductViewControllerTest.m
//  PhilipsProductSelection
//
//  Created by Niharika Bundela on 6/2/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PSSelectedProductViewController.h"
#import "PSConstants.h"
@import PhilipsUIKitDLS;
@interface PSSelectedProductViewControllerTest : XCTestCase
@property(nonatomic,retain) PSSelectedProductViewController *selectedProductVC;

@end

@implementation PSSelectedProductViewControllerTest

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryBoardName bundle:StoryboardBundle];
    self.selectedProductVC = [storyboard instantiateViewControllerWithIdentifier:kSelectedProductViewController];
    [self.selectedProductVC view];
}

@end
