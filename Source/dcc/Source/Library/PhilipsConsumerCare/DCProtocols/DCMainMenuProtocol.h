//
//  DCMainMenuProtocol.h
//  DigitalCareLibrary
//
//  Created by sameer sulaiman on 15/05/15.
// Copyright (c) Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.

#import <Foundation/Foundation.h>

/**
 * DCMainMenuDelegate is a protocol provides call back to vertical app on clicking any item in main menu
 * @since 1.0.0
 */

@protocol DCMainMenuDelegate <NSObject>

@required

/**
 *  This delegate method is used to handle the call back on selecting main menu item
 *
 *  @param item -  Menu Name
 *  @param index - Menu index position
 *
 *  @return BOOL value, YES for contolling in vertical app, NO for sending control back to DigitalCare library
 *  @since 1.0.0
 */

-(BOOL)mainMenuItemSelected:(NSString*)item withIndex:(NSInteger)index;

@end

