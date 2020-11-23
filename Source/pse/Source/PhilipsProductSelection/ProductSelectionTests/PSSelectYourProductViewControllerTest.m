//
//  PSSelectYourProductViewControllerTest.m
//  PhilipsProductSelection
//
//  Created by Niharika Bundela on 5/23/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PSConstants.h"
#import "PSProductListViewController.h"
#import "PSSelectYourProductViewController.h"
@import PhilipsUIKitDLS;


@interface PSSelectYourProductViewControllerTest : XCTestCase

@property(nonatomic,retain) PSProductListViewController *listProductVC;
@property(nonatomic,retain) PSSelectYourProductViewController *selectProductVC;
@end
@interface PSSelectYourProductViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgProductDisplay;

@property (weak, nonatomic) IBOutlet UIDButton *btnFindProduct;
@end
@interface PSProductListViewController ()

@end
@implementation PSSelectYourProductViewControllerTest

- (void)setUp {
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryBoardName bundle:StoryboardBundle];
    self.listProductVC = [storyboard instantiateViewControllerWithIdentifier:kProductListViewController];
    [self.listProductVC view];
    self.selectProductVC = [storyboard instantiateViewControllerWithIdentifier:kSelectYourProduct];
    [self.selectProductVC view];
    [self.selectProductVC performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

-(void)testViewControllerExist{
    XCTAssertNotNil(self.selectProductVC.view,@"ViewController should contain a view");
}

-(void)testShowProductListConnection{
    [self.selectProductVC view];
    XCTAssertNotNil([self.selectProductVC imgProductDisplay],@"btnShowProductList should be connected");
    XCTAssertNotNil([self.selectProductVC btnFindProduct],@"btnFindProduct should be connected");
    [self.selectProductVC.btnFindProduct sendActionsForControlEvents: UIControlEventTouchUpInside];
}

#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.listProductVC conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.listProductVC.tblProductListTable.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.listProductVC conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.listProductVC.tblProductListTable.delegate, @"Table delegate cannot be nil");
}

@end
