//
//  PRXFaqChapter.h
//
//  Created by KRISHNA KUMAR on 28/10/15
//  Copyright (c) 2015 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PRXFaqChapter : NSObject

@property (nonatomic, strong) NSString *referenceName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *rank;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
