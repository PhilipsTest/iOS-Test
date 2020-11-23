//
//  ViewController.m
//  ProductSelection
//
//  Created by KRISHNA KUMAR on 13/01/16.
//  Copyright © 2016 KRISHNA KUMAR. All rights reserved.
//

#import "ViewController.h"
#import "PSSelectYourProductViewController.h"
#import "PSConstants.h"
#import "PSHandler.h"
#import "PSHardcodedProductList.h"
#import "AppDelegate.h"
@import PhilipsUIKitDLS;
@interface ViewController ()
{
    NSInteger colorRange;
    NSInteger tonalRange;
}

@property (weak, nonatomic) IBOutlet UIDButton *btnChangeTheme;
@property (weak, nonatomic) IBOutlet UIDButton *btnLaunchProductSelection;
- (IBAction)launchProductSelection:(id)sender;
- (IBAction)ChangeTheme:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ProductSelectionDemo";
    colorRange = UIDColorRangeGroupBlue;
    tonalRange = UIDTonalRangeBright;
   // [[AppDelegate sharedAppDelegate].appInfra.serviceDiscovery setHomeCountry:@"GB"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)launchProductSelection:(id)sender
{
    // Invoking Product Selection Lib
    PSHardcodedProductList *hardcodedList = [[PSHardcodedProductList alloc] initWithArray:[NSArray arrayWithObjects:@"HX9371/04",@"HF3330/01",@"HP6581/03",@"S9711/31",@"HP8656/03",@"S9031/26",@"SCF693/17",@"SCF145/06",@"FC6168/62",@"GC9550/02",@"PR3743/00", nil]];
    hardcodedList.sector=CONSUMER;
    hardcodedList.catalog=B2C;
     //[[AppDelegate sharedAppDelegate].appInfra.serviceDiscovery setHomeCountry:@"GB"];
    [PSHandler setAppInfraTagging:[AppDelegate sharedAppDelegate].appInfra];
    [PSHandler invokeProductSelectionWithParentController:self productModelSelection:hardcodedList andCompletionHandler:^(PRXSummaryData *selectedPRXSummary) {
        DLog(@"selectedPRXSummary = %@",selectedPRXSummary);
    }];
}

- (IBAction)ChangeTheme:(id)sender {
    /*UIDTheme *newTheme;
    if (tonalRange<UIDColorRangeDefault) {
        if (colorRange<UIDTonalRangeVeryLight) {
            newTheme = [[UIDTheme alloc]initWithThemeConfiguration:[[UIDThemeConfiguration alloc]initWithColorRange:colorRange tonalRange:tonalRange navigationTonalRange:tonalRange accentColorRange:colorRange]];
            colorRange++;
        }
        else{
            tonalRange++;
            colorRange = 0;
            newTheme = [[UIDTheme alloc]initWithThemeConfiguration:[[UIDThemeConfiguration alloc]initWithColorRange:colorRange tonalRange:tonalRange navigationTonalRange:tonalRange accentColorRange:colorRange]];
        }
    }
    else
    {
        tonalRange = 0;
        colorRange = 0;
        newTheme = [[UIDTheme alloc]initWithThemeConfiguration:[[UIDThemeConfiguration alloc]initWithColorRange:colorRange tonalRange:tonalRange navigationTonalRange:tonalRange accentColorRange:colorRange]];
    }
    [[UIDThemeManager sharedInstance] setDefaultThemeWithTheme:newTheme applyNavigationBarStyling:YES];
    [self.btnChangeTheme setTheme:newTheme];
    [self.btnLaunchProductSelection setTheme:newTheme];
    
    [[UIDThemeManager sharedInstance] setNavigationBarShadowLevel:UIDNavigationShadowLevelOne];
    [self forceRefreshUIApperence];*/
    
}

-(void)forceRefreshUIApperence
{
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *appWindows = [NSArray arrayWithArray:application.windows];
    for (UIWindow *window in appWindows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}



@end
