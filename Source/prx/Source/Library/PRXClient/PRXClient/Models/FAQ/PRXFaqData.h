//
//  PRXFaqData.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRXFaqRichTexts;

@interface PRXFaqData : NSObject

@property (nonatomic, strong) PRXFaqRichTexts *richTexts;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
