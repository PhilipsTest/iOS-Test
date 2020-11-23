//
//  PRXFaqRichText.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRXFaqChapter;

@interface PRXFaqRichText : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) PRXFaqChapter *chapter;
@property (nonatomic, strong) NSArray *item;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
