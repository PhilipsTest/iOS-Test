//
//  PSHardcodedProductList.h
//  ProductSelection
//
//  Created by sameer sulaiman on 2/9/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSProductModelSelectionType.h"

@interface PSHardcodedProductList : PSProductModelSelectionType

@property (strong,nonatomic) NSArray *hardcodedProductListArray;

-(id)initWithArray:(NSArray *)hardCodedProductList;
@end
