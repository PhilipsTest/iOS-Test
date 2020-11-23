//
//  CountrySelectionViewController.h
//  PhilipsConsumerCare
//
//  Created by Niharika Bundela on 2/2/17.
//  Copyright © 2017 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CountryDataProtocol <NSObject>

-(void)getCountry:(NSString *)country countryCode:(NSString *)code;

@end
@interface DCCountrySelectionViewController : UIViewController
@property (nonatomic, weak) id <CountryDataProtocol> delegate;

@end
