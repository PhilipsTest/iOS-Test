//
//  DemoServiceDiscoveryViewController.h
//  DemoAppInfra
//
//  Created by Ravi Kiran HR on 6/2/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DemoServiceDiscoveryViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDTextField *tfServiceID;


@end
