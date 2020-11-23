//
//  DCImagePickerTests.m
//  DigitalCareLibraryTests
//
//  Created by sameer sulaiman on 10/24/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DCImagePickerController.h"

@interface DCImagePickerTests : XCTestCase
@property (nonatomic,strong)DCImagePickerController *imagePicker;
@end

@implementation DCImagePickerTests

- (void)testDCImagePicker {
    _imagePicker = [[DCImagePickerController alloc] init];
    XCTAssertTrue([_imagePicker isKindOfClass:[UIImagePickerController class]], @"Class type must be UIImagePickerController class");
     XCTAssertTrue([_imagePicker supportedInterfaceOrientations],@"DCImagePicker Orienation is not nil");
}

@end
