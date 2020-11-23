//
//  UIImageView+UIImageView_DCExternal.h
//  DigitalCareLibrary
//
//  Created by sameer sulaiman on 27/04/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <UIKit/UIKit.h>
typedef void (^DownloadCompletion)(NSError *error);

@interface UIImageView (DCExternal)

@property (nonatomic, copy) NSURL *imgURL;

- (void)imageName:(NSString*)name;
- (void)imageWithURLString:(NSString *)urlString placeholder:(UIImage *)placeholder Completion:(DownloadCompletion)completed;


@end
