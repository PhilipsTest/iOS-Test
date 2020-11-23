//
//  DemoTimeController.m
//  DemoAppInfra
//
//  Created by Ravi Kiran HR on 6/30/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoTimeController.h"
#import <AppInfra/AppInfra.h>
#import "AilShareduAppDependency.h"
@import PhilipsUIKitDLS;
@import TrueTime;


@implementation DemoTimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Time";
  
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat: @"MM-dd-yyyy hh:mm:ss a"];
    [self updateTime];
    self.btnRefresh.enabled = true;
    
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackPageWithInfo:@"Time" params:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeSyncCompleted) name:@"kNHNetworkTimeSyncCompleteNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeSyncCompleted) name:TrueTimeUpdatedNotification object:nil];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.btnRefresh.enabled = true;
            [self updateTime];
            
        });

    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

-(void)timeSyncCompleted
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.btnRefresh.enabled = true;
        [self updateTime];

    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)utcTimeString{
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setDateFormat: @"MM-dd-yyyy hh:mm:ss a"];
    [utcDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return  [utcDateFormatter stringFromDate:[[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.time getUTCTime]];
    
}

-(void)updateTime{
  
    self.lblCurrentTime.text = [self.dateFormatter stringFromDate:[NSDate date]];
    self.lblUTCTime.text = [self utcTimeString];
    self.lblStatus.text = [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.time isSynchronized]?@"synchronised":@"not synchronised";
}

-(IBAction)refreshButtonPress:(id)sender{
    self.btnRefresh.enabled = false;
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.time refreshTime];
    [self updateTime];
    
}

-(IBAction)updateTimeButtonPress:(id)sender{
    [self updateTime];
    
}
@end
