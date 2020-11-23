//
//  PSHardcodedProductList.m
//  ProductSelection
//
//  Created by sameer sulaiman on 2/9/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "PSHardcodedProductList.h"

@implementation PSHardcodedProductList

-(id)initWithArray:(NSArray *)hardCodedProductList
{
    self =[super init];
    if(self)
    {
        self.hardcodedProductListArray=hardCodedProductList;
    }
    return self;
}

@end
