//
//  DemoAppIdentityController.h
//  DemoAppInfra
//
//  Created by Ravi Kiran HR on 6/14/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DemoAppIdentityController : UIViewController

@property (weak, nonatomic) IBOutlet UIDLabel *appName;
@property (weak, nonatomic) IBOutlet UIDLabel *localizedAppName;
@property (weak, nonatomic) IBOutlet UIDLabel *appVersion;
@property (weak, nonatomic) IBOutlet UIDLabel *appState;
@property (weak, nonatomic) IBOutlet UIDLabel *micrositeId;
@property (weak, nonatomic) IBOutlet UIDLabel *sector;
@property (weak, nonatomic) IBOutlet UIDLabel *lblServiceDiscEnv;


@end
