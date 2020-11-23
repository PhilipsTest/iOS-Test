//
//  PSProductModelSelectionType.h
//  ProductSelection
//
//  Created by sameer sulaiman on 2/9/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PhilipsPRXClient/PRXRequestEnums.h>

@interface PSProductModelSelectionType : NSObject

@property (nonatomic, assign)Catalog catalog;
@property (nonatomic, assign)Sector sector;
@property (nonatomic, strong)NSArray *prxSummaryList;

@end
