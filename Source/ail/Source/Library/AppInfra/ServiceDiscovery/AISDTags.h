//
//  Tags.h
//
//  Created by Ravi Kiran HR on 6/14/16
 /* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/ 

#import <Foundation/Foundation.h>



@interface AISDTags : NSObject 

@property (nonatomic, strong) NSString *tagsIdentifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *key;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
