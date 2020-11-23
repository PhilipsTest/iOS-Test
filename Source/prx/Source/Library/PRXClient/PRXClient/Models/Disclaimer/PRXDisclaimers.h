//
//  PRXDisclaimers.h
//  PRXClient
//
//  Created by Prasad Devadiga on 11/09/18.
//  Copyright © 2018 Koninklijke Philips N.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRXDisclaimers : NSObject

@property (nonatomic, strong) NSArray *disclaimer;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
