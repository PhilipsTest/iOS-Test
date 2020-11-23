//
//  MatchByLanguage.h
//
//  Created by Ravi Kiran HR on 6/14/16
 /* Copyright (c) Koninklijke Philips N.V., 2016
* All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
*/ 

#import <Foundation/Foundation.h>



@interface AISDMatchByLanguage : NSObject 

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, assign) BOOL available;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end
