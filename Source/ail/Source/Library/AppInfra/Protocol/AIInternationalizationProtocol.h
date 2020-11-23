//
//  AIInternationalizationProtocol.h
//  AppInfra
//
//  Created by Ravi Kiran HR on 12/07/16.
//  Copyright © 2016  Koninklijke Philips N.V.,  All rights are reserved. Reproduction or dissemination in whole or in part is prohibited without the prior written consent of the copyright holder.*/. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 protocol for defining Internationalization methods
 */
@protocol AIInternationalizationProtocol <NSObject>

/**
 * Get the OS locale
 *
 * @return short OS locale object, (ex: returns only en when 'English' is set as Language)
 * @since 1.1.0
 */
-(NSLocale *)getUILocale;

/**
 *  Get the OS locale as string
 *
 * @return short OS locale string, (ex: returns only en when 'English' is set as Language)
 * @since 1.1.0
 */
-(NSString *)getUILocaleString;
 
/**
  *  Get current locale as string with '-' as seperator between language and country code (HSDP supported)
  *
  * @return complete locale along with language code country code seperated by '-' (ex: returns en-US when 'English' is set as Language), while the getUILocale API returns only 'en'
  */
-(NSString *)getBCP47UILocale;

@end
