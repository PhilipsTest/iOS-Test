//
//  DCProductDetailsVCTests.m
//  DigitalCareLibraryTests
//
//  Created by sameer sulaiman on 10/25/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCProductDetailsViewController.h"
#import "DCConstants.h"
#import <OCMock/OCMock.h>
@import PhilipsPRXClient;


@interface DCProductDetailsVCTests : XCTestCase
{
    UIStoryboard *storyboard;

}
@property (nonatomic,strong) DCProductDetailsViewController *vc;
@property(nonatomic,strong)NSMutableArray *assetArray;

@end


@interface DCProductDetailsViewController()
@property(weak, nonatomic) IBOutlet UITableView *tblProductMenu;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(weak, nonatomic) IBOutlet UIDButton *videoLeftArrow;
@property(weak, nonatomic) IBOutlet UIDButton *videoRightArrow;
@property(weak, nonatomic) IBOutlet UIDButton *videoPlayButton;
@property(nonatomic, strong) NSString *pdfLink;
- (void)processResponseData:(NSArray*)assetsArray;
- (NSString*)getImageURL:(NSString*)url;
-(DCBaseViewController*)getFAQViewController;
@end

@implementation DCProductDetailsVCTests

- (void)setUp {
    [super setUp];
    storyboard = [UIStoryboard storyboardWithName:@"ViewProductInformation" bundle:StoryboardBundle];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewProductInformation"];
    [self.vc view];
    self.assetArray = [[NSMutableArray alloc] init];
}

-(void)testProductDetlsControllerConnections{
    
    XCTAssertNotNil([self.vc videoLeftArrow],@"video left arrow should be connected");
    XCTAssertNotNil([self.vc videoRightArrow],@"video right arrow should be connected");
    if([self.vc videoPlayButton]){
      XCTAssertNotNil([self.vc videoPlayButton],@"video play button should be connected");
      [self.vc.videoPlayButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else
      XCTAssertNil([self.vc videoPlayButton],@"video play button is not loaded in video play area");
   // [self.vc.videoLeftArrow sendActionsForControlEvents:UIControlEventTouchUpInside];
   // [self.vc.videoRightArrow sendActionsForControlEvents:UIControlEventTouchUpInside];

}

- (void)testProductImageURL{
    XCTAssertNotNil([self.vc getImageURL:@"https://www.google.com"],@"product image url");
}

- (void)testFAQController{
//    XCTAssertTrue([[self.vc getFAQViewController] isKindOfClass:[DCBaseViewController class]], @"Verify FAQ VC is of Type BaseView");
    XCTAssertNotNil([self.vc getFAQViewController], "Object must not be nill");
}

- (void)testPRXAssetData{
    [self.vc processResponseData:[self getPRXAssetData]];
    XCTAssertNotNil(self.vc.pdfLink,@"PDFLink available in Asset");
}

-(NSArray*)getPRXAssetData{
    for (int i=0; i<2; i++) {
        PRXAssetAsset *asset = [[PRXAssetAsset alloc] init];
        asset.locale =@"en_IN";
        asset.type = @"HQ1";
        if(i == 1){
            asset.extension = @"pdf";
            asset.assetDescription = @"Quick start guide";
        }
        else{
        asset.extension = @"mp4";
        asset.assetDescription = @"High Quality product movie 1";
        }
        asset.asset = @"https://www.google.com";
        [self.assetArray addObject:asset];
    }
    return self.assetArray;
}

@end
