//
//  PRXDisclaimer.h
//  PRXClient
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRXDisclaimer : NSObject

@property (nonatomic, strong) NSString *disclaimerText;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *referenceName;
@property (nonatomic, strong) NSArray *disclaimElements;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
