//
//  DCSocialMenuProtocol.h
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 15/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
/**
 *  DCSocialMenuDelegate is a protocol provides a call back on selecting social menu items
 *  @since 1.0.0
 */

@protocol DCSocialMenuDelegate <NSObject>

@optional

/**
 *  This delegate method is used to handle the call back on selecting social menu item in ContactUs
 *
 *  @param item - Social menu name
 *
 *  @return BOOL value, YES for controlling in vertical app, NO for sending control back to DigitalCare library
 *  @since 1.0.0
 */
-(BOOL)socialMenuItemSelected:(NSString*)item;

@end
