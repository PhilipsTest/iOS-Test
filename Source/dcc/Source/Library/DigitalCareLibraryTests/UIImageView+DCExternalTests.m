//
//  UIImageView+DCExternalTests.m
//  DigitalCareLibraryTests
//
//  Created by sameer sulaiman on 10/24/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIImageView+DCExternal.h"
#import "DCHandler.h"
#import "DCConsumerProductInformation.h"
#import "DCConstants.h"

@interface UIImageView_DCExternalTests : XCTestCase
@property(nonatomic,strong)UIImageView *imageView;
@end

@implementation UIImageView_DCExternalTests

- (void)testImageWithURL {
    [_imageView imageWithURLString:[[DCHandler getConsumerProductInfo] productImageURL]
                       placeholder:[UIImage imageNamed:kImageThumbNail
                                              inBundle:StoryboardBundle
                         compatibleWithTraitCollection:nil] Completion:^(NSError *error) {
                           XCTAssertNotNil(_imageView.image,@"image downloaded successfully from the server");
                           if(error)
                               XCTAssertNotNil(error,@"Error from server");
                       }];
}

@end
