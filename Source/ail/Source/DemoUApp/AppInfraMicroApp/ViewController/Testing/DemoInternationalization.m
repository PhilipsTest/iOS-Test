//
//  DemoInternationalization.m
//  DemoAppInfra
//
//  Created by Ravi Kiran HR on 14/07/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoInternationalization.h"
#import <AppInfra/AppInfra.h>
#import "AilShareduAppDependency.h"


@implementation DemoInternationalization

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Internationalization";
    // get Locale object from App Infra
   NSLocale *localeobj =  [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.internationalization getUILocale];
   NSString *localeString =  [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.internationalization getUILocaleString];
    self.lblLocaleID.text = [NSString stringWithFormat:@"Short UI Locale : %@",localeobj.localeIdentifier];
    self.lblLocaleString.text =  [NSString stringWithFormat:@"Short Locale String : %@",localeString];
    self.lblHSDPLocale.text = [NSString stringWithFormat:@"Complete UI Locale : %@",[[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.internationalization getBCP47UILocale]];
}

@end
