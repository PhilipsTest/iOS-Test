//
//  DemoTimeController.h
//  DemoAppInfra
//
//  Created by Ravi Kiran HR on 6/30/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PhilipsUIKitDLS;

@interface DemoTimeController : UIViewController


@property (weak, nonatomic) IBOutlet UIDLabel *lblCurrentTime;
@property (weak, nonatomic) IBOutlet UIDLabel *lblUTCTime;
@property (weak, nonatomic) IBOutlet UIDLabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIDButton *btnRefresh;
@property (weak, nonatomic) IBOutlet NSTimer *timer;
@property(nonatomic,retain) NSDateFormatter *dateFormatter;
-(IBAction)refreshButtonPress:(id)sender;

@end
