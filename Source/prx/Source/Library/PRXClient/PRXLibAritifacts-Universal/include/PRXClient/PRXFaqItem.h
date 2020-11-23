//
//  PRXFaqItem.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 philips. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PRXFaqItem : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *asset;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *head;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
