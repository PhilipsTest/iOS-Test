//
//  DemoInternationalization.h
//  DemoAppInfra
//
//  Created by Ravi Kiran HR on 14/07/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DemoInternationalization : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblLocaleID;
@property (weak, nonatomic) IBOutlet UILabel *lblLocaleString;
@property (weak, nonatomic) IBOutlet UILabel *lblLocaleOSString;
@property (weak, nonatomic) IBOutlet UIDLabel *lblHSDPLocale;
@end
