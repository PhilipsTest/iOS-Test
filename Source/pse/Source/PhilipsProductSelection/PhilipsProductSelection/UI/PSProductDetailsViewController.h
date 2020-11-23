//
//  PSProductDetailsViewController.h
//  ProductSelection
//
//  Created by sameer sulaiman on 1/27/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSBaseViewController.h"
#import <PhilipsPRXClient/PRXSummaryData.h>

@interface PSProductDetailsViewController : PSBaseViewController

@property (nonatomic, strong) PRXSummaryData *selectedProduct;
-(void)fetchProductAsset;
-(void)updateDetailsUI;
@end
