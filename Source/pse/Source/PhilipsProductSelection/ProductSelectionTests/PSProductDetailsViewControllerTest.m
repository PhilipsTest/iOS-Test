//
//  PSProductDetailsViewControllerTest.m
//  PhilipsProductSelection
//
//  Created by Niharika Bundela on 6/1/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PSProductDetailsViewController.h"
#import "PSConstants.h"
#import "AppDelegate.h"
#import "PSAppInfraWrapper.h"

@import PhilipsUIKitDLS;
@interface PSProductDetailsViewControllerTest : XCTestCase
@property(nonatomic,retain) PSProductDetailsViewController *detailProductVC;
@end
@interface PSProductDetailsViewController (Test)
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
//@property(strong, nonatomic) NSMutableArray *prxAssetImageArray;
@property (weak, nonatomic) IBOutlet UIDButton *btnSelectProduct;
- (NSString*)getImageURL:(NSString*)url;

@end
@implementation PSProductDetailsViewControllerTest

- (void)setUp {
    [super setUp];
    //kProductDetail
    /*
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryBoardName bundle:StoryboardBundle];
     self.listProductVC = [storyboard instantiateViewControllerWithIdentifier:kProductListViewController];
     [self.listProductVC view];

     */
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryBoardName bundle:StoryboardBundle];
    self.detailProductVC = [storyboard instantiateViewControllerWithIdentifier:kProductDetail];
    
    //PRXDependencies *prxDependencies = [[PRXDependencies alloc]init];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //prxDependencies.appInfra = appDelegate.appInfra;
    [PSAppInfraWrapper sharedInstance].appInfra = appDelegate.appInfra;
    
    
    
    [self.detailProductVC view];
}

#pragma mark - UICollectionView tests
- (void)testThatViewConformsToUICollectionViewDataSource
{
    XCTAssertTrue([self.detailProductVC conformsToProtocol:@protocol(UICollectionViewDataSource)], @"View does not conform to UITableView datasource protocol");
}

//- (void)testThatCollectionViewHasDataSource
//{
//    XCTAssertNotNil(self.detailProductVC.collectionView.dataSource, @"Table datasource cannot be nil");
//}

- (void)testThatViewConformsToUICollectionViewDelegate
{
    XCTAssertTrue([self.detailProductVC conformsToProtocol:@protocol(UICollectionViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

//- (void)testCollectionViewIsConnectedToDelegate
//{
//    XCTAssertNotNil(self.detailProductVC.collectionView.delegate, @"Table delegate cannot be nil");
//}

-(void)testPRoductDetailConnection{
    XCTAssertNotNil([self.detailProductVC btnSelectProduct],@"btnSelectProduct should be connected");
    [self.detailProductVC.btnSelectProduct sendActionsForControlEvents: UIControlEventTouchUpInside];
}

-(void)testGetImageURL
{
    NSString *url = @"https://images.philips.com/is/image/PhilipsConsumer/SCF693_17-APP-global-001";
    NSString *imString = [NSString stringWithFormat:kImageURLFormat,url,self.detailProductVC.collectionView.frame.size.width,self.detailProductVC.collectionView.frame.size.height];
    NSString *resulString = [self.detailProductVC getImageURL:url];
    XCTAssertEqualObjects(imString,resulString,@"imString and resulString should be equal");
}
@end
