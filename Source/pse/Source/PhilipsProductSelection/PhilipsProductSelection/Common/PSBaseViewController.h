//
//  PSBaseViewController.h
//  ProductSelection
//
//  Created by sameer sulaiman on 1/18/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSProductModelSelectionType.h"

@interface PSBaseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;

@property(nonatomic,strong)PSProductModelSelectionType *productModel;

-(PSProductModelSelectionType *)getProductModelSelectionType;

@end
