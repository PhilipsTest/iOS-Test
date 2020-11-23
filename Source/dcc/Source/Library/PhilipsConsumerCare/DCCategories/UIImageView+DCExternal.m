//
//  UIImageView+UIImageView_DCExternal.m
//  DigitalCareLibrary
//
//  Created by sameer sulaiman on 27/04/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import "UIImageView+DCExternal.h"
#import "DCConstants.h"
#import <objc/runtime.h>

static char URL_KEY;

@implementation UIImageView (DCExternal)
@dynamic imgURL;

-(void)imageName:(NSString*)name{
    self.image = [UIImage imageNamed:name
                            inBundle:StoryboardBundle compatibleWithTraitCollection:nil];
}

// Image Downloading
- (void)imageWithURLString:(NSString *)urlString placeholder:(UIImage *)placeholder Completion:(DownloadCompletion)completed {
    self.imgURL = [NSURL URLWithString:urlString];
    self.image = placeholder;
    UIImage *cachedImage = [self getCachedImage:urlString];
    if (cachedImage) {
        self.imgURL   = nil;
        self.image    = cachedImage;
        completed(nil);
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        UIImage *imageFromData = [UIImage imageWithData:data];
        [self cacheImage:imageFromData WithURLString:urlString];
        if (imageFromData) {
            if ([self.imgURL.absoluteString isEqualToString:urlString]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.image = imageFromData;
                    completed(nil);
                });
            } else {
                //don't set image the url has changed already
            }
        }
        self.imgURL = nil;
    });
}

- (void)cacheImage:(UIImage *)image WithURLString:(NSString *)urlString{
    // Generate a unique path to a resource representing the image you want
    NSString *filename = [urlString stringByReplacingOccurrencesOfString:@"//" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    NSString *uniquePath = [cacheDirectory stringByAppendingPathComponent:filename];
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath]){
        // Check if PNG or JPG/JPEG?
        if([urlString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
            [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
        else if(
                [urlString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
                [urlString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
                )
            [UIImageJPEGRepresentation(image, 1.0) writeToFile: uniquePath atomically: YES];
    }
}

- (UIImage*)getCachedImage:(NSString*)ImageURLString{
    NSString *filename = [ImageURLString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"/" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"//" withString:@""];
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    NSString *uniquePath = [cacheDirectory stringByAppendingPathComponent:filename];
    UIImage *image = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
        image = [UIImage imageWithContentsOfFile: uniquePath];
    return image;
}

- (void)setImgURL:(NSURL *)newImageURL {
    objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*)imgURL {
    return objc_getAssociatedObject(self, &URL_KEY);
}

@end
