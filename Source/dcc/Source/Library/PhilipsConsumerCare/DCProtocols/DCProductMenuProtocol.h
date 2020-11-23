//
//  DCProductProtocol.h
//  DigitalCareLibrary
//
//  Created by KRISHNA KUMAR on 15/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>
/**
 *  DCProductMenuDelegate is a protocol provides a call back to vertical app on selecting product menu items
 *  @since 1.0.0
 */

@protocol DCProductMenuDelegate <NSObject>

@optional
/**
 *  This delegate method is used to handle the call back on selecting Product menu
 *
 *  @param item - Product menu name
 *
 *  @return Bool value, YES for controlling in vertical app and NO for sending the control back to DigitalCare library
 *  @since 1.0.0
 */
-(BOOL)productMenuItemSelected:(NSString*)item;

@end
